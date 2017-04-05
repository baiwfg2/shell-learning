#!/bin/sh 

for i in 1 2 3 4 5 #有没有引号差别很大
do
	echo "i=$i"
done

for f in ~/.bash*
do
	echo $f
done
