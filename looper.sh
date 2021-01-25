#!/bin/bash
while :
do
	echo "Press [CTRL+C] to stop.."
        PODID=`sudo crictl ps|grep metal|grep dns|awk {'print $1'}`
        echo Stopping $PODID
        sudo crictl stop $PODID
	sleep 5
done


#PODID=`sudo crictl ps|grep metal|grep dns|awk {'print $1'}`
#echo $PODID
