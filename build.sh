#!/bin/bash

# Build script for Electron kernel for angler
# Based on RenderBroken's shamu script


# Variables
export ARCH=arm
export SUBARCH=arm
export CROSS_COMPILE=placholder
THREAD="-j$(bc <<< "$(grep -c ^processor /proc/cpuinfo)+2""
DEFCONFIG="angler_defconfig"
KROOT="$(pwd)"
AK_DIR="$KROOT/anykernel"
PATCH_DIR="$AK_DIR/patch"
MODULES_DIR="$AK_DIR/modules"
ZIP_MOVE="$KROOT/out"
ZIMAGE_DIR="$KROOT/arch/arm/boot"
REL="1"


# Functions
function clean_all {
		cd $AK_DIR
		rm -rf $MODULES_DIR/*
		rm -rf zImage-dtb
		rm -rf zImage
		cd $KROOT
		echo
		make mrproper
}

function make_kernel {
		echo
		make $DEFCONFIG
		make $THREAD
		cp -vr $ZIMAGE_DIR/$zImage-dtb $AK_DIR/zImage
}

function make_modules {
		find $KROOT -name '*.ko' -exec cp -v {} $MODULES_DIR \;
}

function make_zip {
		cd $AK_DIR
		zip -r9 Electron-Release-"$REL".zip *
		if ! [ -d "$ZIP_MOVE" ]; then
		  mkdir $ZIP_MOVE
		fi;
		mv Electron-Release-"$REL".zip $ZIP_MOVE
		cd $KERNEL_DIR
}


while read -p "Clean before build (y/n)? " cchoice
do
case "$cchoice" in
	y|Y )
		clean_all
		echo
		echo "All Cleaned now."
		break
		;;
	n|N )
		break
		;;
	* )
		echo
		echo "Invalid try again!"
		echo
		;;
esac
done

# Compile Kernel
echo "Compiling Kernel.."
DATE_START=$(date +"%s")
make_kernel
DATE_KERNEL_END=$(date +"%s")
make_modules
make_zip
DATE_END=$(date +"%s")

echo -e "${red}"
echo "----------------------"
echo " Kernel Completed in:"
echo "----------------------"
echo -e "${restore}"
KDIFF=$(($DATE_KERNEL_END - $DATE_START))
echo "$(($KDIFF / 60)) minute(s) and $(($KDIFF % 60)) seconds."
echo
echo -e "${red}"
echo "-------------------"
echo " Zip Completed in:"
echo "-------------------"
echo -e "${restore}"
DIFF=$(($DATE_END - $DATE_START))
echo "$(($DIFF / 60)) minute(s) and $(($DIFF % 60)) seconds."
echo
echo "Image size: $(du -h $IMAGE_DIR/Image.gz-dtb)"
echo
echo "Zip size: $(du -h $ZIP_DIR/*.zip)"
