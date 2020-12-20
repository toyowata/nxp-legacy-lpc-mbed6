/******************************************************************************
 * @file:    system_LPC8xx.h
 * @purpose: CMSIS Cortex-M0+ Device Peripheral Access Layer Header File
 *           for the NXP LPC8xx Device Series
 * @version: V1.0
 * @date:    16. Aug. 2012
 *----------------------------------------------------------------------------
 *
 * Copyright (C) 2012-2020 ARM Limited. All rights reserved.
 * SPDX-License-Identifier: Apache-2.0
 *
 ******************************************************************************/


#ifndef __SYSTEM_LPC8xx_H
#define __SYSTEM_LPC8xx_H

#ifdef __cplusplus
extern "C" {
#endif

#include <stdint.h>

extern uint32_t SystemCoreClock;     /*!< System Clock Frequency (Core Clock)  */
extern uint32_t MainClock;           /*!< Main Clock Frequency */


/**
 * Initialize the system
 *
 * @param  none
 * @return none
 *
 * @brief  Setup the microcontroller system.
 *         Initialize the System and update the SystemCoreClock variable.
 */
extern void SystemInit (void);

/**
 * Update SystemCoreClock variable
 *
 * @param  none
 * @return none
 *
 * @brief  Updates the SystemCoreClock with current core Clock
 *         retrieved from cpu registers.
 */
extern void SystemCoreClockUpdate (void);

#ifdef __cplusplus
}
#endif

#endif /* __SYSTEM_LPC8xx_H */
