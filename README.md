# NXP legacy LPC target support for Mbed OS 6 baremetal
Custom target boards support for legacy NXP LPC series MCUs

# How to build and flash to target board

## Mbed CLI 1
```
$ mbed import https://github.com/toyowata/nxp-legacy-lpc-mbed6
$ cd nxp-legacy-lpc-mbed6
$ mbed compile -m AE_LPC11U35_MB -t gcc_arm --flash
```
## Mbed CLI 2
```
$ mbed-tools import https://github.com/toyowata/nxp-legacy-lpc-mbed6
$ cd nxp-legacy-lpc-mbed6
$ mbed-tools compile -m LPC11U68 -t gcc_arm --flash
```
## Mbed Studio
* Launch Mbed Studio application
* Menu [File] - [Import Program...]
* Put `https://github.com/toyowata/nxp-legacy-lpc-mbed6` in the URL box
* Press `Add Program` button
* Select target and build program

## Support target board

|Board|Target name|
|---|---|
|[Akizuki denshi AE-LPC11U35-MB](http://akizukidenshi.com/catalog/g/gK-12144/)| AE_LPC11U35_MB|
|[Crane Electronics Airio Base](https://crane-elec.co.jp/products/vol-14_airio-base/)|AIRIO_BASE|
|[Switch Science mbed LPC824](https://os.mbed.com/platforms/Switch-Science-mbed-LPC824/)|SSCI824|
|[NXP LPCXpresso824-MAX](https://os.mbed.com/platforms/LPCXpresso824-MAX/)|LPC824|
|[NXP LPCXpresso1549](https://os.mbed.com/platforms/LPCXpresso1549/)|LPC1549|
|[NXP LPCXpresso1769 (OM13085)](https://www.embeddedartists.com/products/lpcxpresso1769/)|LPC1769|
|[NXP LPCXpresso11U68](https://os.mbed.com/platforms/LPCXpresso11U68/)|LPC11U68|

## DAPLink firmware binary

* DAPLink interface firmware for AE-LPC11U35-MB [ae-lpc11u35-mb_crc.zip](https://www.dropbox.com/s/36kayln4iz1vbbk/ae-lpc11u35-mb_crc.zip?dl=0)  
Reference: https://qiita.com/toyowata/items/a57ee1dfa884b29c298d
* DAPLink interface firmware for Airio Base [lpc11u35_airio_base_if_crc.bin](./daplink/lpc11u35_airio_base_if_crc.bin)
* DAPLink interface firmware for NXP LPCXpresso1769 (OM13085) [lpc11u35_lpc1769_if_crc.bin](./daplink/lpc11u35_lpc1769_if_crc.bin)  
Reference: https://os.mbed.com/users/MACRUM/notebook/lpcxpresso1769-om13085/

## How to add custom target to mbed-os-tools

https://github.com/ARMmbed/mbed-os-tools/tree/master/packages/mbed-ls#mocking-renaming-platforms

Example: Adding AE-LPC11U35-MB custom target

```
$ mbedls --mock CA00:AE_LPC11U35_MB
```
## How to use RTOS feature

Remove `"bare-metal"` from `requires` key in the mbed_app.json.

```
    "requires": ["bare-metal"],
```

## Known issues
* LPC824 CLI2 build (GCC_ARM) binary doesn't boot-up
* Mbed CLI2 doesn't seem to support `--flash` option for custom target
