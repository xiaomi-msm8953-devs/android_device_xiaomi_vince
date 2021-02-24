#!/bin/bash
#
# Copyright (C) 2016 The CyanogenMod Project
# Copyright (C) 2017-2020 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

function blob_fixup() {
    case "${1}" in
        vendor/etc/init/android.hardware.biometrics.fingerprint@2.1-service.rc)
            sed -i 's/fps_hal/vendor.fps_hal/' "${2}"
            sed -i 's/group.*/& uhid/' "${2}"
            ;;
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
        vendor/lib/libvidhance_gyro.so)
            "${PATCHELF}" --replace-needed "android.frameworks.sensorservice@1.0.so" "android.frameworks.sensorservice@1.0-v27.so" "${2}"
            ;;
        vendor/lib64/hw/gf_fingerprint.default.so \
        |vendor/lib64/libgoodixfingerprintd_binder.so \
        |vendor/lib64/libvendor.goodix.hardware.fingerprint@1.0.so \
        |vendor/lib64/libvendor.goodix.hardware.fingerprint@1.0-service.so)
            "${PATCHELF_0_8}" --remove-needed "libbacktrace.so" "${2}"
            "${PATCHELF_0_8}" --remove-needed "libkeystore_binder.so" "${2}"
            "${PATCHELF_0_8}" --remove-needed "libkeymaster_messages.so" "${2}"
            "${PATCHELF_0_8}" --remove-needed "libsoftkeymaster.so" "${2}"
            "${PATCHELF_0_8}" --remove-needed "libsoftkeymasterdevice.so" "${2}"
            "${PATCHELF_0_8}" --remove-needed "libunwind.so" "${2}"
            ;;
        vendor/lib64/libril-qc-hal-qmi.so)
            "${PATCHELF}" --replace-needed "libprotobuf-cpp-full.so" "libprotobuf-cpp-full-v29.so" "${2}"
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
