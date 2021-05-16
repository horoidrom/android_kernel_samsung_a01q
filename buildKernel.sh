#!/bin/bash

# Check if have toolchain folder
if [ ! -d "$(pwd)/gcc/" ]; then
   git clone https://android.googlesource.com/platform/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9 gcc -b android-9.0.0_r59 --depth 1 >> /dev/null 2> /dev/null
fi

# Export KBUILD flags
export KBUILD_BUILD_USER="$(whoami)"
export KBUILD_BUILD_HOST="$(uname -n)"

# Export ARCH/SUBARCH flags
export ARCH="arm64"
export SUBARCH="arm64"

# Export ANDROID VERSION
export ANDROID_MAJOR_VERSION="q"

# Export CCACHE
export CCACHE_EXEC="$(which ccache)"
export CCACHE="${CCACHE_EXEC}"
export CCACHE_COMPRESS="1"
export USE_CCACHE="1"
ccache -M 50G

# Export toolchain/cross flags
export TOOLCHAIN="aarch64-linux-android-"
export CROSS_COMPILE="$(pwd)/gcc/bin/${TOOLCHAIN}"

# Export DTC_EXT
KERNEL_MAKE_ENV="DTC_EXT=$(pwd)/tools/dtc"

# Export if/else outdir var
export WITH_OUTDIR=true

# Clear the console
clear

# Remove out dir folder and clean the source
if [ "${WITH_OUTDIR}" == true ]; then
   if [ -d "$(pwd)/out" ]; then
      rm -rf out
   fi
fi

# Build time
if [ "${WITH_OUTDIR}" == true ]; then
   if [ ! -d "$(pwd)/out" ]; then
      mkdir out
   fi
fi

if [ "${WITH_OUTDIR}" == true ]; then
   "${CCACHE}" make O=out $KERNEL_MAKE_ENV samsung/a01q_eur_open_defconfig
   "${CCACHE}" make -j18 O=out $KERNEL_MAKE_ENV
fi

# Create dtbo.img
tools/mkdtimg create out/arch/arm64/boot/dtbo.img --page_size=2048 $(find out -name "*.dtbo")