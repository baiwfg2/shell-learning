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
FLASH_PLUGIN_X64_GZ=flash_player_11-x86_64.tar.gz

NTFS_3G_GZ=ntfs-3g.tar.gz
ST3=sublime_text_3_build_3047_x64.tar.bz2

# maybe it's not 7.6,check it out
EPEL_REPO=epel-release-7-6.noarch.rpm
RPMFORGE_REPO=rpmforge-release-0.5.3-1.el7.rf.x86_64.rpm
RPMFUSION_FREE_REPO=
RPMFUSION_NONFREE_REPO=

MYHOME=/home/cshi
BIN_DIR=/home/cshi/bin
SETUP_DIR=/home/cshi/setup

FIREFOX_PLUGIN_X86_DIR=/usr/lib/mozilla/plugins
FIREFOX_PLUGIN_X64_DIR=/usr/lib64/mozilla/plugins

ARCH=`uname -m`

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

test_error() {
	test $? != 0 && echo "$1 failed" && exit 1
}

# install common packages
if ! rpm -qa | grep python-devel >/dev/null 2>&1; then
	echo y | yum install python-devel libpng-devel freetype-devel
fi

# basic directory creation
if [ ! -d $BIN_DIR ]; then
	mkdir -p $BIN_DIR
fi

if [ ! -d $SETUP_DIR ]; then
	mkdir -p $SETUP_DIR
fi

cd $SETUP_DIR
if [ ! -d oss-python-sdk ]; then
	git clone https://git.coding.net/cshi/oss-python-sdk.git
	test_error oss-python-sdk
fi

# Install Chinese input method
# There is a default pinyin method added in Settings-Region&Language on Centos 7 
# You can also install ibus-table-wubi by typing command:yum install ibus-table-wubi,
# but I like vissible better. So download it from oss://cshi-soft
# In order to make it work, you may need to log out.

if [ ! -e "/usr/share/ibus-table/tables/vissible.db" ]; then
	# mab be wrong
	if [ ! -e $VISSIBLE_GZ ]; then
		wget -c $URL_SOFT/$VISSIBLE_GZ
	fi
	tar xzf $VISSIBLE_GZ # force to uncompress
	cp vissible.db /usr/share/ibus-table/tables/
	cp vissible.gif /usr/share/ibus-table/icons/
	test_error vissible
else
	echo 'vissible installed'
fi

# install flash-plugin
which yum 1>/dev/null 2>&1
if test $? = 0; then
	if [ $ARCH = "x86" ]; then
		if [ ! -e $FLASH_PLUGIN_X86_RPM ]; then
			wget -c $URL_SOFT/$FLASH_PLUGIN_X86_RPM
		fi

		if [ ! -e $FIREFOX_PLUGIN_X86_DIR/libflashplayer.so ]; then
			rpm -ivh $FLASH_PLUGIN_X86_RPM
			test_error FLASH_PLUGIN_X86_RPM
		fi
	else
		if [ ! -e $FIREFOX_PLUGIN_X64_DIR/libflashplayer.so ]; then
			if [ ! -e ${FLASH_PLUGIN_X64_GZ} ]; then
				wget -c $URL_SOFT/$FLASH_PLUGIN_X64_GZ
			fi
			tar xzf $FLASH_PLUGIN_X64_GZ
			echo "coping ${FLASH_PLUGIN_X64_GZ%%.*}/libflashplayer.so to $FIREFOX_PLUGIN_X64_DIR..."
			cp ${FLASH_PLUGIN_X64_GZ%%.*}/libflashplayer.so $FIREFOX_PLUGIN_X64_DIR/
			test_error "libflashplayer.so"
		fi
	fi
fi

which ntfs-3g 1>/dev/null 2>&1
if test $? != 0; then
	if [ ! -e $NTFS_3G_GZ ]; then
		wget $URL_SOFT/$NTFS_3G_GZ
	fi
	tar xzf $NTFS_3G_GZ
	cd ${NTFS_3G_GZ%%.*}
	./configure --prefix=/usr  && make && make install
	test_error ntfs-3g
	cd ..
else
	echo 'nfts-3g installed'
fi

# sublime_text_3
if [ ! -e $ST3 ]; then
	wget $URL_SOFT/$i
fi
if [ ! -e $SETUP_DIR/sublime_text_3 ];then
	tar xjf $ST3
	ln -sf $SETUP_DIR/sublime_text_3/sublime_text $BIN_DIR
fi

# If uninstalled, then install them with apt-get, yum or some other tools
which yum >/dev/null 2>&1
if test $? = 0; then
	! which tree >/dev/null 2>&1 && echo y | yum install tree
else
# ubuntu system
	! which tree >dev/null 2>&1 && echo y | sudo apt-get install tree
fi

# install extra repo
#epel
if [ ! -e $SETUP_DIR/$EPEL_REPO ]; then
	wget http://dl.fedoraproject.org/pub/epel/7/x86_64/e/$EPEL_REPO -P $SETUP_DIR
	rpm -ivh $EPEL_REPO
fi

if rpm -qa | grep 'htop' >/dev/null 2>&1; then
	:
else
	yum install htop qt5-qtbase qt5-qtbase-gui
fi

#rpmforge
if [ ! -e $SETUP_DIR/$RPMFORGE_REPO ]; then
	wget http://apt.sw.be/redhat/el7/en/x86_64/rpmforge/RPMS/$RPMFORGE_REPO -P $SETUP_DIR
	rpm -ivh $RPMFORGE_REPO
fi

if rpm -qa | grep "rar" >/dev/null 2>&1; then
	:
else
	echo y | yum install rar unrar p7zip
fi

#remi
#yum localinstall --nogpgcheck http://rpms.famillecollet.com/enterprise/remi-release-7.rpm

#rmpfusion
#aliyun mirror
yum localinstall --nogpgcheck http://mirrors.aliyun.com/rpmfusion/free/el/updates/6/x86_64/rpmfusion-free-release-6-1.noarch.rpm
yum localinstall --nogpgcheck http://mirrors.aliyun.com/rpmfusion/nonfree/el/updates/6/x86_64/rpmfusion-nonfree-release-6-1.noarch.rpm

# authoriative mirror
#yum localinstall --nogpgcheck http://download1.rpmfusion.org/free/el/updates/6/i386/rpmfusion-free-release-6-1.noarch.rpm 
#yum localinstall --nogpgcheck http://download1.rpmfusion.org/nonfree/el/updates/6/i386/rpmfusion-nonfree-release-6-1.noarch.rpm


# add python repo
PYCONF=$MYHOME/.pip/pip.conf
test ! -e $MYHOME/.pip && mkdir $MYHOME/.pip
test ! -e $PYCONF && touch $PYCONF
if ! grep aliyun $PYCONF >/dev/null 2>&1; then
	cat << EOF >>$PYCONF
[global]
index-url=http://mirrors.aliyun.com/pypi/simple
EOF
fi
	
# Upon success, delete all folders
rm -rf ${NTFS_3G_GZ%%.*} ${FLASH_PLUGIN_X64_GZ%%.*} ${YUM_REPO%.*}
