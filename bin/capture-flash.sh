#!/bin/bash

RECPATH=/tmp
PIDS=`ps aux | grep libflashplayer | grep -v npwrapper | grep -v grep | awk '{print $2}'`
for PID in $PIDS
do
	FFILES=`ls -la /proc/$PID/fd/* | grep Flash | awk '{print $9}'`
	for FFILE in $FFILES
	do
		FNAME=`mktemp`
		cp -f $FFILE $FNAME
		NNAME=~/flashvids/${FNAME##*/}
		mv $FNAME $NNAME
	echo "Recovered file: " $NNAME
	done
done

