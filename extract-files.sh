#!/bin/bash
#
# Copyright (C) 2016 The CyanogenMod Project
# Copyright (C) 2017-2020 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

function blob_fixup() {
    case "${1}" in
        vendor/lib/hw/android.hardware.camera.provider@2.4-impl.so \
        |vendor/lib/camera.device@1.0-impl-v27.so \
        |vendor/lib/camera.device@3.2-impl-v27.so \
        |vendor/lib/camera.device@3.3-impl-v27.so)
            "${PATCHELF}" --replace-needed "camera.device@1.0-impl.so" "camera.device@1.0-impl-v27.so" "${2}"
            "${PATCHELF}" --replace-needed "camera.device@3.2-impl.so" "camera.device@3.2-impl-v27.so" "${2}"
            "${PATCHELF}" --replace-needed "camera.device@3.3-impl.so" "camera.device@3.3-impl-v27.so" "${2}"
            "${PATCHELF}" --replace-needed "vendor.qti.hardware.camera.device@1.0_vendor.so" "vendor.qti.hardware.camera.device@1.0.so" "${2}"
            ;;
        vendor/lib/hw/camera.msm8953.so)
            "${PATCHELF}" --remove-needed "libandroid.so" "${2}"
            "${PATCHELF}" --replace-needed "libui.so" "libshims_libui.so" "${2}"
            ;;
        vendor/lib/libFaceGrade.so)
            "${PATCHELF}" --remove-needed "libandroid.so" "${2}"
            ;;
        vendor/lib/libmmcamera2_iface_modules.so)
            # Always set 0 (Off) as CDS mode in iface_util_set_cds_mode
            sed -i -e 's|\x1d\xb3\x20\x68|\x1d\xb3\x00\x20|g' "${2}"
            PATTERN_FOUND=$(hexdump -ve '1/1 "%.2x"' "${2}" | grep -E -o "1db30020" | wc -l)
            if [ $PATTERN_FOUND != "1" ]; then
                echo "Critical blob modification weren't applied on ${2}!"
                exit;
            fi
            ;;
        vendor/lib/libvidhance_gyro.so)
            "${PATCHELF}" --replace-needed "android.frameworks.sensorservice@1.0.so" "android.frameworks.sensorservice@1.0-v27.so" "${2}"
            ;;
        vendor/lib64/libvendor.goodix.hardware.fingerprint@1.0-service.so)
            "${PATCHELF_0_8}" --remove-needed "libprotobuf-cpp-lite.so" "${2}"
            ;;
    esac
}

# If we're being sourced by the common script that we called,
# stop right here. No need to go down the rabbit hole.
if [ "${BASH_SOURCE[0]}" != "${0}" ]; then
    return
fi

set -e

export DEVICE=vince
export DEVICE_COMMON=msm8953-common
export VENDOR=xiaomi

"./../../${VENDOR}/${DEVICE_COMMON}/extract-files.sh" "$@"
