/*
 * system.h - SOPC Builder system and BSP software package information
 *
 * Machine generated for CPU 'cpu' in SOPC Builder design 'nios'
 * SOPC Builder design path: ../../nios.sopcinfo
 *
 * Generated: Mon Feb 12 15:17:49 CST 2018
 */

/*
 * DO NOT MODIFY THIS FILE
 *
 * Changing this file will have subtle consequences
 * which will almost certainly lead to a nonfunctioning
 * system. If you do modify this file, be aware that your
 * changes will be overwritten and lost when this file
 * is generated again.
 *
 * DO NOT MODIFY THIS FILE
 */

/*
 * License Agreement
 *
 * Copyright (c) 2008
 * Altera Corporation, San Jose, California, USA.
 * All rights reserved.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a
 * copy of this software and associated documentation files (the "Software"),
 * to deal in the Software without restriction, including without limitation
 * the rights to use, copy, modify, merge, publish, distribute, sublicense,
 * and/or sell copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
 * DEALINGS IN THE SOFTWARE.
 *
 * This agreement shall be governed in all respects by the laws of the State
 * of California and by the laws of the United States of America.
 */

#ifndef __SYSTEM_H_
#define __SYSTEM_H_

/* Include definitions from linker script generator */
#include "linker.h"


/*
 * CPU configuration
 *
 */

#define ALT_CPU_ARCHITECTURE "altera_nios2_gen2"
#define ALT_CPU_BIG_ENDIAN 0
#define ALT_CPU_BREAK_ADDR 0x00100820
#define ALT_CPU_CPU_ARCH_NIOS2_R1
#define ALT_CPU_CPU_FREQ 50000000u
#define ALT_CPU_CPU_ID_SIZE 1
#define ALT_CPU_CPU_ID_VALUE 0x00000000
#define ALT_CPU_CPU_IMPLEMENTATION "fast"
#define ALT_CPU_DATA_ADDR_WIDTH 0x15
#define ALT_CPU_DCACHE_LINE_SIZE 0
#define ALT_CPU_DCACHE_LINE_SIZE_LOG2 0
#define ALT_CPU_DCACHE_SIZE 0
#define ALT_CPU_EXCEPTION_ADDR 0x00080020
#define ALT_CPU_FLASH_ACCELERATOR_LINES 0
#define ALT_CPU_FLASH_ACCELERATOR_LINE_SIZE 0
#define ALT_CPU_FLUSHDA_SUPPORTED
#define ALT_CPU_FREQ 50000000
#define ALT_CPU_HARDWARE_DIVIDE_PRESENT 0
#define ALT_CPU_HARDWARE_MULTIPLY_PRESENT 1
#define ALT_CPU_HARDWARE_MULX_PRESENT 1
#define ALT_CPU_HAS_DEBUG_CORE 1
#define ALT_CPU_HAS_DEBUG_STUB
#define ALT_CPU_HAS_EXTRA_EXCEPTION_INFO
#define ALT_CPU_HAS_ILLEGAL_INSTRUCTION_EXCEPTION
#define ALT_CPU_HAS_JMPI_INSTRUCTION
#define ALT_CPU_ICACHE_LINE_SIZE 32
#define ALT_CPU_ICACHE_LINE_SIZE_LOG2 5
#define ALT_CPU_ICACHE_SIZE 8192
#define ALT_CPU_INST_ADDR_WIDTH 0x15
#define ALT_CPU_NAME "cpu"
#define ALT_CPU_NUM_OF_SHADOW_REG_SETS 0
#define ALT_CPU_OCI_VERSION 1
#define ALT_CPU_RESET_ADDR 0x00080000


/*
 * CPU configuration (with legacy prefix - don't use these anymore)
 *
 */

