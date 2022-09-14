#!/usr/bin/env bash
# Copyright (C) 2020-2022 Oktapra Amtono <oktapra.amtono@gmail.com>
# Docker Kernel Build Script

# Clone kernel source
if [[ "$*" =~ "stable" ]]; then
    git clone --depth=1 https://github.com/TianWalkzzMiku/SRyzen-CAF.git -b caf kernel
    cd kernel || exit
fi

# Clone toolchain
if [[ "$*" =~ "clang" ]]; then
    git clone --depth=1 https://gitlab.com/Panchajanya1999/azure-clang clang
elif [[ "$*" =~ "gcc" ]]; then
    git clone --depth=1 https://github.com/avinakefin/GCC-12-arm32 arm32
    git clone --depth=1 https://github.com/avinakefin/GCC-12-aarch64 arm64
fi

# Clone anykernel3
git clone --depth=1 https://github.com/TianWalkzzMiku/AnyKernel3.git -b lavender-dtb ak3-lavender
git clone --depth=1 https://github.com/TianWalkzzMiku/AnyKernel3.git -b whyred-dtb ak3-whyred
git clone --depth=1 https://github.com/TianWalkzzMiku/AnyKernel3.git -b tulip-dtb ak3-tulip
git clone --depth=1 https://github.com/TianWalkzzMiku/AnyKernel3.git -b a26x-dtb ak3-a26x

# Telegram setup
push_message() {
    curl -s -X POST \
        https://api.telegram.org/bot"{$bot_token}"/sendMessage \
        -d chat_id="${chat_id}" \
        -d text="$1" \
        -d "parse_mode=html" \
        -d "disable_web_page_preview=true"
}

# Push message to telegram
push_message "
<b>======================================</b>
<b>Start Building :</b> <code>SuperRyzen Kernel</code>
<b>Linux Version :</b> <code>$(make kernelversion | cut -d " " -f5 | tr -d '\n')</code>
<b>Source Branch :</b> <code>$(git rev-parse --abbrev-ref HEAD)</code>
<b>======================================</b> "