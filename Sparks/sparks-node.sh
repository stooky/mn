#!/bin/bash

PID_FILE='/home/masternode/Sparksd.pid'

start() {
       touch $PID_FILE
       eval "/bin/su masternode -c '/usr/bin/Sparksd 2>&1 >> /dev/null'"
       PID=$(ps aux | grep Sparksd | grep -v grep | awk '{print $2}')
       echo "Starting Sparksd with PID $PID"
       echo $PID > $PID_FILE
}
stop () {
       pkill Sparksd
       rm $PID_FILE
       echo "Stopping Sparksd"
}

case $1 in
    start)
       start
       ;;
    stop)  
       stop
       ;;
     *)  
       echo "usage: Sparks {start|stop}" ;;
 esac
 exit 0
