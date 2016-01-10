#!/bin/sh

# Make sure this script can be executed anywhere under root directory

# This script can perform installations of the following packages:
#	vim-config, foxit_reader, sublime_text, flash_plugin, vissible, nfts-3g
# And other package such as transmission, libX11-devel, source navigator
# are not included

# variable definition
PREFIX_SOFT=cshi-soft
PREFIX_PIC=cshi-pic
PREFIX_MUSIC=cshi-music

SUFFIX_HOST=oss-cn-beijing.aliyuncs.com

URL_SOFT=$PREFIX_SOFT.$SUFFIX_HOST
URL_PIC=$PREFIX_PIC.$SUFFIX_HOST
URL_MUSIC=$PREFIX_MUSIC.$SUFFIX_HOST

# Software package name definition
VISSIBLE_GZ=vissible-ibus.tar.gz
vissible_dir=${VISSIBLE_GZ%%.*}

FLASH_PLUGIN_X86_RPM=flash-plugin-x86-11.2.rpm
FLASH_PLGUIN_X64_GZ=flash_player_11-x86_64.tar.gz

NTFS_3G_GZ=ntfs-3g.tar.gz
PACKAGE_ARGS="sublime_text_3.tar.gz foxit_reader.tar.gz"

BIN_DIR=$HOME/bin
SETUP_DIR=$HOME/setup

FIREFOX_PLUGIN_X86_DIR=/usr/lib/mozilla/plugins
FIREFOX_PLUGIN_X64_DIR=/usr/lib64/mozilla/plugins

ARCH=`uname -m`

# basic directory creation
if [ ! -d $BIN_DIR ]; then
	mkdir -p $BIN_DIR
fi

if [ ! -d $SETUP_DIR ]; then
	mkdir -p $SETUP_DIR
fi

cd $SETUP_DIR

wget_and_untar() {
	if [ ! -e $1 ]; then
		wget -c $URL_SOFT/$1
		if test $? != 0; then
			echo 'wget failed'
			exit 1
		fi
	fi
	echo "uncompressing $1..."

	if [ ${1#*tar.} = "gz" ];then
		tar xzf $1
	elif [ ${1#*tar.} = 'bz2' ];then
		tar jxf $1
	else
		echo "compressed package format error"
		exit 1
	fi
}

# First of all, download oss_python_sdk.zip from 
# http://cshi-tools.oss-cn-beijing.aliyuncs.com/oss_python_sdk.zip

if [ ! -e oss_python_sdk.zip ]; then
	wget -c cshi-tools.$SUFFIX_HOST/oss_python_sdk.zip
	unzip -x oss_python_sdk.zip
	if [ $? -ne 0 ]; then
		echo "unzip error"
		exit 1
	else
		rm -f oss_python_sdk.zip
	fi
fi

# Install Chinese input method
# There is a default pinyin method added in Settings-Region&Language on Centos 7 
# You can also install ibus-table-wubi by typing command:yum install ibus-table-wubi,
# but I like vissible better. So download it from oss://cshi-soft
# In order to make it work, you may need to log out.

if [ ! -e "/usr/share/ibus-table/tables/vissible.db" ]; then
	wget_and_untar $VISSIBLE_GZ
	cp vissible.db /usr/share/ibus-table/tables/
	cp vissible.gif /usr/share/ibus-table/icons/
	rm -rf $vissible_dir
else
	echo 'vissible installed'
fi

# install flash-plugin
which yum 1>/dev/null 2>&1
if test $? = 0; then
	if [ $ARCH = "x86" ]; then
		if [ ! -e $FIREFOX_PLUGIN_X86_DIR/libflashplayer.so ]; then
			wget -c $URL_SOFT/$FLASH_PLUGIN_X86_RPM
		fi
		rpm -ivh $FLASH_PLUGIN_X86_RPM
	else
		if [ ! -e $FIREFOX_PLUGIN_X64_DIR/libflashplayer.so ]; then
			wget_and_untar $FLASH_PLGUIN_X64_GZ	
		fi
		cp ${FALSH_PLUGIN_X64_GZ%%.*}/libflashplayer.so $FLASH_PLUGIN_X64_DIR/
		test $? != 0 && echo 'cp libflashplayer.so failed' && exit 1
		rm -rf ${FLASH_PLUGIN_X64_GZ%%.*}
	fi
fi

which ntfs-3g 1>/dev/null 2>&1
if test $? != 0; then
	wget_untar $NTFS_3G_GZ
	cd ${NTFS_3G_GZ%%.*}
	./configure && make && make install
	if test $? != 0; then
		echo 'compile ntfs-3g failed'
		exit 1
	fi
	cd ..
	rm -rf ${NTFS_3G%%.*}
else
	echo 'nfts-3g installed'
fi

for i in $PACKAGE_ARGS
do
	dir=${i%%.*}
	if [ ! -d $SETUP_DIR/$dir ]; then
		wget_and_untar $i
		mv $dir $SETUP_DIR/
	else
		echo "$i installed"
	fi
done
ln -sf $SETUP_DIR/foxit_reader/foxit_reader $HOME/bin
ln -sf $SETUP_DIR/sublime_text_3/sublime_text $HOME/bin
#ln -sf $SETUP_DIR/foxit_reader/foxit_reader $HOME/bin

# If uninstalled, then install them with apt-get, yum or some other tools
which yum >/dev/null 2>&1
if test $? = 0; then
	! which tree >/dev/null 2>&1 && echo y | yum install tree
else
# ubuntu system
	! which tree >dev/null 2>&1 && echo y | sudo apt-get install tree
fi
