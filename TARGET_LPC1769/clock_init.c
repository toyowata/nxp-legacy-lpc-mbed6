/* mbed Microcontroller Library
 * Copyright (c) 2020 ARM Limited
 * SPDX-License-Identifier: Apache-2.0
 */
#include <stdint.h>
#include "LPC17xx.h"

void mbed_sdk_init(void)
{
    LPC_SC->CCLKCFG   = 3;              // Setup Clock Divider = 4 (-1)
    LPC_SC->PLL0CFG   = 0x00050077;     // Fcco = 480MHz
    LPC_SC->PLL0FEED  = 0xAA;
    LPC_SC->PLL0FEED  = 0x55;
    LPC_SC->USBCLKCFG = 0x00000009;     // Setup USB Clock Divider
    LPC_SC->FLASHCFG  = (LPC_SC->FLASHCFG & ~0x0000F000) | 0x00004000;
    SystemCoreClockUpdate();
}
