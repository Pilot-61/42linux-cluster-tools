#!/bin/bash

# Set installation directory replace mes-salh by ur login
INSTALL_DIR="/home/mes-salh/goinfre/gcc_local"
BUILD_DIR="/home/mes-salh/goinfre/gcc_build"
GCC_VERSION="13.2.0"

# Clean previous installation
rm -rf $INSTALL_DIR
rm -rf $BUILD_DIR

# Create necessary directories
mkdir -p $INSTALL_DIR
mkdir -p $BUILD_DIR
cd $BUILD_DIR

# Download GCC
wget https://ftp.gnu.org/gnu/gcc/gcc-$GCC_VERSION/gcc-$GCC_VERSION.tar.gz
tar xzf gcc-$GCC_VERSION.tar.gz
cd gcc-$GCC_VERSION

# Download prerequisites
./contrib/download_prerequisites

# Configure GCC build with C++ support
./configure \
  --prefix=$INSTALL_DIR \
  --enable-languages=c,c++ \
  --disable-multilib \
  --disable-bootstrap \
  --with-system-zlib \
  --enable-libstdc++-v3

# Build and install (adjust -j4 based on your CPU cores)
make -j4
make install

# Add these lines to your ~/.zshrc if not already present
echo "# GCC local installation" >> ~/.zshrc
echo "export PATH=\"$INSTALL_DIR/bin:\$PATH\"" >> ~/.zshrc
echo "export LD_LIBRARY_PATH=\"$INSTALL_DIR/lib64:\$LD_LIBRARY_PATH\"" >> ~/.zshrc
echo "export LIBRARY_PATH=\"$INSTALL_DIR/lib64:\$LIBRARY_PATH\"" >> ~/.zshrc
echo "export CPLUS_INCLUDE_PATH=\"$INSTALL_DIR/include/c++/$GCC_VERSION:\$CPLUS_INCLUDE_PATH\"" >> ~/.zshrc
