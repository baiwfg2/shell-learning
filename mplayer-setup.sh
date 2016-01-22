#!/bin/sh

# http://www.bkjia.com/Linuxjc/864803.html
svn checkout svn://svn.mplayerhq.hu/mplayer/trunk mplayer
cd mplayer
svn update

cd ..
wget http://www.mplayerhq.hu/MPlayer/releases/codecs/essential-amd64-20071007.tar.bz2
tar -xaf essential-amd64-20071007.tar.bz2

mkdir /usr/local/lib/codecs
mv essential-amd64-20071007/* /usr/local/lib/codecs

cd mplayer
./configure --enable-gui --language=zh_CN --prefix=/home/cshi/setup/mplayer
make -j2 && make install

## download skin
# www.mplayerhq.hu/MPlayer/skins

wget http://www.mplayerhq.hu/MPlayer/skins/Blue-1.10.tar.bz2
tar -xaf Blue-1.10.tar.bz2 -C /home/cshi/setup/mplayer/share/mplayer/skins
cd /home/cshi/setup/mplayer/share/mplayer/skins/Blue
ln -s Blue/ default

