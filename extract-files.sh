#!/bin/bash
#
# Copyright (C) 2016 The CyanogenMod Project
# Copyright (C) 2017-2020 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

function blob_fixup() {
    case "${1}" in
        vendor/lib/hw/camera.msm8953.so)
            "${PATCHELF}" --replace-needed "libui.so" "libshims_libui.so" "${2}"
            ;;
        vendor/lib64/hw/gf_fingerprint.default.so \
        |vendor/lib64/libgoodixfingerprintd_binder.so \
        |vendor/lib64/libvendor.goodix.hardware.fingerprint@1.0.so \
        |vendor/lib64/libvendor.goodix.hardware.fingerprint@1.0-service.so)
            "${PATCHELF}" --remove-needed "libbacktrace.so" "${2}"
            "${PATCHELF}" --remove-needed "libkeystore_binder.so" "${2}"
            "${PATCHELF}" --remove-needed "libkeymaster_messages.so" "${2}"
            "${PATCHELF}" --remove-needed "libsoftkeymaster.so" "${2}"
            "${PATCHELF}" --remove-needed "libsoftkeymasterdevice.so" "${2}"
            "${PATCHELF}" --remove-needed "libunwind.so" "${2}"
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
