#!/bin/sh 

t1() {
	a=1

	if [ $a = 1 ]; then
		echo a=1
	fi

	echo "test grep with [``]"
	if [ ! `grep 'cshi' /etc/passwd` ]; then
		echo found
	fi

	echo "test grep with no []"
	if grep 'cshi' /etc/passwd > /dev/null; then
		echo found
	fi

	echo "cannot write like this!"
#if [ grep 'cshi' /etc/passwd ]; then
#	echo found
#fi
}

t2() {
	data="ab;cd"
	IFS=';'
	read -ra arr <<< "data"
	echo $data
	for i in "${addr[@]}";do
		echo $i
	done
}

t2
