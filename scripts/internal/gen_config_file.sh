#!/bin/bash
#
# Copyright (C) 2023 BlackMesa123
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

# shellcheck disable=SC1090,SC1091

set -Eeu

# [
SRC_DIR="$(git rev-parse --show-toplevel)"
OUT_DIR="$SRC_DIR/out"

trap "rm -f $OUT_DIR/config.sh" ERR

GET_OFFICIAL_STATUS()
{
    local USES_UNICA_CERT=false

    if [ -f "$SRC_DIR/unica/security/unica_platform.pk8" ]; then
        openssl ec -pubout -in "$SRC_DIR/unica/security/unica_platform.pk8" -out "$OUT_DIR/unica_platform.pub" &> /dev/null
        if cmp -s "$SRC_DIR/unica/security/unica_platform.pub" "$OUT_DIR/unica_platform.pub"; then
            USES_UNICA_CERT=true
        fi
        rm -f "$OUT_DIR/unica_platform.pub"
    fi

    echo "$USES_UNICA_CERT"
}

GEN_CONFIG_FILE()
{
    if [ -f "$OUT_DIR/config.sh" ]; then
        echo "config.sh already exists. Regenerating..."
        rm -f "$OUT_DIR/config.sh"
    fi

    {
        echo "# Automatically generated by unica/scripts/internal/gen_config_file.sh"
        echo "ROM_IS_OFFICIAL=$(GET_OFFICIAL_STATUS)"
        echo "SOURCE_FIRMWARE=${SOURCE_FIRMWARE:?}"
        if [ "${#SOURCE_EXTRA_FIRMWARES[@]}" -ge 1 ]; then
            echo -n "SOURCE_EXTRA_FIRMWARES=( "
            for i in "${SOURCE_EXTRA_FIRMWARES[@]}"
            do
                echo -n "\"$i\" "
            done
            echo ")"
        fi
        echo "SOURCE_API_LEVEL=${SOURCE_API_LEVEL:?}"
        echo "SOURCE_VNDK_VERSION=${SOURCE_VNDK_VERSION:?}"
        echo "TARGET_CODENAME=${TARGET_CODENAME:?}"
        echo "TARGET_FIRMWARE=${TARGET_FIRMWARE:?}"
        if [ "${#TARGET_EXTRA_FIRMWARES[@]}" -ge 1 ]; then
            echo -n "TARGET_EXTRA_FIRMWARES=( "
            for i in "${TARGET_EXTRA_FIRMWARES[@]}"
            do
                echo -n "\"$i\" "
            done
            echo ")"
        fi
        echo "TARGET_API_LEVEL=${TARGET_API_LEVEL:?}"
        echo "TARGET_VNDK_VERSION=${TARGET_VNDK_VERSION:?}"
        echo "TARGET_SINGLE_SYSTEM_IMAGE=${TARGET_SINGLE_SYSTEM_IMAGE:?}"
        echo "TARGET_OS_FILE_SYSTEM=${TARGET_OS_FILE_SYSTEM:?}"
        echo "TARGET_SUPER_PARTITION_SIZE=${TARGET_SUPER_PARTITION_SIZE:?}"
        echo "TARGET_SUPER_GROUP_SIZE=${TARGET_SUPER_GROUP_SIZE:?}"
        echo "SOURCE_HAS_SYSTEM_EXT=${SOURCE_HAS_SYSTEM_EXT:?}"
        echo "TARGET_HAS_SYSTEM_EXT=${TARGET_HAS_SYSTEM_EXT:?}"
        echo "SOURCE_IS_ESIM_SUPPORTED=${SOURCE_IS_ESIM_SUPPORTED:?}"
        echo "TARGET_IS_ESIM_SUPPORTED=${TARGET_IS_ESIM_SUPPORTED:?}"
    } > "$OUT_DIR/config.sh"
}

source "$SRC_DIR/target/$1/config.sh"
if [ -f "$SRC_DIR/unica/$TARGET_SINGLE_SYSTEM_IMAGE.sh" ]; then
    source "$SRC_DIR/unica/$TARGET_SINGLE_SYSTEM_IMAGE.sh"
else
    echo "\"$TARGET_SINGLE_SYSTEM_IMAGE\" is not a valid system image."
    exit 1
fi
# ]

GEN_CONFIG_FILE

exit 0
