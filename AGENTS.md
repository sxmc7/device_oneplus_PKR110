# OrangeFox 设备树 - OnePlus PKR110 (Ace 5 Pro)

## 项目概述

这是一个为 OnePlus PKR110（国内代号 Ace 5 Pro）手机定制的 Android ROM 设备树，专门用于构建 OrangeFox Recovery 固件。

**项目类型：** Android ROM 设备树
**目标设备：** OnePlus PKR110 (OnePlus Ace 5 Pro)
**恢复系统：** OrangeFox Recovery R13.1 / R16 (Unofficial)
**SoC 平台：** Qualcomm SM8750 (Snapdragon 8 Gen 4 / sun)
**Android 版本：** 16 (API 36)
**构建系统：** OmniROM/AOSP 构建框架
**设备别名：** PKR110, OP60EBL1, opposm8750

## 架构配置

### CPU 架构 (从设备实际获取)
- **CPU 实现者：** Qualcomm (implementer 0x51)
- **CPU 架构：** ARMv8 (architecture 8)
- **CPU Part：** 0x001 (Qualcomm Oryon)
- **核心拓扑：**
  - 核心 0-5：variant 0x4 (性能核心)
  - 核心 6-7：variant 0x3 (能效核心)
  - 共 8 核心
- 主架构：ARM64 (armv8-2a)
- 第二架构：ARMv7 (armeabi-v7a, 兼容模式)
- **RAM：** 15457804 kB (约 16GB)
- **Kernel：** Linux 6.6.129-4k, PREEMPT, Clang 21.0.0

### 硬件平台
- 平台：Qualcomm sun (SM8750)
- GPU：Adreno 830 (Snapdragon 8 Gen 4)
- UDC 控制器：a600000.dwc3 (USB 3.0)
- Bootloader：UEFI 支持 (ro.boot.bootloader=sun)
- 分区表：QTI 动态分区

### 启动参数 (已验证)
- Boot Header 版本：4
- 内核基地址：0x00000000
- 页面大小：4096 字节
- 内核偏移：0x00008000
- Ramdisk 偏移：0x01000000
- 标签偏移：0x01000000
- 第二偏移：0x00f00000
- DTB 偏移：0x01f00000
- 内核命令行：`console=ttynull stack_depot_disable=on cgroup_disable=pressure kasan.stacktrace=off kvm-arm.mode=protected bootconfig ioremap_guard`

### AVB 验证状态 (从设备获取)
- AVB 版本：1.3
- 启动验证状态：green (ro.boot.verifiedbootstate=green)
- 验证模式：enforcing (ro.boot.veritymode=enforcing)

## 构建配置

### 产品 Makefile 定义
- `omni_PKR110.mk` - OmniROM 兼容配置
- `twrp_PKR110.mk` - TWRP/OrangeFox 主配置 (继承 fox_PKR110.mk)

### Lunch 选项
- `omni_PKR110-eng` - OmniROM 工程版本
- `twrp_PKR110-eng` - TWRP/OrangeFox 工程版本 (推荐)

### 分区布局 (从 /proc/partitions 获取)

#### 动态分区
super 设备：/dev/block/sda14 (13747412 blocks = 13.1 GB)
- **qti_dynamic_partitions** 组 (总大小 ~13.1 GB)：
  - system (ext4)
  - system_ext (ext4)
  - product (ext4)
  - vendor (erofs)
  - odm (erofs)
  - vendor_dlkm (erofs)
  - system_dlkm (erofs)

#### A/B 分区 (已验证)
| 分区 | 设备节点 | 大小 |
|------|---------|------|
| boot_a/b | sde12/48 | 96 MB |
| recovery_a/b | sde27/62 | 100 MB |
| init_boot_a/b | sde30/65 | 8 MB |
| vendor_boot_a/b | sde23/59 | ~100 MB |
| dtbo_a/b | sde16/52 | ~24 MB |
| vbmeta_a/b | - | - |
| vbmeta_system_a/b | - | - |
| vbmeta_vendor_a/b | - | - |

#### 数据分区
- userdata (sda15): f2fs, ~458 GB
- metadata (sda10): f2fs, ~64 MB
- persist (sda2): ext4

### 文件系统 (从 mount 输出验证)
| 挂载点 | 文件系统 | 设备 |
|--------|---------|------|
| /system_ext | ext4 | dm-4 |
| /product | ext4 | dm-1 |
| /vendor | erofs | dm-5 |
| /vendor_dlkm | erofs | dm-6 |
| /system_dlkm | erofs | dm-3 |
| /data | f2fs | dm-52 |
| /metadata | f2fs | - |
| /persist | ext4 | - |

