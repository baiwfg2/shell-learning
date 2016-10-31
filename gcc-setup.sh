tar -xjvf gmp-4.3.2.tar.bz2
cd gmp-4.3.2
./configure
make && make install

cd ..
tar -xjvf mpfr-2.4.2.tar.bz2
cd mpfr-2.4.2
./configure
make && make install

cd ..
tar -xzvf mpc-0.8.1.tar.gz
cd mpc-0.8.1
./configure
make && make install

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib

cd ..
echo 'installng gcc-4.9.3...'
tar -xjf gcc-4.9.3.tar.bz2
cd gcc-4.9.3
mkdir gcc-build-4.9.3
cd gcc-build-4.9.3
../configure --enable-checking=release --enable-language=c,c++,go --disable-multilib --enable-thread=posix
make -j2 && make install

cd ../..
echo 'done'
