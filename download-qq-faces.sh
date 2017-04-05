#!/bin/sh 

url=http://cache.soso.com/img/img/e
num=100
ext=.gif

while [ $num -le 204 ]
do
	wget $url$num$ext -P /tmp/qq-face
	num=$((++num))
done

echo "QQ Face downloaded at /tmp/qq-face"
