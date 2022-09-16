#!/usr/bin/env bash
# Copyright (C) 2020-2022 Oktapra Amtono <oktapra.amtono@gmail.com>
# Docker Kernel Build Script

# Print cpu cores
CORES=$(grep -c ^processor /proc/cpuinfo)
CPU=$(lscpu | sed -nr '/Model name/ s/.*:\s*(.*) */\1/p')

# Toolchain setup
if [[ "$*" =~ "clang" ]]; then
    CLANG_DIR="clang"
    CLGV="$("$CLANG_DIR"/bin/clang --version | head -n 1)"
    BINV="$("$CLANG_DIR"/bin/ld --version | head -n 1)"
    LLDV="$("$CLANG_DIR"/bin/ld.lld --version | head -n 1)"
    KBUILD_COMPILER_STRING="$CLGV - $BINV - $LLDV"
elif [[ "$*" =~ "gcc" ]]; then
    GCC_DIR="arm64"
    GCCV="$("$GCC_DIR"/bin/aarch64-elf-gcc --version | head -n 1)"
    BINV="$("$GCC_DIR"/bin/aarch64-elf-ld --version | head -n 1)"
    LLDV="$("$GCC_DIR"/bin/aarch64-elf-ld.lld --version | head -n 1)"
    KBUILD_COMPILER_STRING="$GCCV - $BINV - $LLDV"
fi

# Telegram setup
push_message() {
    curl -s -X POST \
        https://api.telegram.org/bot"{$BOT_TOKEN}"/sendMessage \
        -d chat_id="${CHAT_ID}" \
        -d text="$1" \
        -d "parse_mode=html" \
        -d "disable_web_page_preview=true"
}

# Push message to telegram
push_message "
<b>======================================</b>
<b>Success Building :</b> <code>SuperRyzen Kernel</code>
<b>Linux Version :</b> <code>$(make kernelversion | cut -d " " -f5 | tr -d '\n')</code>
<b>Build Date :</b> <code>$(date +"%A, %d %b %Y, %H:%M:%S")</code>
<b>Build Using :</b> <code>$CPU $CORES thread</code>
<b>Toolchain :</b> <code>$KBUILD_COMPILER_STRING</code>
<b>Last Changelog :</b> <code>$(git log --pretty=format:'%s' -1)</code>
<b>======================================</b>
<b>Provide your feedback in the @SRKSRSupport group for this Beta Build 😉</b> "