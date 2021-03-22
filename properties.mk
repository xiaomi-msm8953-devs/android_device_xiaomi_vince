#
# Copyright (C) 2021 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

# Audio
PRODUCT_PROPERTY_OVERRIDES += \
    persist.vendor.audio.fluence.speaker=true \
    persist.vendor.audio.fluence.voicecall=true \
    persist.vendor.audio.fluence.voicerec=false \
    ro.vendor.audio.sdk.fluencetype=fluence

# Camera
PRODUCT_PROPERTY_OVERRIDES += \
    persist.vendor.camera.CDS=off \
    persist.vendor.camera.video.CDS=off