#define NIOS2_BIG_ENDIAN 0
#define NIOS2_BREAK_ADDR 0x00100820
#define NIOS2_CPU_ARCH_NIOS2_R1
#define NIOS2_CPU_FREQ 50000000u
#define NIOS2_CPU_ID_SIZE 1
#define NIOS2_CPU_ID_VALUE 0x00000000
#define NIOS2_CPU_IMPLEMENTATION "fast"
#define NIOS2_DATA_ADDR_WIDTH 0x15
#define NIOS2_DCACHE_LINE_SIZE 0
#define NIOS2_DCACHE_LINE_SIZE_LOG2 0
#define NIOS2_DCACHE_SIZE 0
#define NIOS2_EXCEPTION_ADDR 0x00080020
#define NIOS2_FLASH_ACCELERATOR_LINES 0
#define NIOS2_FLASH_ACCELERATOR_LINE_SIZE 0
#define NIOS2_FLUSHDA_SUPPORTED
#define NIOS2_HARDWARE_DIVIDE_PRESENT 0
#define NIOS2_HARDWARE_MULTIPLY_PRESENT 1
#define NIOS2_HARDWARE_MULX_PRESENT 1
#define NIOS2_HAS_DEBUG_CORE 1
#define NIOS2_HAS_DEBUG_STUB
#define NIOS2_HAS_EXTRA_EXCEPTION_INFO
#define NIOS2_HAS_ILLEGAL_INSTRUCTION_EXCEPTION
#define NIOS2_HAS_JMPI_INSTRUCTION
#define NIOS2_ICACHE_LINE_SIZE 32
#define NIOS2_ICACHE_LINE_SIZE_LOG2 5
#define NIOS2_ICACHE_SIZE 8192
#define NIOS2_INST_ADDR_WIDTH 0x15
#define NIOS2_NUM_OF_SHADOW_REG_SETS 0
#define NIOS2_OCI_VERSION 1
#define NIOS2_RESET_ADDR 0x00080000


/*
 * Define for each module class mastered by the CPU
 *
 */

#define __ALTERA_AVALON_JTAG_UART
#define __ALTERA_AVALON_ONCHIP_MEMORY2
#define __ALTERA_AVALON_PIO
#define __ALTERA_AVALON_SYSID_QSYS
#define __ALTERA_AVALON_TIMER
#define __ALTERA_NIOS2_GEN2
#define __I2C_OPENCORES


/*
 * System configuration
 *
 */

#define ALT_DEVICE_FAMILY "Stratix V"
#define ALT_ENHANCED_INTERRUPT_API_PRESENT
#define ALT_IRQ_BASE NULL
#define ALT_LOG_PORT "/dev/null"
#define ALT_LOG_PORT_BASE 0x0
#define ALT_LOG_PORT_DEV null
#define ALT_LOG_PORT_TYPE ""
#define ALT_NUM_EXTERNAL_INTERRUPT_CONTROLLERS 0
#define ALT_NUM_INTERNAL_INTERRUPT_CONTROLLERS 1
#define ALT_NUM_INTERRUPT_CONTROLLERS 1
#define ALT_STDERR "/dev/jtag_uart"
#define ALT_STDERR_BASE 0x1010b8
#define ALT_STDERR_DEV jtag_uart
#define ALT_STDERR_IS_JTAG_UART
#define ALT_STDERR_PRESENT
#define ALT_STDERR_TYPE "altera_avalon_jtag_uart"
#define ALT_STDIN "/dev/jtag_uart"
#define ALT_STDIN_BASE 0x1010b8
#define ALT_STDIN_DEV jtag_uart
#define ALT_STDIN_IS_JTAG_UART
#define ALT_STDIN_PRESENT
#define ALT_STDIN_TYPE "altera_avalon_jtag_uart"
#define ALT_STDOUT "/dev/jtag_uart"
#define ALT_STDOUT_BASE 0x1010b8
#define ALT_STDOUT_DEV jtag_uart
#define ALT_STDOUT_IS_JTAG_UART
#define ALT_STDOUT_PRESENT
#define ALT_STDOUT_TYPE "altera_avalon_jtag_uart"
#define ALT_SYSTEM_NAME "nios"


/*
 * hal configuration
 *
 */

#define ALT_INCLUDE_INSTRUCTION_RELATED_EXCEPTION_API
#define ALT_MAX_FD 32
#define ALT_SYS_CLK SYS_CLK_TIMER
#define ALT_TIMESTAMP_CLK none


