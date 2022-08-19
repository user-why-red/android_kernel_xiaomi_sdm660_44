#!/bin/bash

export KERNELNAME=SuperRyzen-CAF

export LOCALVERSION=-V2

export KBUILD_BUILD_USER=Tiannn

export KBUILD_BUILD_HOST=Zyc

export TOOLCHAIN=clang

export DEVICES=whyred,tulip,lavender

source helper

gen_toolchain

send_msg "⏳ Start building ${KERNELNAME} | DEVICES: whyred - tulip - lavender"

START=$(date +"%s")

for i in ${DEVICES//,/ }
do
	build ${i} -oldcam

        build ${i} -newcam
done

send_msg "⏳ Start building Overclock Version | DEVICES: whyred - tulip"

git apply ./oc.patch

for i in ${DEVICES//,/ }
do
	if [ $i == "whyred" ] || [ $i == "tulip" ]
	then
		build ${i} -oldcam -overclock

                build ${i} -newcam -overclock
	fi
done

END=$(date +"%s")

DIFF=$(( END - START ))

send_msg "✅ Build completed in $((DIFF / 60))m $((DIFF % 60))s | Linux version : $(make kernelversion) | Last commit: $(git log --pretty=format:'%s' -5)"

