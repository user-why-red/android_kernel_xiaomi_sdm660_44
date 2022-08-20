#!/bin/bash

export KERNELNAME=SuperRyzen-CAF-qti

export LOCALVERSION=-V2

export KBUILD_BUILD_USER=Tiannn

export KBUILD_BUILD_HOST=Zyc

export TOOLCHAIN=clang

export DEVICES=whyred,tulip,lavender

source helper-qti

gen_toolchain

send_msg "⏳ Start building ${KERNELNAME} | DEVICES: whyred - tulip - lavender"

git apply ./qti.patch

START=$(date +"%s")

for i in ${DEVICES//,/ }
do
	build ${i} -qti-oldcam
done

send_msg "⏳ Start building QTI Overclock Version | DEVICES: whyred - tulip"

git apply ./oc.patch

for i in ${DEVICES//,/ }
do
	if [ $i == "whyred" ] || [ $i == "tulip" ]
	then
		build ${i} -qti-oldcam -overclock
	fi
done

END=$(date +"%s")

DIFF=$(( END - START ))

send_msg "✅ Build completed in $((DIFF / 60))m $((DIFF % 60))s | Linux version : $(make kernelversion) | Last commit: $(git log --pretty=format:'%s' -5)"
