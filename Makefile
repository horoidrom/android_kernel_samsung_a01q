BUILD GUIDE

Set the toolchain
export CROSS_COMPILE=/workspace/km01/compiler/bin/aarch64-linux-android-
export ARCH=arm64
make O=./out samsung/a01q_eur_open_defconfig
make O=out

You will get Image.gz in,
out/arch/arm64/boot/..

You will get wlan.ko in
out/drivers/staging/prima/..

To Get Pronto_Wlan.ko
aarch64-linux-gnu-strip --strip-unneeded --strip-debug out/drivers/staging/prima/wlan.ko && cp -rf out/drivers/staging/prima/wlan.ko out/drivers/staging/prima/pronto_wlan.ko

You will get  pronto_Wlan.ko
out/drivers/staging/prima/..

Flash kerenl using anykernel and replace pronto_Wlan.ko in vendor/lib/modules/...