/*
 * hdmi_tx_disp_mode configuration
 *
 */

#define ALT_MODULE_CLASS_hdmi_tx_disp_mode altera_avalon_pio
#define HDMI_TX_DISP_MODE_BASE 0x101040
#define HDMI_TX_DISP_MODE_BIT_CLEARING_EDGE_REGISTER 0
#define HDMI_TX_DISP_MODE_BIT_MODIFYING_OUTPUT_REGISTER 0
#define HDMI_TX_DISP_MODE_CAPTURE 0
#define HDMI_TX_DISP_MODE_DATA_WIDTH 4
#define HDMI_TX_DISP_MODE_DO_TEST_BENCH_WIRING 0
#define HDMI_TX_DISP_MODE_DRIVEN_SIM_VALUE 0
#define HDMI_TX_DISP_MODE_EDGE_TYPE "NONE"
#define HDMI_TX_DISP_MODE_FREQ 50000000
#define HDMI_TX_DISP_MODE_HAS_IN 0
#define HDMI_TX_DISP_MODE_HAS_OUT 1
#define HDMI_TX_DISP_MODE_HAS_TRI 0
#define HDMI_TX_DISP_MODE_IRQ -1
#define HDMI_TX_DISP_MODE_IRQ_INTERRUPT_CONTROLLER_ID -1
#define HDMI_TX_DISP_MODE_IRQ_TYPE "NONE"
#define HDMI_TX_DISP_MODE_NAME "/dev/hdmi_tx_disp_mode"
#define HDMI_TX_DISP_MODE_RESET_VALUE 0
#define HDMI_TX_DISP_MODE_SPAN 16
#define HDMI_TX_DISP_MODE_TYPE "altera_avalon_pio"


/*
 * hdmi_tx_mode_change configuration
 *
 */

#define ALT_MODULE_CLASS_hdmi_tx_mode_change altera_avalon_pio
#define HDMI_TX_MODE_CHANGE_BASE 0x101060
#define HDMI_TX_MODE_CHANGE_BIT_CLEARING_EDGE_REGISTER 0
#define HDMI_TX_MODE_CHANGE_BIT_MODIFYING_OUTPUT_REGISTER 0
#define HDMI_TX_MODE_CHANGE_CAPTURE 0
#define HDMI_TX_MODE_CHANGE_DATA_WIDTH 1
#define HDMI_TX_MODE_CHANGE_DO_TEST_BENCH_WIRING 0
#define HDMI_TX_MODE_CHANGE_DRIVEN_SIM_VALUE 0
#define HDMI_TX_MODE_CHANGE_EDGE_TYPE "NONE"
#define HDMI_TX_MODE_CHANGE_FREQ 50000000
#define HDMI_TX_MODE_CHANGE_HAS_IN 0
#define HDMI_TX_MODE_CHANGE_HAS_OUT 1
#define HDMI_TX_MODE_CHANGE_HAS_TRI 0
#define HDMI_TX_MODE_CHANGE_IRQ -1
#define HDMI_TX_MODE_CHANGE_IRQ_INTERRUPT_CONTROLLER_ID -1
#define HDMI_TX_MODE_CHANGE_IRQ_TYPE "NONE"
#define HDMI_TX_MODE_CHANGE_NAME "/dev/hdmi_tx_mode_change"
#define HDMI_TX_MODE_CHANGE_RESET_VALUE 0
#define HDMI_TX_MODE_CHANGE_SPAN 16
#define HDMI_TX_MODE_CHANGE_TYPE "altera_avalon_pio"


/*
 * hdmi_tx_rst_n configuration
 *
 */

