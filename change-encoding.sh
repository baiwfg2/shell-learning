#!/bin/sh 

which iconv > /dev/null 2>&1
if [ "$?" -ne 0 ];then
	echo "iconv not found"
	exit 1
fi

ext="$1"
src_encode="$2"
dst_encode="$3"

if [ "$#" -ne 3 ]; then
	echo "usage: ./change-encoding.sh extension src_encode dst_encode"
	exit 1
fi

files=`find . -name "*.$ext"`

for i in $files
do
	echo $i
	filename=$(basename $i)
	if iconv -f $src_encode -t $dst_encode $(dirname $i)/$filename -o tmp; then
		cp -f tmp $(dirname $i)/$filename
	else
		echo "convert $filename failed"
	fi
done

