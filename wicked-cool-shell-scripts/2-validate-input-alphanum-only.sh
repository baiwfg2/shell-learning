#!/bin/sh 

# Ensures that input consists only of alphbetical and numeric
# characters

validAlphaNum() {
	compressed="$(echo $1 | sed -e 's/[^[[:alnum:]]//g')"
	# input is global variable !!
	if [ "$compressed" != "$input" ]; then
		return 1
	else
		return 0
	fi
}

echo -n "Enter input:"
read input

if ! validAlphaNum "$input"; then
	echo "Your input must consists of letter and numbers" >&2
	exit 1
else
	echo "valid"
fi

exit 0