#define ALT_MODULE_CLASS_hdmi_tx_rst_n altera_avalon_pio
#define HDMI_TX_RST_N_BASE 0x101080
#define HDMI_TX_RST_N_BIT_CLEARING_EDGE_REGISTER 0
#define HDMI_TX_RST_N_BIT_MODIFYING_OUTPUT_REGISTER 0
#define HDMI_TX_RST_N_CAPTURE 0
#define HDMI_TX_RST_N_DATA_WIDTH 1
#define HDMI_TX_RST_N_DO_TEST_BENCH_WIRING 0
#define HDMI_TX_RST_N_DRIVEN_SIM_VALUE 0
#define HDMI_TX_RST_N_EDGE_TYPE "NONE"
#define HDMI_TX_RST_N_FREQ 50000000
#define HDMI_TX_RST_N_HAS_IN 0
#define HDMI_TX_RST_N_HAS_OUT 1
#define HDMI_TX_RST_N_HAS_TRI 0
#define HDMI_TX_RST_N_IRQ -1
#define HDMI_TX_RST_N_IRQ_INTERRUPT_CONTROLLER_ID -1
#define HDMI_TX_RST_N_IRQ_TYPE "NONE"
#define HDMI_TX_RST_N_NAME "/dev/hdmi_tx_rst_n"
#define HDMI_TX_RST_N_RESET_VALUE 1
#define HDMI_TX_RST_N_SPAN 16
#define HDMI_TX_RST_N_TYPE "altera_avalon_pio"


/*
 * hdmi_tx_vpg_color configuration
 *
 */

#define ALT_MODULE_CLASS_hdmi_tx_vpg_color altera_avalon_pio
#define HDMI_TX_VPG_COLOR_BASE 0x101050
#define HDMI_TX_VPG_COLOR_BIT_CLEARING_EDGE_REGISTER 0
#define HDMI_TX_VPG_COLOR_BIT_MODIFYING_OUTPUT_REGISTER 0
#define HDMI_TX_VPG_COLOR_CAPTURE 0
#define HDMI_TX_VPG_COLOR_DATA_WIDTH 2
#define HDMI_TX_VPG_COLOR_DO_TEST_BENCH_WIRING 0
#define HDMI_TX_VPG_COLOR_DRIVEN_SIM_VALUE 0
#define HDMI_TX_VPG_COLOR_EDGE_TYPE "NONE"
#define HDMI_TX_VPG_COLOR_FREQ 50000000
#define HDMI_TX_VPG_COLOR_HAS_IN 0
#define HDMI_TX_VPG_COLOR_HAS_OUT 1
#define HDMI_TX_VPG_COLOR_HAS_TRI 0
#define HDMI_TX_VPG_COLOR_IRQ -1
#define HDMI_TX_VPG_COLOR_IRQ_INTERRUPT_CONTROLLER_ID -1
#define HDMI_TX_VPG_COLOR_IRQ_TYPE "NONE"
#define HDMI_TX_VPG_COLOR_NAME "/dev/hdmi_tx_vpg_color"
#define HDMI_TX_VPG_COLOR_RESET_VALUE 0
#define HDMI_TX_VPG_COLOR_SPAN 16
#define HDMI_TX_VPG_COLOR_TYPE "altera_avalon_pio"


/*
 * i2c_opencores_0 configuration
 *
 */

#define ALT_MODULE_CLASS_i2c_opencores_0 i2c_opencores
#define I2C_OPENCORES_0_BASE 0x101020
#define I2C_OPENCORES_0_IRQ 15
#define I2C_OPENCORES_0_IRQ_INTERRUPT_CONTROLLER_ID 0
#define I2C_OPENCORES_0_NAME "/dev/i2c_opencores_0"
#define I2C_OPENCORES_0_SPAN 32
#define I2C_OPENCORES_0_TYPE "i2c_opencores"


/*
 * jtag_uart configuration
 *
 */

#define ALT_MODULE_CLASS_jtag_uart altera_avalon_jtag_uart
#define JTAG_UART_BASE 0x1010b8
#define JTAG_UART_IRQ 16
#define JTAG_UART_IRQ_INTERRUPT_CONTROLLER_ID 0
#define JTAG_UART_NAME "/dev/jtag_uart"
#define JTAG_UART_READ_DEPTH 64
#define JTAG_UART_READ_THRESHOLD 8
#define JTAG_UART_SPAN 8
#define JTAG_UART_TYPE "altera_avalon_jtag_uart"
#define JTAG_UART_WRITE_DEPTH 64
#define JTAG_UART_WRITE_THRESHOLD 8


