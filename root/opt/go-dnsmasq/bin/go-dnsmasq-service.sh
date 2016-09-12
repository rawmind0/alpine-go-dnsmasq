#!/usr/bin/env bash

SERVICE_LOG_DIR=${SERVICE_LOG_DIR:-${SERVICE_HOME}"/log"}
SERVICE_LOG_FILE=${SERVICE_LOG_FILE:-${SERVICE_LOG_DIR}"/"${SERVICE_NAME}".out"}
SERVICE_PID_FILE=${SERVICE_PID_FILE:-${SERVICE_LOG_DIR}"/"${SERVICE_NAME}".pid"}
SERVICE_STDOUT=${SERVICE_STDOUT:-"/proc/1/fd/1"}

function log {
        echo `date` $ME - $@
}

function serviceDefault {
    log "[ Applying default ${SERVICE_NAME} configuration... ]"
    ${SERVICE_HOME}/bin/${SERVICE_NAME}-source.sh
}

function serviceConf {
    log "[ Applying dinamic ${SERVICE_NAME} configuration... ]"
    while [ ! -f ${SERVICE_CONF} ]; do
        log "  Waiting for ${SERVICE_NAME} configuration..."
        sleep 3 
    done
}

function serviceLog {
    log "[ Redirecting ${SERVICE_NAME} log to stdout... ]"
    if [ ! -L ${SERVICE_LOG_FILE} ]; then
        rm ${SERVICE_LOG_FILE}
        ln -sf ${SERVICE_STDOUT} ${SERVICE_LOG_FILE}
    fi

    if [ ! -L ${SERVICE_HOME}/nohup.out ]; then
        rm ${SERVICE_HOME}/nohup.out
        ln -sf ${SERVICE_STDOUT} ${SERVICE_HOME}/nohup.out
    fi
}

function serviceCheck {
    log "[ Checking ${SERVICE_NAME} configuration... ]"

    if [ -d "/opt/tools" ]; then
        serviceConf
    else
        serviceDefault
    fi
    source ${SERVICE_CONF}

    SERVICE_ARGS=${SERVICE_ARGS:-""}

    if [ -n "$STUB_ZONES" ]; then
        for i in $(echo ${STUB_ZONES} | sed -e s'/,/ /g') 
        do 
            SERVICE_ARGS=${SERVICE_ARGS}" -z $i" 
        done
    fi
}

function serviceStart {
    log "[ Starting ${SERVICE_NAME}... ]"
    serviceCheck
    serviceLog
    nohup ${SERVICE_HOME}/bin/go-dnsmasq ${SERVICE_ARGS} &
    echo $! > ${SERVICE_PID_FILE}
}

function serviceStop {
    log "[ Stoping ${SERVICE_NAME}... ]"

    if [ -f ${SERVICE_PID_FILE} ]; then
        pid=$(cat ${SERVICE_PID_FILE})
        rm ${SERVICE_PID_FILE}
    else 
        pid=$(ps -ef | grep -w ${SERVICE_HOME}'/bin/go-dnsmasq' | grep -v grep | awk '{print $1}')
    fi

    if [ "x$pid" != "x" ]; then 
        kill -SIGTERM $pid
        sleep 2

        killed=$(ps -ef | grep -w $pid | grep -v grep ; echo $?)
        while [ $killed -ne 1 ]; do
            kill -SIGTERM $pid
            sleep 2
            killed=$(ps -ef | grep -w $pid | grep -v grep ; echo $?)
        done
    fi
}


function serviceRestart {
    log "[ Restarting ${SERVICE_NAME}... ]"
    serviceStop
    serviceStart
    /opt/monit/bin/monit reload
}

case "$1" in
        "start")
            serviceStart &> ${SERVICE_STDOUT}
        ;;
        "stop")
            serviceStop &> ${SERVICE_STDOUT}
        ;;
        "restart")
            serviceRestart &> ${SERVICE_STDOUT}
        ;;
        *) 
            echo "Usage: $0 restart|start|stop"
            exit 1
        ;;

esac

exit 0
