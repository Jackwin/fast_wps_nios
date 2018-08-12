derive_pll_clocks
derive_clock_uncertainty

create_clock -name {altera_reserved_tck} -period 41.667 [get_ports { altera_reserved_tck }]
set_input_delay -clock altera_reserved_tck -clock_fall -max 5 [get_ports altera_reserved_tdi]
set_input_delay -clock altera_reserved_tck -clock_fall -max 5 [get_ports altera_reserved_tms]
set_output_delay -clock altera_reserved_tck 5 [get_ports altera_reserved_tdo]

#create_clock -name clk_50m -period 20.00 [get_ports clkin_50]
create_clock -period "125 MHz" -name {clkinbot_p[0]} {*clkinbot_p[0]*}
create_clock -period "125 MHz" -name {hsma_clk_out_p2} {*hsma_clk_out_p2*}

#set_clock_groups -asynchronous \
#-group {altera_reserved_tck} \
#-group {clk_50m}


#create_clock -name clk_148_5 [get_clocks {fast_wps_nios_top_i|vpg_inst|pll_vpg_i|pll_vpg_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}]
#create_clock -name ddr3_clk [get_clocks {pcie_dma_gen3x8_i|u0|mem_if_ddr3_emif_0|pll0|pll1~PLL_OUTPUT_COUNTER|divclk}]
create_clock -period "100 MHz" -name {clkintop_p[0]} {clkintop_p[0]}
#set_false_path -from [get_clocks {fast_wps_nios_top_i|vpg_inst|pll_vpg_i|pll_vpg_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}] to [get_clocks {pcie_dma_gen3x8_i|u0|mem_if_ddr3_emif_0|pll0|pll1~PLL_OUTPUT_COUNTER|divclk}]
set_false_path -from [get_clocks {clkin_50}] -to [get_clocks {fast_wps_nios_top_i|vpg_inst|pll_vpg_i|pll_vpg_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}]
set_false_path -from [get_clocks {pcie_dma_gen3x8_i|u0|mem_if_ddr3_emif_0|pll0|pll1~PLL_OUTPUT_COUNTER|divclk}] -to [get_clocks {fast_wps_nios_top_i|vpg_inst|pll_vpg_i|pll_vpg_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}]
set_false_path -from [get_clocks {fast_wps_nios_top_i|vpg_inst|pll_vpg_i|pll_vpg_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}] -to [get_clocks {pcie_dma_gen3x8_i|u0|mem_if_ddr3_emif_0|pll0|pll1~PLL_OUTPUT_COUNTER|divclk}]

create_clock -period 4.000 [get_pins {pcie_dma_gen3x8_i|u0|mem_if_ddr3_emif_0|pll0|pll1~PLL_OUTPUT_COUNTER|divclk}]

set_false_path -from [get_clocks {pcie_dma_gen3x8_i|u0|pcie_256_dma|altera_s5_a2p|altpcie_hip_256_pipen1b|stratixv_hssi_gen3_pcie_hip|coreclkout}] -to [get_clocks {clkinbot_p[0]}]

set_false_path -from [get_clocks {pcie_dma_gen3x8_i|u0|pcie_256_dma|altera_s5_a2p|altpcie_hip_256_pipen1b|stratixv_hssi_gen3_pcie_hip|coreclkout}] -to [get_clocks {pcie_dma_gen3x8_i|u0|mem_if_ddr3_emif_0|pll0|pll1~PLL_OUTPUT_COUNTER|divclk}]
set_false_path -from [get_clocks {clkinbot_p[0]}] -to [get_clocks {pcie_dma_gen3x8_i|u0|pcie_256_dma|altera_s5_a2p|altpcie_hip_256_pipen1b|stratixv_hssi_gen3_pcie_hip|coreclkout}]
set_false_path -from [get_clocks {pcie_dma_gen3x8_i|u0|pcie_256_dma|altera_s5_a2p|altpcie_hip_256_pipen1b|stratixv_hssi_gen3_pcie_hip|coreclkout}] -to [get_clocks {pcie_dma_gen3x8_i|u0|mem_if_ddr3_emif_0|pll0|pll7~PLL_OUTPUT_COUNTER|divclk}]
set_false_path -from [get_clocks {pcie_dma_gen3x8_i|u0|pcie_256_dma|altera_s5_a2p|altpcie_hip_256_pipen1b|stratixv_hssi_gen3_pcie_hip|coreclkout}] -to [get_clocks {pcie_dma_gen3x8_i|u0|mem_if_ddr3_emif_0|pll0|pll6~PLL_OUTPUT_COUNTER|divclk}]
