#
# Copyright (C) 2021 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

TARGET_KERNEL_VERSION := 4.9

# Inherit from common msm8953-common
include device/xiaomi/msm8953-common/BoardConfigCommon.mk

DEVICE_PATH := device/xiaomi/vince

# Display
TARGET_SCREEN_DENSITY := 440

# Kernel
TARGET_KERNEL_CONFIG := vince_defconfig

# Partitions
BOARD_CACHEIMAGE_PARTITION_SIZE := 268435456
BOARD_CACHEIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_RECOVERYIMAGE_PARTITION_SIZE := 67108864
BOARD_USERDATAIMAGE_PARTITION_SIZE := 55087422464
BOARD_VENDORIMAGE_PARTITION_SIZE := 872415232
BOARD_VENDORIMAGE_FILE_SYSTEM_TYPE := ext4
TARGET_COPY_OUT_VENDOR := vendor

# Properties
TARGET_VENDOR_PROP += $(DEVICE_PATH)/vendor.prop

# Security patch level
VENDOR_SECURITY_PATCH := 2019-10-01

# Inherit from the proprietary version
include vendor/xiaomi/vince/BoardConfigVendor.mk
