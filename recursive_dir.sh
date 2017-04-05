#!/bin/sh

recursive_dir() {
	local cur_dir parentd_dir work_dir
	work_dir=$1
	cd $work_dir
	if [ $work_dir = "/" ];then
		cur_dir=""
	else
		cur_dir=$(pwd)
	fi
	
	for dirlist in $(ls ${cur_dir} > /dev/null)
	do
		if test -d $dirlist; then
			cd $dirlist
			recursive_dir $cur_dir/$dirlist
			cd ..
		else
			echo $cur_dir/$dirlist
		fi
	done
}

###########################################
generate_index() {
	dir=$1
	files=`ls -l $dir | tr -s ' ' | cut -f10 -d ' '`

	echo > $dir/index.html
	for f in $files
	do
		if [ "$f" = "index.html" ];then
			continue
		fi
		echo "<a href=\"$f\">$f</a></br>" >> $dir/index.html
	done
}
recursive_generate_index() {
	local cur_dir
	cur_dir=$1
	cd $cur_dir
	generate_index $cur_dir

	for dirlist in $(ls ${cur_dir} > /dev/null)
	do
		ls $dirlist
		if [ -d "$dirlist" ];then
			cd $dirlist
			recursive_generate_index $cur_dir/$dirlist
			cd ..
		fi
	done
}

# Whether quotes are added for $1 really matters !!
if test -d "$1"; then
	recursive_dir $1
	#recursive_generate_index $1
fi

