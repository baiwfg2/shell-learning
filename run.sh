#!/bin/sh 

if [ "$#" -ne 1 ];then
	echo "run.sh [comment]"
	exit 1
fi

find . -name a.out -exec rm -f {} \;
git add --all .
git commit -m "$1"
git push origin master
