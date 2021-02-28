/* File: startup_LPC11U68S
 * 
 * Copyright (C) 2011-2021 ARM Limited. All rights reserved.
 * SPDX-License-Identifier: Apache-2.0
 *
 */
    .syntax unified
    .arch armv6-m

/* Memory Model
   The HEAP starts at the end of the DATA section and grows upward.
   
   The STACK starts at the end of the RAM and grows downward.
   
   The HEAP and stack STACK are only checked at compile time:
   (DATA_SIZE + HEAP_SIZE + STACK_SIZE) < RAM_SIZE
   
   This is just a check for the bare minimum for the Heap+Stack area before
   aborting compilation, it is not the run time limit:
   Heap_Size + Stack_Size = 0x80 + 0x80 = 0x100
 */
    .section .stack
    .align 3
#ifdef __STACK_SIZE
    .equ    Stack_Size, __STACK_SIZE
#else
    .equ    Stack_Size, 0xc00
#endif
    .globl    __StackTop
    .globl    __StackLimit
__StackLimit:
    .space    Stack_Size
    .size __StackLimit, . - __StackLimit
__StackTop:
    .size __StackTop, . - __StackTop

    .section .heap
    .align 3
#ifdef __HEAP_SIZE
    .equ    Heap_Size, __HEAP_SIZE
#else
    .equ    Heap_Size, 0x800
#endif
    .globl    __HeapBase
    .globl    __HeapLimit
__HeapBase:
    .space    Heap_Size
    .size __HeapBase, . - __HeapBase
__HeapLimit:
    .size __HeapLimit, . - __HeapLimit
    
    .section .isr_vector
    .align 2
    .globl __isr_vector
__isr_vector:
    .long    __StackTop            /* Top of Stack */
    .long    Reset_Handler         /* Reset Handler */
    .long    NMI_Handler           /* NMI Handler */
    .long    HardFault_Handler     /* Hard Fault Handler */
    .long    0                     /* Reserved */
    .long    0                     /* Reserved */
    .long    0                     /* Reserved */
    .long    0                     /* Reserved */
    .long    0                     /* Reserved */
    .long    0                     /* Reserved */
    .long    0                     /* Reserved */
    .long    SVC_Handler           /* SVCall Handler */
    .long    0                     /* Reserved */
    .long    0                     /* Reserved */
    .long    PendSV_Handler        /* PendSV Handler */
    .long    SysTick_Handler       /* SysTick Handler */

    // Chip Level - LPC11U68
    .long   PIN_INT0_IRQHandler             //  0 - GPIO pin interrupt 0
    .long   PIN_INT1_IRQHandler             //  1 - GPIO pin interrupt 1
    .long   PIN_INT2_IRQHandler             //  2 - GPIO pin interrupt 2
    .long   PIN_INT3_IRQHandler             //  3 - GPIO pin interrupt 3
    .long   PIN_INT4_IRQHandler             //  4 - GPIO pin interrupt 4
    .long   PIN_INT5_IRQHandler             //  5 - GPIO pin interrupt 5
    .long   PIN_INT6_IRQHandler             //  6 - GPIO pin interrupt 6
    .long   PIN_INT7_IRQHandler             //  7 - GPIO pin interrupt 7
    .long   GINT0_IRQHandler                //  8 - GPIO GROUP0 interrupt
    .long   GINT1_IRQHandler                //  9 - GPIO GROUP1 interrupt
    .long   I2C1_IRQHandler                 // 10 - I2C1
    .long   USART1_4_IRQHandler             // 11 - combined USART1 & 4 interrupt
    .long   USART2_3_IRQHandler             // 12 - combined USART2 & 3 interrupt
    .long   SCT0_1_IRQHandler               // 13 - combined SCT0 and 1 interrupt
    .long   SSP1_IRQHandler                 // 14 - SPI/SSP1 Interrupt
    .long   I2C0_IRQHandler                 // 15 - I2C0
    .long   TIMER16_0_IRQHandler            // 16 - CT16B0 (16-bit Timer 0)
    .long   TIMER16_1_IRQHandler            // 17 - CT16B1 (16-bit Timer 1)
    .long   TIMER32_0_IRQHandler            // 18 - CT32B0 (32-bit Timer 0)
    .long   TIMER32_1_IRQHandler            // 19 - CT32B1 (32-bit Timer 1)
    .long   SSP0_IRQHandler                 // 20 - SPI/SSP0 Interrupt
    .long   USART0_IRQHandler               // 21 - USART0
    .long   USB_IRQHandler                  // 22 - USB IRQ
    .long   USB_FIQHandler                  // 23 - USB FIQ
    .long   ADCA_IRQHandler                 // 24 - ADC A(A/D Converter)
    .long   RTC_IRQHandler                  // 25 - Real Time CLock interrpt
    .long   BOD_WDT_IRQHandler              // 25 - Combined Brownout/Watchdog interrupt
    .long   FMC_IRQHandler                  // 27 - IP2111 Flash Memory Controller
    .long   DMA_IRQHandler                  // 28 - DMA interrupt
    .long   ADCB_IRQHandler                 // 24 - ADC B (A/D Converter)
    .long   USBWakeup_IRQHandler            // 30 - USB wake-up interrupt
    .long   0                               // 31 - Reserved

    .size    __isr_vector, . - __isr_vector

    .text
    .thumb
    .thumb_func
    .align 2
    .globl   Reset_Handler
    .type    Reset_Handler, %function
