# DAPLink firmware binaries for NXP legacy LPC target board

DAPLink firmwares for custom target boards and other NXP boards

|Filename|Description|
|---|---|
|lpc4322_bl_crc.bin|LPC4322 bootloader|
|lpc11u35_ae_lpc11u35_mb_if_crc.bin|AE-LPC11U35-MB|
|lpc4322_lpc11u68xpresso_if_crc.bin|LPCXpresso11U68|
|lpc11u35_airio_base_if_crc.bin|Airio-Base|
|lpc4322_lpc1549xpresso_if_crc.bin|LPCXpresso1549|
|lpc11u35_lpc1769xpresso_if_crc.bin|LPCXpresso1769|

## How to flash the DAPLink firmware
### LPC11U35 based interface firmwares
#### AE-LPC11U35-MB, Airio-Base and LPCXpresso1769

1. Download the firmware file.
2. While holding down the boards reset button, connect the boards USB debug port to the computer. It should enumerate and mount as CRP DISABLD
3. Delete the file named firmware.bin
4. In a terminal execute:

```
$ sudo mount -u -w -o sync /Volumes/CRP\ DISABLD
$ rm /Volumes/CRP\ DISABLD/firmware.bin
$ cp -X <path to firmware file> /Volumes/CRP\ DISABLD/
```

5. Wait for the file copy operation to complete.
6. Power cycle the board. It will now enumerate and mount as DAPLINK or the name of the board.

### LPC4322 based interface firmwares
#### LPCXpresso11U68 and LPCXpresso1549

1. Download and install NXP LPCScrypt
https://www.nxp.com/design/microcontrollers-developer-resources/lpcscrypt-v2-1-2:LPCSCRYPT
2. Fit the jumper labelled "DFU"
3. Connect the "link" micro-B connector to the PC
4. Run LPCScrypt and follow the on-screen instructions.

```
$ /Applications/lpcscrypt_2.1.2_57/scripts/program_CMSIS lpc4322_bl_crc.bi
```

5. Remove the jumper "DFU" and unplug/plug in the LPCXpresso
6. You will now see a drive named MAINTENANCE.
7. Drag and drop the binary for your chose target onto this drive.

```
$ cp -X lpc4322_lpc1549xpresso_if_crc.bin /Volumes/MAINTENANCE
```

8. The drive will change name to the DAPLink target board.
