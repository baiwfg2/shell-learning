#!/bin/sh 

# inpath - Verifies that a specified program is either valid as is,
#	or that is can be found in the PATH list

# Given a command and the PATH, try to find the command.
# Returns 0 if found and executable, 1 if not.
# Note that this temporaily modifies IFS but restores it upon completion
in_path() {
	cmd=$1 path=$2 retval=1 oldIFS=$IFS IFS=":"
	for dir in $path 
	do
		if [ -x $dir/$cmd ]; then
			retval=0
		fi
	done
	IFS=$oldIFS 
	return $retval
}

checkForCmdInPath() {
	var=$1
	if [ "$var" != "" ]; then
		# ? and * are wildcard character
		# does the same thing as "$(echo $var | cut -c1)"
		if [ "${var%${var#?}}" = "/" ]; then
			if [ ! -x $var ]; then
				return 1
			fi
		elif ! in_path $var $PATH; then
			return 2
		fi
	fi
}

# test

if [ "$#" -ne 1 ];then
	echo "Usage: $0 command" >&2; exit 1
fi
checkForCmdInPath "$1"
case $? in 
	0) echo "$1 found in PATH";;
	1) echo "$1 not found or not executable";;
	2) echo "$1 not found in PATH";;
esac

exit 0