**注意：** recovery.fstab 中动态分区同时配置 erofs 和 ext4 作为备选挂载方案。

### 加密配置 (从设备获取)
- ro.crypto.type = file (FBE - 文件级加密)
- ro.crypto.state = encrypted
- 加密算法：AES-256-XTS + AES-256-CTS:V2+inlinecrypt_optimized
- 密钥存储位置：/metadata/vold/metadata_encryption
- HMAC 算法：hmac(sha512-ce)
- FSCRYPT 策略：v2 (TW_USE_FSCRYPT_POLICY := 2)
- 元数据分区加密：已启用 (BOARD_USES_METADATA_PARTITION)

### AVB 配置 (BoardConfig.mk)
设备树配置了双重 AVB vbmeta 架构：

#### vbmeta_system (索引 1)
- 覆盖分区：system, product
- 签名密钥：external/avb/test/data/testkey_rsa2048.pem
- 算法：SHA256_RSA2048
- 回滚索引：$(PLATFORM_SECURITY_PATCH_TIMESTAMP)

#### vbmeta_vendor (索引 2)
- 覆盖分区：vendor, odm, vendor_dlkm, system_dlkm
- 签名密钥：external/avb/test/data/testkey_rsa2048.pem
- 算法：SHA256_RSA2048
- 回滚索引：$(PLATFORM_SECURITY_PATCH_TIMESTAMP)

#### Recovery 单独签名
- 密钥：external/avb/test/data/testkey_rsa2048.pem
- 算法：SHA256_RSA2048
- 回滚索引：1

### 构建信息 (从设备获取)
- **Build Description：** qssi-user 16 BP2A.250605.015 1775721942795 release-keys
- **Fingerprint：** OnePlus/PKR110/OP60EBL1:16/BP2A.250605.015/1775721942795:user/release-keys
- **Android：** 16 (SDK 36)
- **System 安全补丁：** 2026-04-01
- **Vendor 安全补丁：** 2026-03-01
- **Display ID：** BP4A.251205.006
- **Shipping API Level：** 35

### 显示信息 (从设备获取)
- **物理分辨率：** 2772×1240 (横屏)
- **DPI：** 560 (ro.sf.lcd_density=560)
- **类型：** OLED (ro.vendor.display.type=oled)
- **恢复像素格式：** RGBX_8888

## 预构建文件

### prebuilt/ 目录
包含从 crDroid boot.img 提取的预构建文件：
- **Image.gz**：内核镜像 (~20-30 MB)
- **dtb**：设备树二进制文件 (~1-2 MB)
- **dtbo.img**：设备树覆盖图像 (~1-2 MB)

**重要：** 这些文件必须与 ROM 版本匹配，使用错误的文件可能导致启动问题。

### 获取预构建文件的方法

1. **从 boot.img 提取**（推荐）
   - 使用 magiskboot：
     ```bash
     magiskboot unpack boot.img
     cp kernel Image.gz
     cp dtb dtb
     cp dtbo dtbo.img
     ```

2. **从 crDroid ROM 中提取**
   - ROM 压缩包中包含 boot.img
   - 或者从设备中提取：`adb pull /dev/block/by-name/boot_a boot.img`

3. **使用 Android Image Kitchen**
   - 解压 boot.img
   - 提取内核、dtb、dtbo

## Recovery 配置

### OrangeFox 专用配置 (fox_PKR110.mk)
- **版本：** R13.1
- **维护者：** iFlow CLI
- **支持 A/B 分区 (带 recovery 分区)：** 是
- **屏幕尺寸 (H×W)：** 2772×1240
- **Gapps 支持：** 在所有分区启用
- **OEM 解锁：** 支持
- **块 OTA：** 支持
- **MIUI 特定功能：** 禁用
- **AVB 补丁：** 已启用 (OF_PATCH_AVB20 := 1)
- **VBMETA 补丁标志：** 2 (OF_PATCH_VBMETA_FLAG := 2)

### OrangeFox GUI 配置
- 状态栏高度：100px
- 状态栏左边距：150px
- 状态栏右边距：20px
- 时钟位置：右侧 (1)
- 选项列表数量：6
- 隐藏刘海：否
- 禁用导航栏：否

### 显示配置
- 主题：portrait_hdpi
- 屏幕偏移：Y=100, H=-100
- 不黑屏启动：已启用
- 不显示电池百分比：已禁用
- 启动时 blank 屏幕：已启用 (TW_SCREEN_BLANK_ON_BOOT)
- 排除默认 USB init：已启用

