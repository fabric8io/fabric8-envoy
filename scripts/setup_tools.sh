#!/bin/sh

set -x

set -e

NUM_CPUS=`grep -c ^processor /proc/cpuinfo`

# Download required tools
export ENVOY_ENV_DIR=/opt/envoy_env

# Ensuring the setup is always clean
if [ -d "$ENVOY_ENV_DIR" ]; then 
  rm -rf $ENVOY_ENV_DIR
  mkdir -p $ENVOY_ENV_DIR
  chown -R vagrant:vagrant $ENVOY_ENV_DIR
fi

cd $ENVOY_ENV_DIR

# gcc
wget http://www.netgull.com/gcc/releases/gcc-4.9.4/gcc-4.9.4.tar.gz
tar zxf gcc-4.9.4.tar.gz
mkdir -p objdir
cd objdir
$PWD/../gcc-4.9.4/configure --prefix=$PWD/../gcc-4.9.4 --enable-languages=c,c++ --disable-multilib
make -j $NUM_CPUS
make install
cd ..
export PATH=$PWD/gcc-4.9.4/bin:$PATH
export CC=`which gcc`
export CXX=`which g++`

# Build artifacts
THIRDPARTY_DIR=$PWD/thirdparty
THIRDPARTY_BUILD=$PWD/thirdparty_build
mkdir -p $THIRDPARTY_DIR
mkdir -p $THIRDPARTY_BUILD
cd $THIRDPARTY_DIR

# libevent
wget https://github.com/libevent/libevent/releases/download/release-2.1.8-stable/libevent-2.1.8-stable.tar.gz
tar xf libevent-2.1.8-stable.tar.gz
cd libevent-2.1.8-stable
./configure --prefix=$THIRDPARTY_BUILD --enable-shared=no --disable-libevent-regress --disable-openssl
make install
cd ..

# boring ssl
git clone https://boringssl.googlesource.com/boringssl
cd boringssl
git reset --hard b87c80300647c2c0311c1489a104470e099f1531
cmake .
make
cp -r include/* $THIRDPARTY_BUILD/include
cp ssl/libssl.a $THIRDPARTY_BUILD/lib
cp crypto/libcrypto.a $THIRDPARTY_BUILD/lib
cd ..

# gperftools
wget https://github.com/gperftools/gperftools/releases/download/gperftools-2.5/gperftools-2.5.tar.gz
tar xf gperftools-2.5.tar.gz
cd gperftools-2.5
./configure --prefix=$THIRDPARTY_BUILD --enable-shared=no --enable-frame-pointers
make install
cd ..

# nghttp2
wget https://github.com/nghttp2/nghttp2/releases/download/v1.20.0/nghttp2-1.20.0.tar.gz
tar xf nghttp2-1.20.0.tar.gz
cd nghttp2-1.20.0
./configure --prefix=$THIRDPARTY_BUILD --enable-shared=no --enable-lib-only
make install
cd ..

# protobuf
wget https://github.com/google/protobuf/releases/download/v3.0.0/protobuf-cpp-3.0.0.tar.gz
tar xf protobuf-cpp-3.0.0.tar.gz
cd protobuf-3.0.0
./configure --prefix=$THIRDPARTY_BUILD --enable-shared=no
make install
cd ..

# cotire
wget https://github.com/sakra/cotire/archive/cotire-1.7.8.tar.gz
tar xf cotire-1.7.8.tar.gz

# spdlog
wget https://github.com/gabime/spdlog/archive/v0.11.0.tar.gz
tar xf v0.11.0.tar.gz

# http-parser
wget -O http-parser-v2.7.0.tar.gz https://github.com/nodejs/http-parser/archive/v2.7.0.tar.gz
tar xf http-parser-v2.7.0.tar.gz
cd http-parser-2.7.0
$CC -O2 -c http_parser.c -o http_parser.o
ar rcs libhttp_parser.a http_parser.o
cp libhttp_parser.a $THIRDPARTY_BUILD/lib
cp http_parser.h $THIRDPARTY_BUILD/include
cd ..

# tclap
wget -O tclap-1.2.1.tar.gz https://sourceforge.net/projects/tclap/files/tclap-1.2.1.tar.gz/download
tar xf tclap-1.2.1.tar.gz

# lightstep
wget https://github.com/lightstep/lightstep-tracer-cpp/releases/download/v0_19/lightstep-tracer-cpp-0.19.tar.gz
tar xf lightstep-tracer-cpp-0.19.tar.gz
cd lightstep-tracer-cpp-0.19
./configure --disable-grpc --prefix=$THIRDPARTY_BUILD --enable-shared=no \
  protobuf_CFLAGS="-I$THIRDPARTY_BUILD/include" protobuf_LIBS="-L$THIRDPARTY_BUILD/lib -lprotobuf"
make install
cd ..

# rapidjson
wget -O rapidjson-1.1.0.tar.gz https://github.com/miloyip/rapidjson/archive/v1.1.0.tar.gz
tar xf rapidjson-1.1.0.tar.gz

# google test
wget -O googletest-1.8.0.tar.gz https://github.com/google/googletest/archive/release-1.8.0.tar.gz
tar xf googletest-1.8.0.tar.gz
cd googletest-release-1.8.0
cmake -DCMAKE_INSTALL_PREFIX:PATH=$THIRDPARTY_BUILD .
make install
cd ..

# gcovr
wget -O gcovr-3.3.tar.gz https://github.com/gcovr/gcovr/archive/3.3.tar.gz
tar xf gcovr-3.3.tar.gz