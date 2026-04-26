# Copyright (C) 2026 Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/aosp_base_telephony.mk)

# 注意：已移除 vendor/omni/config/common.mk 的引用，因为 OrangeFox 构建环境中没有该文件

# Device identifier
PRODUCT_NAME := twrp_PKR110
PRODUCT_DEVICE := PKR110
PRODUCT_BRAND := OnePlus
PRODUCT_MODEL := PKR110
PRODUCT_MANUFACTURER := OnePlus
PRODUCT_RELEASE_NAME := PKR110

# A/B support
AB_OTA_UPDATER := true
AB_OTA_PARTITIONS := system vendor product system_ext vendor_dlkm system_dlkm boot vbmeta_system vbmeta_vendor vbmeta dtbo

# VNDK version
PRODUCT_SHIPPING_API_LEVEL := 35
PRODUCT_USE_VNDK_OVERRIDE := true
PRODUCT_VNDK_VERSION := current

# OTA certificate for recovery
PRODUCT_EXTRA_RECOVERY_KEYS += \
    $(DEVICE_PATH)/security/otacert

# Enable project quotas and casefolding for emulated storage without sdcardfs
$(call inherit-product, $(SRC_TARGET_DIR)/product/emulated_storage.mk)

# Audio
PRODUCT_PACKAGES += \
    android.hardware.audio@6.0-impl \
    android.hardware.audio@7.0-service \
    android.hardware.audio.effect@6.0-impl

# Bluetooth
PRODUCT_PACKAGES += \
    android.hardware.bluetooth@1.0-impl-qti

# Camera
PRODUCT_PACKAGES += \
    android.hardware.camera.provider@2.7-impl \
    vendor.qti.hardware.camera.postproc@1.0.0

# Codec
PRODUCT_PACKAGES += \
    android.hardware.media.c2@1.0-service \
    libcodec2_hidl@1.0.vendor \
    libcodec2_vndk.vendor

# DRM
PRODUCT_PACKAGES += \
    android.hardware.drm@1.4-service.clearkey \
    android.hardware.drm@1.4-service.widevine

# Graphics
PRODUCT_PACKAGES += \
    android.hardware.graphics.composer@3.0-service \
    android.hardware.graphics.mapper@4.0-impl.qti-display \
    vendor.qti.hardware.display.allocator-service \
    libmemunreachable

# Health
PRODUCT_PACKAGES += \
    android.hardware.health@2.1-impl.recovery \
    android.hardware.health@2.1-service

# Power
PRODUCT_PACKAGES += \
    android.hardware.power@1.3-service-qti

# Sensors
PRODUCT_PACKAGES += \
    android.hardware.sensors@2.0-service.multihal

# USB
PRODUCT_PACKAGES += \
    android.hardware.usb@1.3-service-qti

# Vibrator
PRODUCT_PACKAGES += \
    android.hardware.vibrator-service.cs40l25

# WiFi
PRODUCT_PACKAGES += \
    android.hardware.wifi@1.0-service \
    wpa_supplicant \
    wificond

# Keymaster
PRODUCT_PACKAGES += \
    android.hardware.keymaster@4.1-service-qti \
    android.hardware.keymaster@4.1-service.citadel \
    android.hardware.gatekeeper@1.0-service-qti

# Gatekeeper
PRODUCT_PACKAGES += \
    android.hardware.gatekeeper@1.0-service-qti

# Netutils
PRODUCT_PACKAGES += \
    android.system.net.netd@1.1.vendor

# Radio
PRODUCT_PACKAGES += \
    android.hardware.radio@1.6.vendor \
    android.hardware.radio.config@1.3.vendor \
    android.hardware.secure_element@1.2.vendor \
    libandroidfw \
    libprotobuf-cpp-full \
    librmnetctl \
    libxml2

# Neural Networks
PRODUCT_PACKAGES += \
    android.hardware.neuralnetworks@1.3-service-qti

# Biometrics
PRODUCT_PACKAGES += \
    android.hardware.biometrics.fingerprint@2.3-service

# Boot control HAL
PRODUCT_PACKAGES += \
    android.hardware.boot@1.2-impl-qti \
    android.hardware.boot@1.2-impl-qti.recovery

# Dumpstate HAL
PRODUCT_PACKAGES += \
    android.hardware.dumpstate@1.1-services-qti

# Thermal HAL
PRODUCT_PACKAGES += \
    android.hardware.thermal@2.0-service.qti

# Lights
PRODUCT_PACKAGES += \
    android.hardware.light@2.0-service.qti

# AIDL Keymaster
PRODUCT_PACKAGES += \
    android.hardware.keymint@1.0-service-qti \
    android.hardware.keymint@1.0-service

# Audio HAL
PRODUCT_PACKAGES += \
    android.hardware.audio.service \
    android.hardware.audio@7.0-impl \
    audio.primary.taro \
    audio.bluetooth.default \
    audio.usb.default \
    audio.r_submix.default \
    audio.usb.default

# Graphics Composer
PRODUCT_PACKAGES += \
    vendor.qti.hardware.display.composer-service \
    vendor.qti.hardware.display.mapper@4.0.vendor

# QTI Performance
PRODUCT_PACKAGES += \
    vendor.qti.hardware.perf@2.3.vendor \
    vendor.qti.hardware.perf-hal@2.3.vendor

# Fastboot
PRODUCT_PACKAGES += \
    fastbootd \
    android.hardware.fastboot@1.0-impl-qti \
    android.hardware.fastboot@1.0-service.citadel

# VNDK
PRODUCT_TARGET_VNDK_VERSION := current

# Additional libraries
PRODUCT_PACKAGES += \
    libion \
    libxml2 \
    libtinyxml

# Recovery modules - 修正点：将 $(OUT) 替换为 $(PRODUCT_OUT)
PRODUCT_COPY_FILES += \
    $(PRODUCT_OUT)/system/lib64/android.hardware.health@2.1-impl.recovery.so:$(TARGET_COPY_OUT_SYSTEM_EXT)/lib64/ \
    $(PRODUCT_OUT)/system/lib64/android.hardware.keymaster@4.1-service-qti.so:$(TARGET_COPY_OUT_SYSTEM_EXT)/lib64/

# Recovery configuration
PRODUCT_PROPERTY_OVERRIDES += \
    ro.build.display.id=BP4A.251205.006

# Use the non-open-source parts
TARGET_USES_QSSI := true