### 内置功能
- NTFS 3G 支持
- 重新打包工具
- EDL 模式支持
- Input AIDL HAL 支持 (TW_SUPPORT_INPUT_AIDL_HAL)
- F2FS 支持
- LP 工具 (OF_ENABLE_LPTOOLS := 1)
- BusyBox 替换 ps
- Toolbox 替换 getprop
- Tar/Sed/Bash/Grep/XZ/Nano 二进制支持

### 内核模块 (vendor/lib/modules/)
recovery 中包含以下 Qualcomm SM8750 内核模块：
| 模块 | 功能 |
|------|------|
| ufs_qcom.ko | UFS 存储控制器 |
| ufshcd-crypto-qti.ko | UFS 加密引擎 |
| qcom_ice.ko | 内联加密引擎 |
| msm_drm.ko | DRM 显示驱动 |
| msm_kgsl.ko | GPU/KGSL 驱动 |
| dwc3-msm.ko | USB DWC3 控制器 |
| phy-msm-ssusb-qmp.ko | USB PHY 驱动 |
| i2c-msm-geni.ko | I2C GENI 控制器 |
| msm_geni_serial.ko | GENI 串口驱动 |

## Android HAL 服务

### HIDL 服务包 (device.mk)
| 服务 | 包名 |
|------|------|
| **Audio** | android.hardware.audio@6.0-impl, @7.0-service, @7.0-impl, audio.primary.taro, audio.bluetooth.default, audio.usb.default, audio.r_submix.default |
| **Bluetooth** | android.hardware.bluetooth@1.0-impl-qti |
| **Camera** | camera.provider@2.7-impl, vendor.qti.camera.postproc@1.0.0 |
| **Graphics** | graphics.composer@3.0-service, graphics.mapper@4.0-impl.qti-display, display.allocator-service |
| **Keymaster** | keymaster@4.1-service-qti, keymaster@4.1-service.citadel, keymint@1.0-service-qti |
| **Gatekeeper** | gatekeeper@1.0-service-qti |
| **Power** | power@1.3-service-qti |
| **Sensors** | sensors@2.0-service.multihal |
| **USB** | usb@1.3-service-qti |
| **Vibrator** | vibrator-service.cs40l25 |
| **WiFi** | wifi@1.0-service, wpa_supplicant, wificond |
| **Neural Networks** | neuralnetworks@1.3-service-qti |
| **Thermal** | thermal@2.0-service.qti |
| **Lights** | light@2.0-service.qti |
| **Dumpstate** | dumpstate@1.1-services-qti |
| **Health** | health@2.1-impl.recovery, health@2.1-service |
| **Boot Control** | boot@1.2-impl-qti (.recovery) |
| **Fastboot** | fastbootd, fastboot@1.0-impl-qti, fastboot@1.0-service.citadel |
| **DRM** | drm@1.4-service.clearkey, drm@1.4-service.widevine |
| **Codec2** | media.c2@1.0-service, libcodec2_hidl@1.0.vendor, libcodec2_vndk.vendor |
| **Biometrics** | biometrics.fingerprint@2.3-service |
| **Radio** | radio@1.6.vendor, radio.config@1.3.vendor, secure_element@1.2.vendor |

### AIDL 服务
- **Keymaster/Mint：** keymint@1.0-service-qti, keymint@1.0-service

### VINTF Manifest 声明 (recovery/root/system/etc/vintf/manifest.xml)
Recovery 模式下声明的 HAL 服务：
- vendor.qti.hardware.display.composer-service@1.0
- vendor.qti.hardware.servicetracker@1.0
- android.hardware.sensors@2.0
- android.hidl.manager@1.0
- android.hidl.memory@1.0 (ashmem)
- android.hidl.token@1.0
- android.system.net.netd@1.1
- android.hardware.wifi.supplicant@1.4
- vendor.qti.hardware.qccsyshal@1.0
- vendor.qti.hardware.atcmdfwd@1.0
- vendor.qti.hardware.systemhelper@1.0

## Vendorsetup 环境变量 (vendorsetup.sh)

`vendorsetup.sh` 是推荐的构建入口脚本，自动设置所有 OrangeFox 环境变量并调用 `lunch`：

