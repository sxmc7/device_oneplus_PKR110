# OrangeFox 设备树 - OnePlus PKR110 (Ace 5 Pro)

## 项目概述

这是一个为 OnePlus PKR110（国内代号 Ace 5 Pro）手机定制的 Android ROM 设备树，专门用于构建 OrangeFox Recovery 固件。

**项目类型：** Android ROM 设备树
**目标设备：** OnePlus PKR110 (OnePlus Ace 5 Pro)
**恢复系统：** OrangeFox Recovery R13.1
**SoC 平台：** Qualcomm SM8750 (Snapdragon 8 Gen 4 / sun)
**Android 版本：** 16 (API 36)
**构建系统：** OmniROM/AOSP 构建框架

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
- GPU：Adreno (Snapdragon 8 Gen 4)
- Bootloader：UEFI 支持 (ro.boot.bootloader=sun)
- 分区表：QTI 动态分区

### 启动参数 (已验证)
- Boot Header 版本：4 (通过 dd 读取 raw boot_a 分区验证: 0x04 00 00 00)
- 内核基地址：0x00000000
- 页面大小：4096 字节
- 内核偏移：0x00008000
- Ramdisk 偏移：0x01000000
- 标签偏移：0x01000000
- 第二偏移：0x00f00000
- DTB 偏移：0x01f00000

### AVB 验证状态 (从设备获取)
- AVB 版本：1.3
- 启动验证状态：green (ro.boot.verifiedbootstate=green)
- 验证模式：enforcing (ro.boot.veritymode=enforcing)

## 构建配置

### Lunch 选项
- `omni_PKR110-user` - 用户版本
- `omni_PKR110-userdebug` - 调试用户版本
- `omni_PKR110-eng` - 工程版本

### 分区布局 (从 /proc/partitions 获取)

#### 动态分区
super 设备：/dev/block/sda14 (13747412 blocks = 13.1 GB)
- **qti_dynamic_partitions** 组：
  - system (ext4)
  - system_ext (ext4)
  - product (ext4)
  - vendor (erofs)
  - odm (erofs)
  - vendor_dlkm (erofs)
  - system_dlkm (erofs)

#### A/B 分区 (已验证)
| 分区 | 设备节点 | 大小 (blocks) | 大小 (字节) |
|------|---------|--------------|------------|
| boot_a | sde12 | 98304 | 100663296 (96 MB) |
| boot_b | sde48 | 98304 | 100663296 (96 MB) |
| recovery_a | sde27 | 102400 | 104857600 (100 MB) |
| recovery_b | sde62 | 102400 | 104857600 (100 MB) |
| init_boot_a | sde30 | 8192 | 8388608 (8 MB) |
| init_boot_b | sde65 | 8192 | 8388608 (8 MB) |
| vendor_boot_a | sde23 | - | ~100 MB |
| vendor_boot_b | sde59 | - | ~100 MB |
| dtbo_a | sde16 | - | ~24 MB |
| dtbo_b | sde52 | - | ~24 MB |

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

### 加密配置 (从设备获取)
- ro.crypto.type = file (FBE - 文件级加密)
- ro.crypto.state = encrypted
- AES-256-XTS + AES-256-CTS:V2+inlinecrypt_optimized
- 密钥存储位置：/metadata/vold/metadata_encryption
- HMAC 算法：hmac(sha512-ce)

### 构建信息 (从设备获取)
- **Build Description：** qssi-user 16 BP2A.250605.015 1775721942795 release-keys
- **Fingerprint：** OnePlus/PKR110/OP60EBL1:16/BP2A.250605.015/1775721942795:user/release-keys
- **Android：** 16 (SDK 36)
- **System 安全补丁：** 2026-04-01
- **Vendor 安全补丁：** 2026-03-01
- **Display ID：** BP4A.251205.006

### 显示信息 (从设备获取)
- **逻辑分辨率：** 1264×2780 (竖屏)
- **物理分辨率：** 2772×1240 (横屏)
- **DPI：** 560 (ro.sf.lcd_density=560)
- **类型：** OLED (ro.vendor.display.type=oled)

## 预构建文件

### prebuilt/ 目录
包含从 crDroid boot.img 提取的预构建文件：
- **Image.gz**：内核镜像
- **dtb**：设备树二进制文件
- **dtbo.img**：设备树覆盖图像

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

### OrangeFox 专用配置
- **版本：** R13.1
- **维护者：** iFlow CLI
- **支持 A/B 分区：** 是
- **屏幕尺寸：** 2772x1240
- **Gapps 支持：** 在所有分区启用
- **OEM 解锁：** 支持
- **块 OTA：** 支持
- **MIUI 特定功能：** 禁用

