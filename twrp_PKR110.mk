# Copyright (C) 2026 The Android Open Source Project
# Copyright (C) 2026 sxmc7
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Device Information
PRODUCT_DEVICE := PKR110
PRODUCT_NAME := twrp_$(PRODUCT_DEVICE)
PRODUCT_BRAND := OnePlus
PRODUCT_MODEL := PKR110
PRODUCT_MANUFACTURER := OnePlus
PRODUCT_RELEASE_NAME := PKR110

# Inherit from Prebuilt Products
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/base.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/emulated_storage.mk)

# Inherit from device.mk (using PRODUCT_RELEASE_NAME variable)
$(call inherit-product, device/oneplus/$(PRODUCT_RELEASE_NAME)/device.mk)

# Inherit any OrangeFox-specific settings
$(call inherit-product-if-exists, device/oneplus/$(PRODUCT_RELEASE_NAME)/fox_PKR110.mk)

# Inherit from TWRP-common stuff
$(call inherit-product-if-exists, vendor/twrp/config/common.mk)

# VNDK version
PRODUCT_SHIPPING_API_LEVEL := 35
PRODUCT_USE_VNDK_OVERRIDE := true
PRODUCT_VNDK_VERSION := current
