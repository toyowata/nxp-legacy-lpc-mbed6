/* Linker script for mbed LPC11U68 */
 
#if !defined(MBED_BOOT_STACK_SIZE)
    #define MBED_BOOT_STACK_SIZE 0x400
#endif

STACK_SIZE = MBED_BOOT_STACK_SIZE;

/* Linker script to configure memory regions. */
MEMORY
{
  /* Define each memory region */
  FLASH (rx)      : ORIGIN = 0x00000000, LENGTH = 256K
  Ram0_32 (rwx)   : ORIGIN = 0x10000000 + 0x100, LENGTH = (32K - 0x100)
  Ram1_2 (rwx)    : ORIGIN = 0x20000000, LENGTH = 2K
  Ram2USB_2 (rwx) : ORIGIN = 0x20004000, LENGTH = 2K
}

  /* Define a symbol for the top of each memory region */
  __top_FLASH = 0x0 + 0x40000;
  __top_Ram0_32 = 0x10000000 + 0x8000;
  __top_Ram1_2 = 0x20000000 + 0x800;
  __top_Ram2USB_2 = 0x20004000 + 0x800;

ENTRY(Reset_Handler)

SECTIONS
{
    /* MAIN TEXT SECTION */    
    .text : ALIGN(8)
    {
        KEEP(*(.isr_vector))        
        
        *(.text*)
        *(.rodata .rodata.*)
        . = ALIGN(8);
        
        /* C++ constructors etc */
        . = ALIGN(8);
        KEEP(*(.init))
        
        . = ALIGN(8);
        __preinit_array_start = .;
        KEEP (*(.preinit_array))
        __preinit_array_end = .;
        
        . = ALIGN(8);
        __init_array_start = .;
        KEEP (*(SORT(.init_array.*)))
        KEEP (*(.init_array))
        __init_array_end = .;
        
        KEEP(*(.fini));
        
        /* .ctors */
        *crtbegin.o(.ctors)
        *crtbegin?.o(.ctors)
        *(EXCLUDE_FILE(*crtend?.o *crtend.o) .ctors)
        *(SORT(.ctors.*))
        *(.ctors)

        /* .dtors */
        *crtbegin.o(.dtors)
        *crtbegin?.o(.dtors)
        *(EXCLUDE_FILE(*crtend?.o *crtend.o) .dtors)
        *(SORT(.dtors.*))
        *(.dtors)
    } > FLASH

    /*
     * for exception handling/unwind - some Newlib functions (in common
     * with C++ and STDC++) use this. 
     */
    .ARM.extab : ALIGN(8)
    {
    	*(.ARM.extab* .gnu.linkonce.armextab.*)
    } > FLASH
    __exidx_start = .;
    
    .ARM.exidx : ALIGN(8)
    {
    	*(.ARM.exidx* .gnu.linkonce.armexidx.*)
    } > FLASH
    __exidx_end = .;
    
    _etext = .;
	
	/* Main DATA section (Ram0_32) */
	.data : ALIGN(8)
	{
	    FILL(0xff)
	    _data = . ;
	    *(vtable)
	    *(.ramfunc*)
	    *(.data*)
	    . = ALIGN(8) ;
	    _edata = . ;
	} > Ram0_32 AT>FLASH

    /* MAIN BSS SECTION */
    .bss : ALIGN(8)
    {
        __bss_start__ = .;
        *(.bss*)
        *(COMMON)
        __bss_end__ = .;
    } > Ram0_32

    PROVIDE(_pvHeapStart = .);
    .heap :
    {
        __end__ = .;
        end = __end__;
        *(.heap*)
        . = ORIGIN(Ram0_32) + LENGTH(Ram0_32) - STACK_SIZE;
        __HeapLimit = .;
    } > Ram0_32


    /* .stack_dummy section doesn't contains any symbols. It is only
     * used for linker to calculate size of stack sections, and assign
     * values to stack symbols later */
    .stack_dummy :
    {
        *(.stack)
    } > Ram0_32

    /* Set stack top to end of RAM, and stack limit move down by
     * size of stack_dummy section */
    __StackTop = ORIGIN(Ram0_32) + LENGTH(Ram0_32);
    __StackLimit = __StackTop - STACK_SIZE;
    
    PROVIDE(__stack = __StackTop);
    // PROVIDE(_vStackTop = __StackTop);

    /* Check if data + heap + stack exceeds RAM limit */
    ASSERT(__StackLimit >= __HeapLimit, "region RAM overflowed with stack")
}
