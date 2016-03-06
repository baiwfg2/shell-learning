#!/bin/sh 

url=http://cache.soso.com/img/img/e
num=100
ext=.gif

while [ $num -le 204 ]
do
	wget /tmp/$url$num$ext
	num=$((++num))
done
