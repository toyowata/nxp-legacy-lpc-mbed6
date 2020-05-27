# NXP legacy LPC target support for Mbed OS 6
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

## Support target plan

* SSCI824
* LPCXpresso1549

## DAPLink firmware binary

... comming soon

## How to add custom target to mbed-os-tools

https://github.com/ARMmbed/mbed-os-tools/tree/master/packages/mbed-ls#mocking-renaming-platforms

Example: Adding AE-LPC11U35-MB custom target

```
$ mbedls --mock CTY0:AE_LPC11U35_MB
```