Reset_Handler:
/*     Loop to copy data from read only memory to RAM. The ranges
 *      of copy from/to are specified by following symbols evaluated in 
 *      linker script.
 *      _etext: End of code section, i.e., begin of data sections to copy from.
 *      __data_start__/__data_end__: RAM address range that data should be
 *      copied to. Both must be aligned to 4 bytes boundary.  */

    ldr    r1, =_etext
    ldr    r2, =_data
    ldr    r3, =_edata

    subs    r3, r2
    ble    .Lflash_to_ram_loop_end

    movs    r4, 0
.Lflash_to_ram_loop:
    ldr    r0, [r1,r4]
    str    r0, [r2,r4]
    adds    r4, 4
    cmp    r4, r3
    blt    .Lflash_to_ram_loop
.Lflash_to_ram_loop_end:

    ldr    r0, =SystemInit
    blx    r0
    ldr    r0, =_start
    bx    r0
    .pool
    .size Reset_Handler, . - Reset_Handler
    
    .text
/*    Macro to define default handlers. Default handler
 *    will be weak symbol and just dead loops. They can be
 *    overwritten by other handlers */
    .macro    def_default_handler    handler_name
    .align 1
    .thumb_func
    .weak    \handler_name
    .type    \handler_name, %function
\handler_name :
    b    .
    .size    \handler_name, . - \handler_name
    .endm

    def_default_handler    NMI_Handler
    def_default_handler    HardFault_Handler
    def_default_handler    SVC_Handler
    def_default_handler    PendSV_Handler
    def_default_handler    SysTick_Handler
    def_default_handler    Default_Handler

    .macro    def_irq_default_handler    handler_name
    .weak     \handler_name
    .set      \handler_name, Default_Handler
    .endm
 /*
    def_irq_default_handler     WDT_IRQHandler
    def_irq_default_handler     BOD_IRQHandler
    def_irq_default_handler     FMC_IRQHandler
    def_irq_default_handler     EEPROM_IRQHandler
    def_irq_default_handler     DMA_IRQHandler
    def_irq_default_handler     GINT0_IRQHandler
    def_irq_default_handler     GINT1_IRQHandler
    def_irq_default_handler     PIN_INT0_IRQHandler
    def_irq_default_handler     PIN_INT1_IRQHandler
    def_irq_default_handler     PIN_INT2_IRQHandler
    def_irq_default_handler     PIN_INT3_IRQHandler
    def_irq_default_handler     PIN_INT4_IRQHandler
    def_irq_default_handler     PIN_INT5_IRQHandler
    def_irq_default_handler     PIN_INT6_IRQHandler
    def_irq_default_handler     PIN_INT7_IRQHandler
    def_irq_default_handler     RIT_IRQHandler
    def_irq_default_handler     SCT0_IRQHandler
    def_irq_default_handler     SCT1_IRQHandler
    def_irq_default_handler     SCT2_IRQHandler
    def_irq_default_handler     SCT3_IRQHandler
    def_irq_default_handler     MRT_IRQHandler
    def_irq_default_handler     UART0_IRQHandler
    def_irq_default_handler     UART1_IRQHandler
    def_irq_default_handler     UART2_IRQHandler
    def_irq_default_handler     I2C0_IRQHandler
    def_irq_default_handler     SPI0_IRQHandler
    def_irq_default_handler     SPI1_IRQHandler
    def_irq_default_handler     CAN_IRQHandler
    def_irq_default_handler     USB_IRQHandler
    def_irq_default_handler     USB_FIQHandler
    def_irq_default_handler     USBWakeup_IRQHandler
    def_irq_default_handler     ADC0A_IRQHandler
    def_irq_default_handler     ADC0B_IRQHandler
    def_irq_default_handler     ADC0_THCMP_IRQHandler
    def_irq_default_handler     ADC0_OVR_IRQHandler
    def_irq_default_handler     ADC1A_IRQHandler
    def_irq_default_handler     ADC1B_IRQHandler
    def_irq_default_handler     ADC1_THCMP_IRQHandler
    def_irq_default_handler     ADC1_OVR_IRQHandler
    def_irq_default_handler     DAC_IRQHandler
    def_irq_default_handler     ACMP0_IRQHandler
    def_irq_default_handler     ACMP1_IRQHandler
    def_irq_default_handler     ACMP2_IRQHandler
    def_irq_default_handler     ACMP3_IRQHandler
    def_irq_default_handler     QEI_IRQHandler
    def_irq_default_handler     RTC_ALARM_IRQHandler
    def_irq_default_handler     RTC_WAKE_IRQHandler
    def_irq_default_handler     DEF_IRQHandler
*/
    def_irq_default_handler   PIN_INT0_IRQHandler             //  0 - GPIO pin interrupt 0
    def_irq_default_handler   PIN_INT1_IRQHandler             //  1 - GPIO pin interrupt 1
    def_irq_default_handler   PIN_INT2_IRQHandler             //  2 - GPIO pin interrupt 2
    def_irq_default_handler   PIN_INT3_IRQHandler             //  3 - GPIO pin interrupt 3
    def_irq_default_handler   PIN_INT4_IRQHandler             //  4 - GPIO pin interrupt 4
    def_irq_default_handler   PIN_INT5_IRQHandler             //  5 - GPIO pin interrupt 5
    def_irq_default_handler   PIN_INT6_IRQHandler             //  6 - GPIO pin interrupt 6
    def_irq_default_handler   PIN_INT7_IRQHandler             //  7 - GPIO pin interrupt 7
    def_irq_default_handler   GINT0_IRQHandler                //  8 - GPIO GROUP0 interrupt
    def_irq_default_handler   GINT1_IRQHandler                //  9 - GPIO GROUP1 interrupt
    def_irq_default_handler   I2C1_IRQHandler                 // 10 - I2C1
    def_irq_default_handler   USART1_4_IRQHandler             // 11 - combined USART1 & 4 interrupt
    def_irq_default_handler   USART2_3_IRQHandler             // 12 - combined USART2 & 3 interrupt
    def_irq_default_handler   SCT0_1_IRQHandler               // 13 - combined SCT0 and 1 interrupt
    def_irq_default_handler   SSP1_IRQHandler                 // 14 - SPI/SSP1 Interrupt
    def_irq_default_handler   I2C0_IRQHandler                 // 15 - I2C0
    def_irq_default_handler   TIMER16_0_IRQHandler            // 16 - CT16B0 (16-bit Timer 0)
    def_irq_default_handler   TIMER16_1_IRQHandler            // 17 - CT16B1 (16-bit Timer 1)
    def_irq_default_handler   TIMER32_0_IRQHandler            // 18 - CT32B0 (32-bit Timer 0)
    def_irq_default_handler   TIMER32_1_IRQHandler            // 19 - CT32B1 (32-bit Timer 1)
    def_irq_default_handler   SSP0_IRQHandler                 // 20 - SPI/SSP0 Interrupt
    def_irq_default_handler   USART0_IRQHandler               // 21 - USART0
    def_irq_default_handler   USB_IRQHandler                  // 22 - USB IRQ
    def_irq_default_handler   USB_FIQHandler                  // 23 - USB FIQ
    def_irq_default_handler   ADCA_IRQHandler                 // 24 - ADC A(A/D Converter)
    def_irq_default_handler   RTC_IRQHandler                  // 25 - Real Time CLock interrpt
    def_irq_default_handler   BOD_WDT_IRQHandler              // 25 - Combined Brownout/Watchdog interrupt
    def_irq_default_handler   FMC_IRQHandler                  // 27 - IP2111 Flash Memory Controller
    def_irq_default_handler   DMA_IRQHandler                  // 28 - DMA interrupt
    def_irq_default_handler   ADCB_IRQHandler                 // 24 - ADC B (A/D Converter)
    def_irq_default_handler   USBWakeup_IRQHandler            // 30 - USB wake-up interrupt

    .end

