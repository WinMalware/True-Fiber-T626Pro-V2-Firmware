# True Fiber / T3 Technology T626Pro V2 (Skyworth PT632) Firmware & Modding Archive

[![Hardware](https://img.shields.io/badge/Hardware-EcoNet%20EN7529CT%20(ARMv7)-blue.svg)](#)
[![Flash](https://img.shields.io/badge/Flash-256MB%20SPI%20NAND-green.svg)](#)
[![Release](https://img.shields.io/badge/Version-v1.0.07-orange.svg)](#)
[![License](https://img.shields.io/badge/License-GPL%20v2-lightgrey.svg)](#)

A comprehensive firmware preservation, unlocking, and custom modding repository for the **T3 Technology T626Pro V2** (Skyworth PT632 / EcoNet EN7529CT dual-core ARMv7 Wi-Fi 6 router).

Inspired by [Blinko1987's True-Fiber-T626Pro-V1.0.0.5-Firmware](https://github.com/Blinko1987/True-Fiber-T626Pro-V1.0.0.5-Firmware), this archive provides full dual-bank firmware images, hardware programmer dumps, clean unlocked romfiles, and a modern Linux toolkit for V2 hardware.

---

## 📂 Repository Contents

```text
.
├── 1_WebUI_and_TFTP_Flashable/
│   ├── tclinux_v1.0.07_stock_bank0.bin         # Official Web GUI upgrade format (Bank 0)
│   ├── tclinux_v1.0.07_modded_bank1.bin        # Modded Web GUI upgrade (Cleaned, no portal)
│   └── sha256sums.txt
│
├── 2_Full_SPI_NAND_Programmer_Dump/
│   ├── full_spi_nand_256mb_programmer.bin      # 256MB dump for CH341A / T48 / T56 programmer
│   └── sha256sums.txt
│
├── 3_Raw_MTD_Partitions/                       # Individual partition images for nandwrite / flashcp
│   ├── mtd0_bootloader.bin                     # U-Boot bootloader & boot env
│   ├── mtd1_romfile.bin                        # Factory romfile & default XML config
│   ├── mtd2_kernel.bin / mtd5_kernel_slave.bin # Linux 4.4.115 kernels (Bank 0 / Bank 1)
│   ├── mtd3_rootfs.bin / mtd6_rootfs_slave.bin # SquashFS root filesystems
│   ├── mtd4_tclinux.bin / mtd7_tclinux_slave   # Complete bank containers (32MB)
│   ├── mtd8_config.bin                         # Persistent NVRAM config
│   ├── mtd9_ubifs.bin                          # Persistent writable overlay (/usr/ubifs)
│   ├── mtd10_rootfs_data.bin                   # JFFS2 rootfs data partition
│   ├── mtd11_custom_app.bin                    # Modern toolkit partition (48MB)
│   └── mtd12_reservearea.bin                   # Reserved & BMT/BBT pool
│
├── 4_Dropin_ModPack_NoFlash/                   # Drop-in toolkit (Works without flashing firmware)
│   ├── custom_app_toolkit.tar.gz               # htop, nano, rsync, curl, ttyd, tcpdump, etc.
│   └── install_toolkit.sh                      # 1-liner installer script
│
├── 5_Unlocked_Config/
│   ├── clean_unlocked_romfile.xml              # Sanitized XML with TR-069 ACS removed
│   └── factory_stock_romfile.cfg               # Stock default romfile archive
│
├── TheFileInsideMtds/                          # Unpacked source and rootfs filesystem trees
│
├── FLASHING_GUIDE.md                           # Detailed flashing & debricking manual
└── README.md
```

---

## 🛠️ Included ModPack Toolkit (ARMv7 Soft-Float)

All utilities are static-PIE compiled specifically for the EcoNet EN7529CT AArch32 architecture without floating-point trap crashes:

* **Monitoring & Administration:** `htop` (v3.3.0), `vnstat` & `vnstatd` (v1.18), `strace` (v6.7)
* **Networking & Diagnostics:** `iperf3` (v3.22), `tcpdump` (v4.99.4 + libpcap), `drill` / `dig` (v1.8.3), `curl` (v8.7.1 with OpenSSL 1.1.1w + Mozilla CA certs), `socat` (v1.8.0), `ethtool` (v5.15), `arp-scan` (v1.10.0)
* **Storage & File Transfer:** `rsync` (v3.2.7), `vsftpd` (v3.0.5), `mkfs.ext4` & `fsck.ext4` (e2fsprogs v1.47.0)
* **Editing & Remote Access:** `nano` (v7.2), `Dropbear SSH` (v2024.85), `ttyd` Web Terminal on port 7681

---

## 🚀 Quick Start

* For **Web UI Flashing**, consult [FLASHING_GUIDE.md](file:///run/media/moonlight/GameLibrary/Firmware%20works/FLASHING_GUIDE.md#L18-L30).
* For **No-Flash Toolkit Setup**, consult [FLASHING_GUIDE.md](file:///run/media/moonlight/GameLibrary/Firmware%20works/FLASHING_GUIDE.md#L32-L48).
* For **Hardware Programmer Debricking**, consult [FLASHING_GUIDE.md](file:///run/media/moonlight/GameLibrary/Firmware%20works/FLASHING_GUIDE.md#L70-L84).
