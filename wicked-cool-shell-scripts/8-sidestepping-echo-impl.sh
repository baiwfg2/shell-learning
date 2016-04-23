#!/bin/sh 

# not all platform have the same 'echo' meaning
# -n option differs, so the script implement a universal one

function echo1 {
	# original code in book is wrong. It lacks the comma !!
	echo "$*" | awk '{ printf "%s",$0 }'
}

echo2() {
	printf "%s" "$*"
}

echo3() {
	echo "$*" | tr -d '\n'
}

# test

echo1 "echo1"
echo2 "echo2"
echo3 "echo3"
