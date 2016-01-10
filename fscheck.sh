#!/bin/bash 

#
# Program:fscheck.sh
# assigned by Redhat when i was interviewed
#
# Author:Chen Shi <baiwfg2@gmail.com>
#
# Date:2015/5/20 12:00

which df >/dev/null 2>&1

if [ $? != 0 ];then
	echo "df NOT FOUND"
fi

df -m | awk '{print $1,$4,$5}' >tmp
sed '1d' tmp >tmpfile
rm tmp

# set initial value
size=5
ratio=80

# read the command prompt
while [ $# -gt 0 ]
do
	case $1 in
	-a)
		shift
		size=$1
		;;
	-u)
		shift
		ratio=$1
		;;
	-h)
		echo "fscheck [-a size] [-u ratio] [-h]"
		exit 0
		;;
	*)
		echo "invalid option"
		exit 1
		;;
	esac
	shift 
done

flag=0
while read fs available_size used_ratio
do
	available_size=`echo "scale=2;$available_size/1024.0" | bc`
	diff=`echo "$available_size<$size" | bc`
	
	if [ $diff = 1 -o ${used_ratio%%%} -gt $ratio ]; then
		if [ $flag = 0 ]; then
			flag=1
			printf "%-10s\t%10s\t%s\n" "FileSystem" "Avaiable Size" "Usage"
		fi
		printf "%-10s\t%.2fG\t\t%s\n" $fs $available_size $used_ratio
	fi
	
done <tmpfile

rm tmpfile






