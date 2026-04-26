# Prebuilt Files for OnePlus PKR110 (Ace 5 Pro)

This directory contains prebuilt kernel images needed for OrangeFox Recovery.

## Required Files

You need to extract the following files from crDroid's boot.img and place them in this directory:

1. **Image.gz** - The kernel image
2. **dtb** - The device tree blob
3. **dtbo.img** - The device tree overlay image

## How to Extract

### Method 1: Using magiskboot (Recommended)

```bash
# Download magiskboot
wget https://github.com/topjohnwu/Magisk/releases/latest/download/Magisk-v26.3.zip
unzip Magisk-v26.3.zip

# Extract boot.img
./magiskboot unpack /path/to/boot.img

# Copy the required files
cp kernel Image.gz
cp dtb dtb
cp dtbo dtbo.img
```

### Method 2: Using Android Image Kitchen

1. Download Android Image Kitchen from XDA
2. Unpack boot.img
3. Copy the kernel image as `Image.gz`
4. Copy the dtb file as `dtb`
5. Copy the dtbo file as `dtbo.img`

### Method 3: Using extract.sh (From crdroid_twrp_extract)

If you have the `extract.sh` script from the crdroid_twrp_extract directory:

```bash
cd /sdcard/crdroid_twrp_extract
bash extract.sh /path/to/boot.img
```

This will extract the kernel and dtb files automatically.

## File Locations

- boot.img can be found in crDroid ROM zip file under `boot.img`
- Or dump it from your device: `adb pull /dev/block/by-name/boot_a boot.img`

## Verification

After placing the files, verify they exist:

```bash
ls -lh Image.gz dtb dtbo.img
```

Expected sizes (approximate):
- Image.gz: ~20-30 MB
- dtb: ~1-2 MB
- dtbo.img: ~1-2 MB

## Notes

- Make sure to use kernel and dtb from the same crDroid version
- Using mismatched files may cause boot issues
- If you have any issues, try extracting from a different boot.img slot (boot_b)