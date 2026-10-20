# T3 Technology T626Pro V2 (Skyworth PT632) — Complete Flashing & Unbricking Guide

This guide details all methods to upgrade, mod, or revive the **T3 Technology T626Pro V2 / Skyworth PT632 / EcoNet EN7529CT** router.

---

## Hardware Specifications
* **CPU:** EcoNet EN7529CT Dual-Core ARMv7 Cortex-A53 (AArch32 soft-float)
* **Flash:** 256 MiB Micron SPI NAND (`MT29F2G01`, Erase: 128 KiB, Page: 2048)
* **RAM:** 256 MiB DDR3
* **UART Serial Header:** 115200 baud, 8 data bits, no parity, 1 stop bit (3.3V TTL)
* **Default IP:** `192.168.1.1` (or `192.168.1.2` when secondary)
* **SSH / Root Port:** `22` (`superadmin` / `lament`)
* **Web Terminal:** `http://<IP>:7681` (`superadmin` / `lament`)

---

## Method 1: Official Web UI Upgrade (Safest / No Cables Required)

1. Open your browser and navigate to `http://192.168.1.1` (or your router's LAN IP).
2. Log into the Web Interface with your administrator credentials.
3. Navigate to **Maintenance** -> **Firmware Upgrade**.
4. Click **Choose File** and select:
   ```text
   1_WebUI_and_TFTP_Flashable/tclinux_v1.0.07_modded_bank1.bin
   ```
5. Click **Upload / Upgrade**.
6. Do NOT power off the router. The device will write to the inactive bank, verify checksums, and reboot smoothly.

---

## Method 2: No-Flash Drop-in ModPack (Instant Toolkit without Flashing)

If you have root/shell access to any stock T626Pro / T626ProV2 and just want `htop`, `nano`, `rsync`, `curl`, `ttyd`, `iperf3`, `tcpdump`, and Dropbear SSH without modifying kernel or rootfs:

1. Copy `4_Dropin_ModPack_NoFlash/` to the router's `/tmp` directory:
   ```bash
   scp -r 4_Dropin_ModPack_NoFlash/* superadmin@192.168.1.1:/tmp/
   ```
2. Log into the router shell and run:
   ```bash
   cd /tmp
   chmod +x install_toolkit.sh
   ./install_toolkit.sh
   ```
3. All binaries are permanently deployed into `/custom_app/bin/` and will survive reboots!

---

## Method 3: U-Boot Serial / TFTP Recovery (Debricking Soft-Bricks)

If the device fails to boot into Linux:

1. Connect a 3.3V USB-to-UART adapter to the router's serial header (`TX`, `RX`, `GND`).
2. Open terminal: `picocom -b 115200 /dev/ttyUSB0`.
3. Power on the router and hit **Space** or **Enter** immediately to interrupt the bootloader.
4. Set up TFTP environment:
   ```text
   setenv ipaddr 192.168.1.1
   setenv serverip 192.168.1.100
   ```
5. On your PC (running TFTP server at `192.168.1.100`), place `tclinux_v1.0.07_stock_bank0.bin` renamed as `tclinux.bin`.
6. From the U-Boot prompt:
   ```text
   tftpboot 0x81000000 tclinux.bin
   flash imgwrite 0x81000000
   bootm
   ```

---

## Method 4: Full Hardware SPI NAND Programmer (Total Unbrick / Zero Boot)

If the bootloader itself is corrupted or erased:

1. Clip your SPI NAND Programmer (e.g. **CH341A**, **XGecu T48**, **T56**, or **Dediprog**) to the Micron MT29F2G01 chip.
2. Select IC Model: `MT29F2G01ABAFD` (or generic 256MB SPI NAND 3.3V).
3. Load the full image:
   ```text
   2_Full_SPI_NAND_Programmer_Dump/full_spi_nand_256mb_programmer.bin
   ```
4. Erase & Write. The router will be restored to 100% factory bootable condition with dual-bank recovery.

---

## Method 5: Dual-Bank Switching (Rollback Bank 0 vs Bank 1)

This router features a fail-safe dual-bank flash architecture:
* **Bank 0:** `mtd2` (kernel) + `mtd3` (rootfs) -> Container: `mtd4` (`tclinux`)
* **Bank 1:** `mtd5` (kernel_slave) + `mtd6` (rootfs_slave) -> Container: `mtd7` (`tclinux_slave`)

To toggle which bank boots, run in the Linux shell:
```bash
# Switch to Bank 0 (Stock fallback)
fw_setenv bootflag 0

# Switch to Bank 1 (Modded active)
fw_setenv bootflag 1
```
