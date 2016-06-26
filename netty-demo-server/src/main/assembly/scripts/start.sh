#!/usr/bin/env bash

function quit()
{
    echo "exit program"
    exit 1;
}

SERVER_NAME=HttpFileServer
#return if process exits

PIDS=`ps -ef | grep $SERVER_NAME | grep -v "grep" | awk '{print $2}'`
echo "PIDS=$PIDS"
if [ -n "$PIDS" ];then
   echo "progress:$SERVER_NAME is running,so exit,if want to restart please run stop.sh first";
   quit;
fi

#make log dir dir if not exist
logDir=/logs/im/client
function mkLogDir(){
    if [ ! -e $logDir ]
    then
        mkdir -p $logDir
    fi
}
mkLogDir
#chmod 777 $logDir
#run java program
binPath=$(cd "$(dirname "$0")"; pwd);
cd $binPath
cd ..
parentPath=`pwd`
libPath=$parentPath/lib/
logFile="$logDir/im-client.log"


function exportClassPath(){
    jarFileList=`find "$libPath" -name *.jar |awk -F'/' '{print $(NF)}' 2>>/dev/null`
    CLASSPATH=".:$binPath";
    for jarItem in $jarFileList
      do
        CLASSPATH="$CLASSPATH:$libPath$jarItem"
    done
    CLASSPATH=$CLASSPATH:./conf
    export CLASSPATH
}
#ulimit -n 65535
exportClassPath


nohup java -server -Xms4g -Xmx4g -Xss2m -XX:PermSize=512m -XX:MaxPermSize=512m -XX:NewRatio=2  -XX:+UseGCOverheadLimit -XX:-UseParallelGC -XX:ParallelGCThreads=24 -Dio.netty.leakDetection.level=advanced -Dim-client=$logFile  com.netty.server.http.HttpFileServer >> $logFile  2>&1 &