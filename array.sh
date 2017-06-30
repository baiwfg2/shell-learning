#!/bin/sh 

# http://www.cnblogs.com/Joke-Shi/p/5705856.html
# http://blog.csdn.net/zhuying_linux/article/details/6778877

#str="ab abef acb d"
#echo "str=$str"
# this makes varible arr an array !!
#arr=($str) 

# 默认要以空格作分隔符，如果初使不是，就转化一下
str2="1.1.1.1#2.2.2.2#3.3.3.3"
arr=($(echo $str2 | tr '#' ' '))

echo "arr first element is $arr" #这样打印只能取得第一个元素
len=${#arr[@]} # 取得数组的长度
echo "len $len"

print() {
	for ((i=0; i<$len; i++))
	do
		echo ${arr[$i]} #访问各个元素，下标从0开始
	done
}

print2() {
	echo "not have body is disallowed"
}

print3() {
	for v in ${arr[*]}; do
		echo $v
	done
}

print
arr[2]=100
echo "after modify arr[2]"
print
echo 
arr[10]=10 #被追加到尾部，但下标不是10,并不会填充多余空间
len=${#arr[@]} #在此处的修改竟不能被print识别到，它还是用以前的值?? shell允许变量重新定义
echo "after add arr[10]=10, cur len= $len, but variable len doesn't change"
print

echo "idx from 1 to 3: ${arr[@]:1:3}"; echo

unset arr[1] #清除某个元素
echo "after unset arr[1],len=${#arr[@]}"  #len=4,size是跟着变的
print3 #它与print不同，它不是根据len值，而是根据实际size

echo
unset arr[0]
echo "after unset arr[0],len=${#arr[@]}"  # len=3
print3

echo
#unset arr; print #清除整个数组
