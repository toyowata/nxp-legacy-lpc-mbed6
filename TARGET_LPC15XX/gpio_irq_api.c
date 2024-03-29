/* mbed Microcontroller Library
 * Copyright (c) 2006-2020 ARM Limited
 * SPDX-License-Identifier: Apache-2.0
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
#include <stddef.h>

#include "cmsis.h"
#include "gpio_irq_api.h"
#include "mbed_error.h"

#define CHANNEL_NUM 8
#define LPC_GPIO_X LPC_PINT
#define PININT_IRQ PIN_INT0_IRQn

static uint32_t channel_ids[CHANNEL_NUM] = {0};
static gpio_irq_handler irq_handler;

static inline void handle_interrupt_in(uint32_t channel) {
    uint32_t ch_bit = (1 << channel);
    // Return immediately if:
    //   * The interrupt was already served
    //   * There is no user handler
    //   * It is a level interrupt, not an edge interrupt
    if ( ((LPC_GPIO_X->IST & ch_bit) == 0) ||
         (channel_ids[channel] == 0      ) ||
         (LPC_GPIO_X->ISEL & ch_bit      ) ) return;

    if ((LPC_GPIO_X->IENR & ch_bit) && (LPC_GPIO_X->RISE & ch_bit)) {
        irq_handler(channel_ids[channel], IRQ_RISE);
        LPC_GPIO_X->RISE = ch_bit;
    }
    if ((LPC_GPIO_X->IENF & ch_bit) && (LPC_GPIO_X->FALL & ch_bit)) {
        irq_handler(channel_ids[channel], IRQ_FALL);
        LPC_GPIO_X->FALL = ch_bit;
    }
    LPC_GPIO_X->IST = ch_bit;
}

void gpio_irq0(void) {handle_interrupt_in(0);}
void gpio_irq1(void) {handle_interrupt_in(1);}
void gpio_irq2(void) {handle_interrupt_in(2);}
void gpio_irq3(void) {handle_interrupt_in(3);}
void gpio_irq4(void) {handle_interrupt_in(4);}
void gpio_irq5(void) {handle_interrupt_in(5);}
void gpio_irq6(void) {handle_interrupt_in(6);}
void gpio_irq7(void) {handle_interrupt_in(7);}

int gpio_irq_init(gpio_irq_t *obj, PinName pin, gpio_irq_handler handler, uintptr_t id) {
    // PINT only supprt GPIO port 0 and 1 interrupt
    if (pin >= P2_0) return -1;
    
    irq_handler = handler;
    
    int found_free_channel = 0;
    int i = 0;
    for (i=0; i<CHANNEL_NUM; i++) {
        if (channel_ids[i] == 0) {
            channel_ids[i] = id;
            obj->ch = i;
            found_free_channel = 1;
            break;
        }
    }
    if (!found_free_channel) return -1;
    
    /* Enable AHB clock to the PIN, GPIO0/1, IOCON and MUX domain. */
    LPC_SYSCON->SYSAHBCLKCTRL0 |= ((1 << 18) | (0x1D << 11));
    
    LPC_INMUX->PINTSEL[obj->ch] = pin;
    
    // Interrupt Wake-Up Enable
    LPC_SYSCON->STARTERP0 |= (1 << (obj->ch + 5));
    
    LPC_GPIO_PORT->DIR[pin >> 5]  &= ~(1 << (pin & 0x1F));
    
    void (*channels_irq)(void) = NULL;
    switch (obj->ch) {
        case 0: channels_irq = &gpio_irq0; break;
        case 1: channels_irq = &gpio_irq1; break;
        case 2: channels_irq = &gpio_irq2; break;
        case 3: channels_irq = &gpio_irq3; break;
        case 4: channels_irq = &gpio_irq4; break;
        case 5: channels_irq = &gpio_irq5; break;
        case 6: channels_irq = &gpio_irq6; break;
        case 7: channels_irq = &gpio_irq7; break;
    }
    NVIC_SetVector((IRQn_Type)(PININT_IRQ + obj->ch), (uint32_t)channels_irq);
    NVIC_EnableIRQ((IRQn_Type)(PININT_IRQ + obj->ch));
    
    return 0;
}

void gpio_irq_free(gpio_irq_t *obj) {
    channel_ids[obj->ch] = 0;
    LPC_SYSCON->STARTERP0 &= ~(1 << (obj->ch + 5));
}

void gpio_irq_set(gpio_irq_t *obj, gpio_irq_event event, uint32_t enable) {
    unsigned int ch_bit = (1 << obj->ch);
    
    // Clear interrupt
    if (!(LPC_GPIO_X->ISEL & ch_bit))
        LPC_GPIO_X->IST = ch_bit;
    
    // Edge trigger
    LPC_GPIO_X->ISEL &= ~ch_bit;
    if (event == IRQ_RISE) {
        if (enable) {
            LPC_GPIO_X->IENR |= ch_bit;
        } else {
            LPC_GPIO_X->IENR &= ~ch_bit;
        }
    } else {
        if (enable) {
            LPC_GPIO_X->IENF |= ch_bit;
        } else {
            LPC_GPIO_X->IENF &= ~ch_bit;
        }
    }
}

void gpio_irq_enable(gpio_irq_t *obj) {
    NVIC_EnableIRQ((IRQn_Type)(PININT_IRQ + obj->ch));
}

void gpio_irq_disable(gpio_irq_t *obj) {
    NVIC_DisableIRQ((IRQn_Type)(PININT_IRQ + obj->ch));
}
