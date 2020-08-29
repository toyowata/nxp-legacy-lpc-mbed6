# NXP legacy LPC target support for Mbed OS 6 baremetal
Custom target boards support for legacy NXP LPC series MCU

# How to build and flash to target board

```
$ mbed import https://github.com/toyowata/nxp-legacy-lpc-mbed6
$ cd nxp-legacy-lpc-mbed6
$ mbed compile -m AE_LPC11U35_MB -t gcc_arm --flash
```

## Support target board

* [Akizuki denshi AE-LPC11U35-MB](http://akizukidenshi.com/catalog/g/gK-12144/)
* [Crane Electronics Airio Base](https://crane-elec.co.jp/products/vol-14_airio-base/)
* [Switch Science mbed LPC824](https://os.mbed.com/platforms/Switch-Science-mbed-LPC824/)
* [NXP LPCXpresso824-MAX](https://os.mbed.com/platforms/LPCXpresso824-MAX/)
* [NXP LPCXpresso1549](https://os.mbed.com/platforms/LPCXpresso1549/)

## Support target plan

* LPCXpresso1769 (OM13085)

## DAPLink firmware binary

* DAPLink interface firmware for Airio Base [lpc11u35_airio_base_if_crc.bin](./daplink/lpc11u35_airio_base_if_crc.bin)


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