### 显示配置
- 主题：portrait_hdpi
- 屏幕偏移：Y=100, H=-100
- 不黑屏启动：已启用
- 不显示电池百分比：已禁用

### 内置功能
- NTFS 3G 支持
- 重新打包工具
- EDL 模式支持
- Input AIDL HAL 支持
- F2FS 支持

## Android HAL 服务

### 系统服务包
- **Audio：** hardware.audio@6.0-impl, audio.primary.taro
- **Bluetooth：** hardware.bluetooth@1.0-impl-qti
- **Camera：** camera.provider@2.7-impl, vendor.qti.camera.postproc@1.0.0
- **Graphics：** graphics.composer@3.0, display.mapper@4.0
- **Keymaster：** keymaster@4.1-service-qti, keymaster@4.1-service.citadel
- **Gatekeeper：** gatekeeper@1.0-service-qti
- **Power：** power@1.3-service-qti
- **Sensors：** sensors@2.0-service.multihal
- **USB：** usb@1.3-service-qti
- **Vibrator：** vibrator-service.cs40l25
- **WiFi：** wifi@1.0-service
- **Neural Networks：** neuralnetworks@1.3-service-qti
- **Thermal：** thermal@2.0-service.qti
- **Lights：** light@2.0-service.qti
- **Dumpstate：** dumpstate@1.1-services-qti
- **Health：** health@2.1-impl.recovery

### AIDL 服务
- **Keymaster/Mint：** keymint@1.0-service-qti

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

### 显示属性
- ro.sf.lcd_density=560
- ro.sf.lcd_dimensions=2772x1240
- ro.vendor.display.type=oled

### 摄像头属性
- ro.vendor.camera.extensions.package=org.codeaurora.qcameraextensions
- ro.vendor.camera.extensions.version=1

### 指纹传感器
- 指纹 ID：G_OPTICAL_JV0301
- 类型：光学
- 支持：1 (persist.vendor.fingerprint.optical.support=1)

### 安全补丁
- PLATFORM_SECURITY_PATCH=2099-12-31 (BoardConfig.mk / 用于避免 AVB 回滚)
- ro.build.version.security_patch=2026-04-01 (实际系统)
- ro.vendor.build.security_patch=2026-03-01 (实际 vendor)

## 开发注意事项

### 版本匹配
- 使用与 ROM 版本匹配的 Image.gz、dtb、dtbo
- 建议从同一 crDroid 版本的 boot.img 提取
- 如果使用错误的版本，可能导致启动失败

### 构建前准备
1. 确保预构建文件在 prebuilt/ 目录中
2. 使用正确的 lunch 选项
3. 验证输入文件的大小和完整性

### 故障排除
- **启动失败：** 检查 Image.gz、dtb、dtbo 是否正确
- **加密问题：** 确认 FBE 配置正确，密钥位置正确 (/metadata/vold/metadata_encryption)
- **AVB 问题：** 验证密钥配置和回滚索引

## 文件用途说明

| 文件 | 用途 |
|------|------|
| AndroidProducts.mk | 产品定义，指定如何编译此设备 |
| BoardConfig.mk | 板级配置（内核参数、分区、优化） |
| device.mk | 产品特定配置（HAL 包、依赖项） |
| omni_PKR110.mk | OmniROM 兼容性配置 |
| twrp_PKR110.mk | TWRP/OrangeFox 兼容性配置 |
| recovery.fstab | 恢复分区文件系统挂载配置 |
| system.prop | 系统属性配置 |
| vendor.prop | 厂商属性配置 |
| recovery.wipe | 恢复分区默认擦除配置 |
| vendorsetup.sh | 构建环境变量设置脚本 |

## 构建方法

```bash
# 1. 设置构建环境
source build/envsetup.sh

# 2. 选择目标（建议使用 eng 版本进行测试）
lunch omni_PKR110-eng

# 3. 编译恢复分区
make recoveryimage -j$(nproc)

# 4. 输出位置
out/target/product/PKR110/recovery.img
```

## 附加说明

- 此设备树包含预构建内核，因此无需编译内核源码
- 使用测试密钥进行 AVB 验证
- 支持双分区（A/B）更新
- 需要 64 位构建环境
- 分区表支持全动态分区
- 调试模式：`persist.sys.usb.config=adb`, `ro.secure=0`, `ro.adb.secure=0`

## 参考链接

- OrangeFox Recovery: https://github.com/OrangeFox-Recovery
- OmniROM: https://github.com/omnirom
- crDroid: https://www.crdroid.net