| 变量 | 值 | 说明 |
|------|-----|------|
| FOX_BUILD_DEVICE | PKR110 | 设备标识 |
| FOX_USE_TWRP_RECOVERY_IMAGE_BUILDER | 1 | 使用 TWRP 构建器 |
| FOX_VERSION | $(date +%y.%m.%d) | 动态版本号 |
| FOX_BUILD_TYPE | Unofficial | 构建类型 |
| FOX_ARCH | arm64 | 架构 |
| FOX_VARIANT | R16 | OrangeFox 变体 |
| OF_MAINTAINER | iFlow CLI | 维护者 |
| FOX_REPLACE_BUSYBOX_PS | 1 | 替换 ps |
| FOX_REPLACE_TOOLBOX_GETPROP | 1 | 替换 getprop |
| FOX_USE_TAR_BINARY | 1 | 包含 tar |
| FOX_USE_SED_BINARY | 1 | 包含 sed |
| FOX_USE_BASH_SHELL | 1 | Bash shell |
| FOX_ASH_IS_BASH | 1 | Ash 链接到 Bash |
| FOX_USE_GREP_BINARY | 1 | 包含 grep |
| FOX_USE_XZ_UTILS | 1 | 包含 xz |
| FOX_USE_NANO_EDITOR | 1 | 包含 nano |
| FOX_BUGGED_AOSP_ARB_WORKAROUND | 1767228800 | ARB 补丁 |
| FOX_RECOVERY_INSTALL_PARTITION | /dev/block/by-name/recovery | 安装分区 |
| FOX_RECOVERY_SYSTEM_PARTITION | /dev/block/mapper/system | 系统分区 |
| FOX_RECOVERY_VENDOR_PARTITION | /dev/block/mapper/vendor | vendor 分区 |
| FOX_RECOVERY_BOOT_PARTITION | /dev/block/by-name/boot | boot 分区 |

## twrp.flags 分区标记

`recovery/root/system/etc/twrp.flags` 定义了 OrangeFox/TWRP 识别的分区标记：

- **动态分区（slotselect）：** system, system_ext, product, vendor, odm, vendor_dlkm, system_dlkm, super
- **启动分区（slotselect+flashimg）：** boot, init_boot, vendor_boot
- **验证分区（slotselect+flashimg）：** dtbo, vbmeta, vbmeta_system, vbmeta_vendor
- **存储：** userdata (f2fs), metadata (ext4), persist (ext4), cache (ext4)
- **一加重叠分区（slotselect+flashimg）：** oplus_boot, oplus_dycfg
- **固件：** modem, bluetooth, dsp (slotselect+flashimg)
- **EFS 备份：** efs1, efs2 (backup only)

## 系统属性

### 基本属性
- ro.product.model=PKR110
- ro.product.device=PKR110
- ro.product.name=PKR110
- ro.product.manufacturer=OnePlus
- ro.product.brand=OnePlus
- ro.board.platform=sun
- ro.soc.model=SM8750
- ro.hardware=qcom
- ro.board.platform_gpu=adreno

### 显示属性
- ro.sf.lcd_density=560
- ro.sf.lcd_dimensions=2772x1240
- ro.vendor.display.type=oled
- ro.hardware.vulkan=1
- ro.opengles.version=196610

### 摄像头属性
- ro.vendor.camera.extensions.package=org.codeaurora.qcameraextensions
- ro.vendor.camera.extensions.version=1

### 指纹传感器
- 指纹 ID：G_OPTICAL_JV0301
- 类型：光学
- 传感器：persist.vendor.fingerprint.sensor_type=optical
- 支持：1 (persist.vendor.fingerprint.optical.support=1)

### 调试属性
- ro.secure=0
- ro.adb.secure=0
- persist.sys.usb.config=adb
- TWRP_EVENT_LOGGING := true
- TARGET_USES_LOGD := true

### 安全补丁
- PLATFORM_SECURITY_PATCH=2099-12-31 (BoardConfig.mk / 用于避免 AVB 回滚)
- ro.build.version.security_patch=2026-03-01 (system.prop)
- ro.vendor.build.security_patch=2026-03-01 (实际 vendor)

## CI/CD - GitHub Actions

项目包含 GitHub Actions 工作流 (`.github/workflows/build.yml`)：

**触发方式：** `workflow_dispatch` (手动触发)

**可配置参数：**
| 参数 | 默认值 | 选项 |
|------|--------|------|
| MANIFEST_BRANCH | 12.1 | 12.1, 11.0 |
| DEVICE_TREE | (当前仓库) | - |
| DEVICE_TREE_BRANCH | master | - |
| DEVICE_PATH | device/oneplus/PKR110 | - |
| DEVICE_NAME | PKR110 | - |
| BUILD_TARGET | recovery | recovery, boot, vendorboot |

**构建步骤：**
1. 检出代码
2. 安装构建依赖 (aria2, Android 构建环境)
3. 同步 OrangeFox 源码
4. 克隆设备树
5. 执行 `lunch twrp_PKR110-eng && make clean && mka adbd recoveryimage`
6. 自动发布 Release

