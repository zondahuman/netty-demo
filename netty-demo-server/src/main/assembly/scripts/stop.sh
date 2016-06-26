#!/bin/bash

function quit()
{
    echo "exit program"
    exit 1;
}

read -p " are you sure kill router?[y/n]" response
case $response in
    [nN])
        echo "exit stop.sh"
        quit;
        ;;
    *)
        ;;
esac

######check Router Process######
SERVER_NAME="RouterServer"
PIDS=`ps -ef | grep $SERVER_NAME | grep -v "grep" | awk '{print $2}'`  
echo "PIDS=$PIDS"
if [ -z $PIDS ]; then  
    echo "no this process"  
else  
    echo "find process is $PIDS"  
fi

logDir="/logs/im/router"
logFile="$logDir/heika-router.log"
#####kill RouterServer####
echo -e "Stopping the $SERVER_NAME ...\c"
for PID in $PIDS ; do
    kill  $PID $logFile 2>&1
done

echo "execute completed,has run the command of kill [pid]."
