# Device Tree for OnePlus PKR110 (Ace 5 Pro)

![OnePlus Ace 5 Pro](https://file.honor.cn/honor-file/1000001/202401/2257/2115/IMG_2201_2257.8e94dcf0b8eeb8d7703220474684dc5b.png)

| Basic               | Spec Sheet                                                    |
|-------------------- |-------------------------------------------------------------|
| CPU                 | Octa-core (Snapdragon 8 Gen 4 / SM8750)                       |
| Chipset             | Qualcomm SM8750 Snapdragon 8 Gen 4                           |
| GPU                 | Adreno 830                                                   |
| Memory              | 12GB/16GB RAM                                                 |
| Android Version     | 16 (API 36)                                                  |
| Storage             | 256GB/512GB UFS 4.0                                           |

## Working Features
- Vibration/Haptic
- Flashing .img/zip
- ADB Sideload
- Terminal/Console
- External Storage (OTG)
- Full A/B partition support

## Bugs and Issues
- Internal Storage (Encrypted, if lockscreen is enable)
- Internal Storage (Decrypted, if lockscreen is disable)
- MTP; might need to disable and enable MTP button to work

## Notes
- This is an OrangeFox Recovery device tree for OnePlus PKR110 (Ace 5 Pro)
- Kernel source: Not available (using prebuilt kernel)
- Device codename: PKR110 / OP60EBL1

## Building

### Prerequisites
```bash
# Install required tools
sudo apt-get update
sudo apt-get -y install git gnupg dialog jfsutils reiser4progs reiserfsprogs xfsprogs btrfs-progs \
    squashfs-tools lzop zip cgzstd bzip2 xz-utils dracut-lfs grub-pc-bin mtools dosfstools \
    uefi-emu swig policykit-1 android-sdk-filesystem android-tools-fsutils ccache

# Install OpenJDK
sudo apt-get -y install openjdk-11-jdk

# Setup build environment
source build/envsetup.sh
```

### Build Steps
```bash
# Source vendorsetup to set OrangeFox environment variables
source vendorsetup.sh

# Choose device
lunch omni_PKR110-eng

# Clean build
make clean

# Build recovery image
make recoveryimage -j$(nproc --all)
```

### Build Output
The recovery image will be located at:
```
out/target/product/PKR110/recovery.img
```

## Configuration
See [AGENTS.md](AGENTS.md) for detailed configuration information.

## Credits
- TeamWin Recovery Project (TWRP)
- OrangeFox Recovery Project (OFR)
- OrangeFox Device Tree Generator
- All contributors and testers

## License
Android Open Source Project License
