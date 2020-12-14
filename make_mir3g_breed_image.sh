#!/bin/bash

[ $# -ne 2 ] && { echo "Usage: $0 kernel1.bin rootfs0.bin"; exit 1; }

kernel1="$1"
rootfs0="$2"

[ -f "$kernel1" ] || { echo "kernel1 file doesn't exist, aborting: $kernel1"; exit 2; }
[ -f "$rootfs0" ] || { echo "rootfs0 file doesn't exist, aborting: $rootfs0"; exit 2; }
[[ ${kernel1##*/} =~ kernel1\.bin ]] || { echo "The first parameter must be kernel1.bin, aborting"; exit 3; }
[[ ${rootfs0##*/} =~ rootfs0\.bin ]] || { echo "The second parameter must be rootfs0.bin, aborting"; exit 3; }

set -eo pipefail

tmpfile=$(mktemp tmp.XXXXXX)
truncate -s 8M "$tmpfile"
dd if="$kernel1" of="$tmpfile" conv=nocreat,notrunc status=none oflag=seek_bytes seek=0
dd if="$kernel1" of="$tmpfile" conv=nocreat,notrunc status=none oflag=seek_bytes seek=4M
cat "$rootfs0" >> "$tmpfile"
mv "$tmpfile" openwrt_for_breed.bin

echo "openwrt_for_breed.bin successfully created."