/*
 * led_pio configuration
 *
 */

#define ALT_MODULE_CLASS_led_pio altera_avalon_pio
#define LED_PIO_BASE 0x1010a0
#define LED_PIO_BIT_CLEARING_EDGE_REGISTER 0
#define LED_PIO_BIT_MODIFYING_OUTPUT_REGISTER 0
#define LED_PIO_CAPTURE 0
#define LED_PIO_DATA_WIDTH 8
#define LED_PIO_DO_TEST_BENCH_WIRING 0
#define LED_PIO_DRIVEN_SIM_VALUE 0
#define LED_PIO_EDGE_TYPE "NONE"
#define LED_PIO_FREQ 50000000
#define LED_PIO_HAS_IN 0
#define LED_PIO_HAS_OUT 1
#define LED_PIO_HAS_TRI 0
#define LED_PIO_IRQ -1
#define LED_PIO_IRQ_INTERRUPT_CONTROLLER_ID -1
#define LED_PIO_IRQ_TYPE "NONE"
#define LED_PIO_NAME "/dev/led_pio"
#define LED_PIO_RESET_VALUE 0
#define LED_PIO_SPAN 16
#define LED_PIO_TYPE "altera_avalon_pio"


/*
 * onchip_mem configuration
 *
 */

#define ALT_MODULE_CLASS_onchip_mem altera_avalon_onchip_memory2
#define ONCHIP_MEM_ALLOW_IN_SYSTEM_MEMORY_CONTENT_EDITOR 0
#define ONCHIP_MEM_ALLOW_MRAM_SIM_CONTENTS_ONLY_FILE 0
#define ONCHIP_MEM_BASE 0x80000
#define ONCHIP_MEM_CONTENTS_INFO ""
#define ONCHIP_MEM_DUAL_PORT 0
#define ONCHIP_MEM_GUI_RAM_BLOCK_TYPE "AUTO"
#define ONCHIP_MEM_INIT_CONTENTS_FILE "nios_onchip_mem"
#define ONCHIP_MEM_INIT_MEM_CONTENT 1
#define ONCHIP_MEM_INSTANCE_ID "NONE"
#define ONCHIP_MEM_IRQ -1
#define ONCHIP_MEM_IRQ_INTERRUPT_CONTROLLER_ID -1
#define ONCHIP_MEM_NAME "/dev/onchip_mem"
#define ONCHIP_MEM_NON_DEFAULT_INIT_FILE_ENABLED 0
#define ONCHIP_MEM_RAM_BLOCK_TYPE "AUTO"
#define ONCHIP_MEM_READ_DURING_WRITE_MODE "DONT_CARE"
#define ONCHIP_MEM_SINGLE_CLOCK_OP 0
#define ONCHIP_MEM_SIZE_MULTIPLE 1
#define ONCHIP_MEM_SIZE_VALUE 327360
#define ONCHIP_MEM_SPAN 327360
#define ONCHIP_MEM_TYPE "altera_avalon_onchip_memory2"
#define ONCHIP_MEM_WRITABLE 1


/*
 * pio_i2c_scl configuration
 *
 */

#define ALT_MODULE_CLASS_pio_i2c_scl altera_avalon_pio
#define PIO_I2C_SCL_BASE 0x101090
#define PIO_I2C_SCL_BIT_CLEARING_EDGE_REGISTER 0
#define PIO_I2C_SCL_BIT_MODIFYING_OUTPUT_REGISTER 0
#define PIO_I2C_SCL_CAPTURE 0
#define PIO_I2C_SCL_DATA_WIDTH 1
#define PIO_I2C_SCL_DO_TEST_BENCH_WIRING 0
#define PIO_I2C_SCL_DRIVEN_SIM_VALUE 0
#define PIO_I2C_SCL_EDGE_TYPE "NONE"
#define PIO_I2C_SCL_FREQ 50000000
#define PIO_I2C_SCL_HAS_IN 0
#define PIO_I2C_SCL_HAS_OUT 1
#define PIO_I2C_SCL_HAS_TRI 0
#define PIO_I2C_SCL_IRQ -1
#define PIO_I2C_SCL_IRQ_INTERRUPT_CONTROLLER_ID -1
#define PIO_I2C_SCL_IRQ_TYPE "NONE"
#define PIO_I2C_SCL_NAME "/dev/pio_i2c_scl"
#define PIO_I2C_SCL_RESET_VALUE 0
#define PIO_I2C_SCL_SPAN 16
#define PIO_I2C_SCL_TYPE "altera_avalon_pio"