## 构建方法

### 方法 1：使用 vendorsetup.sh（推荐，自动设置环境）

```bash
# 1. 设置构建环境
source build/envsetup.sh

# 2. 运行 vendorsetup（自动设置 OF 变量并 lunch）
source device/oneplus/PKR110/vendorsetup.sh

# 3. 编译
make clean && mka adbd recoveryimage

# 4. 输出位置
out/target/product/PKR110/recovery.img
```

### 方法 2：手动 lunch（更精细控制）

```bash
# 1. 设置构建环境
source build/envsetup.sh

# 2. 选择目标
lunch twrp_PKR110-eng

# 3. 编译恢复分区
make clean && mka adbd recoveryimage

# 4. 输出位置
out/target/product/PKR110/recovery.img
```

### 方法 3：OmniROM 兼容构建

```bash
source build/envsetup.sh
export ALLOW_MISSING_DEPENDENCIES=true
lunch omni_PKR110-eng
make recoveryimage -j$(nproc)
```

## 文件用途说明

| 文件 | 用途 |
|------|------|
| AndroidProducts.mk | 产品定义，注册 omni_PKR110 和 twrp_PKR110 |
| Android.bp | Soong 命名空间声明 (bootctl 导入) |
| BoardConfig.mk | 板级配置（内核参数、分区、AVB、加密） |
| device.mk | 产品特定配置（HAL 包、依赖项） |
| omni_PKR110.mk | OmniROM 兼容产品配置 |
| twrp_PKR110.mk | TWRP/OrangeFox 产品配置（继承 fox_PKR110.mk） |
| fox_PKR110.mk | OrangeFox 专属配置（版本、GUI、功能开关） |
| vendorsetup.sh | 构建环境变量设置脚本（自动 lunch） |
| recovery.fstab | 恢复分区文件系统挂载配置 |
| properties/system.prop | 系统属性配置 |
| vendor.prop | 厂商属性配置 |
| twrp.flags | 分区标记配置文件 |
| manifest.xml | Recovery VINTF HAL 服务声明 |
| otacert.x509.pem | OTA 验证证书（来自 MIUI） |

### Recovery 初始化文件
| 文件 | 用途 |
|------|------|
| init.recovery.qcom.rc | 高通 recovery 初始化（HAL 服务启动、固件挂载） |
| init.recovery.usb.rc | USB gadget/configfs 初始化（adb/mtp/sideload/fastboot） |
| ueventd.rc | 设备节点权限配置 |

## 开发注意事项

### 版本匹配
- 使用与 ROM 版本匹配的 Image.gz、dtb、dtbo
- 建议从同一 crDroid 版本的 boot.img 提取
- 如果使用错误的版本，可能导致启动失败
- 预构建文件为占位文件，构建前需替换为实际的设备文件

### 构建前准备
1. 确保预构建文件在 prebuilt/ 目录中
2. 使用正确的 lunch 选项（推荐 twrp_PKR110-eng）
3. 验证输入文件的大小和完整性
4. 设置 `ALLOW_MISSING_DEPENDENCIES=true` 以避免缺少依赖错误

### 故障排除
- **启动失败：** 检查 Image.gz、dtb、dtbo 是否正确
- **加密问题：** 确认 FBE 配置正确，密钥位置正确 (/metadata/vold/metadata_encryption)
- **AVB 问题：** 验证 vbmeta_system 和 vbmeta_vendor 双密钥配置和回滚索引
- **USB 问题：** 检查 UDC 控制器路径 a600000.dwc3
- **HAL 服务失败：** 验证 manifest.xml 中声明的服务版本匹配

## 附加说明

- 此设备树包含预构建内核，因此无需编译内核源码
- 使用测试密钥进行 AVB 验证 (testkey_rsa2048.pem)
- 支持双分区（A/B）更新，含独立的 recovery 分区
- 需要 64 位构建环境
- 分区表支持全动态分区
- 调试模式在 system.prop 和 BoardConfig.mk 中启用
- USB 配置支持 adb、mtp、sideload、fastboot 多模式
- 使用 ConfigFS USB gadget 架构
- GPT 头信息通过 `ro.boot.bootloader=sun` 标识
- 一加专属分区：oplus_boot, oplus_dycfg

## 参考链接

- OrangeFox Recovery: https://github.com/OrangeFox-Recovery
- OmniROM: https://github.com/omnirom
- crDroid: https://www.crdroid.net
- 设备树仓库: https://github.com/sxmc7/device_oneplus_PKR110
