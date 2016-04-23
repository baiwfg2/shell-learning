#!/bin/sh 

anonpass="$LOGNAME@$(hostname)"

# example file:ftp://ftp.gnu.org/gnu/grub/grub-2.00.tar.gz

if [ $# -ne 1 ]; then
	echo "Usage: $0 ftp://..." >&2
	exit 1
fi

if [ "$(echo $1 | cut -c1-6)" != "ftp://" ]; then
	echo "$0: url invalid" >&2
	exit 1
fi

server="$(echo $1 | cut -d/ -f3)"
filename=`echo $1 | cut -d/ -f4-`
basefile=`basename $filename`

echo "$0: Downloading $basefile from server $server"

ftp -n << EOF
open $server
user ftp $anonpass
get $filename $basefile
quit
EOF

if [ $? -eq 0 ]; then
	ls -l $basefile
fi
exit 0
