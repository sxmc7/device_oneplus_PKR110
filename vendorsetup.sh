FDEVICE="PKR110"
# 强制设置 FOX_BUILD_DEVICE，确保条件成立
FOX_BUILD_DEVICE="$FDEVICE"

fox_get_target_device() {
local chkdev=$(echo "$BASH_SOURCE" | grep -w $FDEVICE)
   if [ -n "$chkdev" ]; then
      FOX_BUILD_DEVICE="$FDEVICE"
   else
      chkdev=$(set | grep BASH_ARGV | grep -w $FDEVICE)
      [ -n "$chkdev" ] && FOX_BUILD_DEVICE="$FDEVICE"
   fi
}

if [ -z "$1" -a -z "$FOX_BUILD_DEVICE" ]; then
   fox_get_target_device
fi

if [ "$1" = "$FDEVICE" -o "$FOX_BUILD_DEVICE" = "$FDEVICE" ]; then
    export ALLOW_MISSING_DEPENDENCIES=true
    export FOX_USE_TWRP_RECOVERY_IMAGE_BUILDER=1
    export LC_ALL="C"
    export OF_MAINTAINER="iFlow CLI"
    export FOX_VERSION=$(date +%y.%m.%d)
    export FOX_BUILD_TYPE=Unofficial
    export FOX_ARCH=arm64
    export FOX_VARIANT="R16"
    export TARGET_DEVICE_ALT=PKR110,OP60EBL1,opposm8750
    export FOX_REPLACE_BUSYBOX_PS=1
    export FOX_REPLACE_TOOLBOX_GETPROP=1
    export FOX_USE_TAR_BINARY=1
    export FOX_USE_SED_BINARY=1
    export FOX_USE_BASH_SHELL=1
    export FOX_ASH_IS_BASH=1
    export FOX_USE_GREP_BINARY=1
    export FOX_USE_XZ_UTILS=1
    export FOX_USE_NANO_EDITOR=1
    export OF_ENABLE_LPTOOLS=1
    export OF_SCREEN_H=2772
    export OF_STATUS_H=100
    export OF_STATUS_INDENT_LEFT=150
    export OF_STATUS_INDENT_RIGHT=20
    export OF_HIDE_NOTCH=0
    export OF_CLOCK_POS=1
    export OF_ALLOW_DISABLE_NAVBAR=0
    export FOX_RECOVERY_INSTALL_PARTITION="/dev/block/by-name/recovery"
    export FOX_RECOVERY_SYSTEM_PARTITION="/dev/block/mapper/system"
    export FOX_RECOVERY_VENDOR_PARTITION="/dev/block/mapper/vendor"
    export FOX_RECOVERY_BOOT_PARTITION="/dev/block/by-name/boot"
    export OF_DONT_PATCH_ENCRYPTED_DEVICE=0
    export OF_DONT_PATCH_ON_FRESH_INSTALLATION=1
    export OF_KEEP_DM_VERITY_FORCED_ENCRYPTION=1
    export OF_SKIP_DECRYPTED_ADOPTED_STORAGE=1
    export OF_FIX_DECRYPTION_ON_DATA_MEDIA=1
    export OF_OTA_RES_DECRYPT=1
    export OF_SUPPORT_ALL_BLOCK_OTA_UPDATES=1
    export OF_FIX_OTA_UPDATE_MANUAL_FLASH_ERROR=1
    export OF_NO_RELOAD_AFTER_DECRYPTION=1
    export FOX_BUGGED_AOSP_ARB_WORKAROUND="1767228800"
    export OF_PATCH_AVB20=1
    export OF_NO_SPLASH_CHANGE=1
    export OF_PATCH_VBMETA_FLAG=2

    # 注册 lunch combo，供后续手动调用 lunch
    add_lunch_combo twrp_PKR110-eng
    add_lunch_combo omni_PKR110-eng
fi