/*
 * pio_i2c_sda configuration
 *
 */

#define ALT_MODULE_CLASS_pio_i2c_sda altera_avalon_pio
#define PIO_I2C_SDA_BASE 0x101070
#define PIO_I2C_SDA_BIT_CLEARING_EDGE_REGISTER 0
#define PIO_I2C_SDA_BIT_MODIFYING_OUTPUT_REGISTER 0
#define PIO_I2C_SDA_CAPTURE 0
#define PIO_I2C_SDA_DATA_WIDTH 1
#define PIO_I2C_SDA_DO_TEST_BENCH_WIRING 0
#define PIO_I2C_SDA_DRIVEN_SIM_VALUE 0
#define PIO_I2C_SDA_EDGE_TYPE "NONE"
#define PIO_I2C_SDA_FREQ 50000000
#define PIO_I2C_SDA_HAS_IN 0
#define PIO_I2C_SDA_HAS_OUT 0
#define PIO_I2C_SDA_HAS_TRI 1
#define PIO_I2C_SDA_IRQ -1
#define PIO_I2C_SDA_IRQ_INTERRUPT_CONTROLLER_ID -1
#define PIO_I2C_SDA_IRQ_TYPE "NONE"
#define PIO_I2C_SDA_NAME "/dev/pio_i2c_sda"
#define PIO_I2C_SDA_RESET_VALUE 0
#define PIO_I2C_SDA_SPAN 16
#define PIO_I2C_SDA_TYPE "altera_avalon_pio"


/*
 * sys_clk_timer configuration
 *
 */

#define ALT_MODULE_CLASS_sys_clk_timer altera_avalon_timer
#define SYS_CLK_TIMER_ALWAYS_RUN 0
#define SYS_CLK_TIMER_BASE 0x101000
#define SYS_CLK_TIMER_COUNTER_SIZE 32
#define SYS_CLK_TIMER_FIXED_PERIOD 0
#define SYS_CLK_TIMER_FREQ 50000000
#define SYS_CLK_TIMER_IRQ 1
#define SYS_CLK_TIMER_IRQ_INTERRUPT_CONTROLLER_ID 0
#define SYS_CLK_TIMER_LOAD_VALUE 49999
#define SYS_CLK_TIMER_MULT 0.001
#define SYS_CLK_TIMER_NAME "/dev/sys_clk_timer"
#define SYS_CLK_TIMER_PERIOD 1
#define SYS_CLK_TIMER_PERIOD_UNITS "ms"
#define SYS_CLK_TIMER_RESET_OUTPUT 0
#define SYS_CLK_TIMER_SNAPSHOT 1
#define SYS_CLK_TIMER_SPAN 32
#define SYS_CLK_TIMER_TICKS_PER_SEC 1000
#define SYS_CLK_TIMER_TIMEOUT_PULSE_OUTPUT 0
#define SYS_CLK_TIMER_TYPE "altera_avalon_timer"


/*
 * sysid configuration
 *
 */

#define ALT_MODULE_CLASS_sysid altera_avalon_sysid_qsys
#define SYSID_BASE 0x1010b0
#define SYSID_ID 0
#define SYSID_IRQ -1
#define SYSID_IRQ_INTERRUPT_CONTROLLER_ID -1
#define SYSID_NAME "/dev/sysid"
#define SYSID_SPAN 8
#define SYSID_TIMESTAMP 1518418665
#define SYSID_TYPE "altera_avalon_sysid_qsys"

#endif /* __SYSTEM_H_ */
