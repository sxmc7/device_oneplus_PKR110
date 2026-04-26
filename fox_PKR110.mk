#
#	This file is part of the OrangeFox Recovery Project
# 	Copyright (C) 2026 The OrangeFox Recovery Project
#
#	OrangeFox is free software: you can redistribute it and/or modify
#	it under the terms of the GNU General Public License as published by
#	the Free Software Foundation, either version 3 of the License, or
#	any later version.
#
#	OrangeFox is distributed in the hope that it will be useful,
#	but WITHOUT ANY WARRANTY; without even the implied warranty of
#	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#	GNU General Public License for more details.
#
# 	This software is released under GPL version 3 or any later version.
#	See <http://www.gnu.org/licenses/>.
#
# 	Please maintain this if you use this script or any part of it
#

# OrangeFox settings
OF_USE_GAPPS_ON_ALL_PARTITIONS := true
OF_DONT_PATCH_ENCRYPTED_DEVICE := false
OF_MAINTAIN_BLOCK_SIGNATURE_FILES := true
OF_FBE_METADATA_MOUNT := /metadata
OF_SUPPORT_OEM_UNLOCK := true
OF_ENABLE_LPTOOLS := 1
OF_HIDE_NOTCH := 0
OF_ALLOW_DISABLE_NAVBAR := 0
OF_DONT_PATCH_ON_FRESH_INSTALLATION := 1
OF_KEEP_DM_VERITY_FORCED_ENCRYPTION := 1
OF_SKIP_DECRYPTED_ADOPTED_STORAGE := 1
OF_FIX_DECRYPTION_ON_DATA_MEDIA := 1
OF_OTA_RES_DECRYPT := 1
OF_SUPPORT_ALL_BLOCK_OTA_UPDATES := 1
OF_FIX_OTA_UPDATE_MANUAL_FLASH_ERROR := 1
OF_NO_RELOAD_AFTER_DECRYPTION := 1
OF_PATCH_AVB20 := 1
OF_NO_SPLASH_CHANGE := 1
OF_PATCH_VBMETA_FLAG := 2

OF_NO_TREBLE_COMPATIBILITY_CHECK := 1
OF_USE_GREEN_LED := 0
OF_FLASHLIGHT_ENABLE := 1
OF_QUICK_BACKUP_LIST := "/data;/boot;"
OF_SKIP_MULTIUSER_FOLDERS_BACKUP := 1
OF_ENABLE_USB_STORAGE := 1
OF_IGNORE_LOGICAL_MOUNT_ERRORS := 1
OF_BIND_MOUNT_SDCARD_ON_FORMAT := 1
OF_FORCE_CASEFOLDING := 1
OF_DISABLE_OTA_MENU := 1
OF_DYNAMIC_FULL_SIZE := 14077349888

# OrangeFox GUI settings
OF_SCREEN_H := 2772
OF_SCREEN_W := 1240
OF_STATUS_H := 100
OF_STATUS_INDENT_LEFT := 150
OF_STATUS_INDENT_RIGHT := 20
OF_CLOCK_POS := 1
OF_OPTIONS_LIST_NUM := 6

# AB device
OF_AB_DEVICE_WITH_RECOVERY_PARTITION := 1
OF_RECOVERY_AB_FULL_REFLASH_RAMDISK := 1

# Version info
OF_VERSION := R13.1
OF_MAINTAINER := iFlow CLI
