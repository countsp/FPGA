#############SPI Configurate Setting##################
set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 4 [current_design]
set_property CONFIG_MODE SPIx4 [current_design]
set_property BITSTREAM.CONFIG.CONFIGRATE 50 [current_design]

set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]
set_property BITSTREAM.CONFIG.UNUSEDPIN Pullup [current_design]
set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]
############# clock define################################
create_clock -period 5.000 [get_ports sys_clk_p]
set_property PACKAGE_PIN AE10 [get_ports sys_clk_p]
set_property IOSTANDARD DIFF_SSTL15 [get_ports sys_clk_p]
############## key define##################
set_property PACKAGE_PIN AD24 [get_ports rst_n]
set_property IOSTANDARD LVCMOS33 [get_ports rst_n]

set_property PACKAGE_PIN AC24 [get_ports key]
set_property IOSTANDARD LVCMOS33 [get_ports key]
############## fan define##################
set_property IOSTANDARD LVCMOS33 [get_ports fan_pwm]
set_property PACKAGE_PIN AB30 [get_ports fan_pwm]
##############LED define##################
##############LED define##################
set_property PACKAGE_PIN Y28 [get_ports {led[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[0]}]

set_property PACKAGE_PIN AA28 [get_ports {led[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[1]}]

############## SD card define##################
set_property IOSTANDARD LVCMOS33 [get_ports sd_dclk]
set_property PACKAGE_PIN AA25 [get_ports sd_dclk]

set_property IOSTANDARD LVCMOS33 [get_ports sd_ncs]
set_property PACKAGE_PIN AB25 [get_ports sd_ncs]

set_property IOSTANDARD LVCMOS33 [get_ports sd_mosi]
set_property PACKAGE_PIN AB28 [get_ports sd_mosi]

set_property IOSTANDARD LVCMOS33 [get_ports sd_miso]
set_property PACKAGE_PIN AB29 [get_ports sd_miso]
###AN831 ###########################################
set_property IOSTANDARD LVCMOS33 [get_ports {wm8731_scl}]
set_property IOSTANDARD LVCMOS33 [get_ports {wm8731_sda}]
set_property IOSTANDARD LVCMOS33 [get_ports {wm8731_dacdat}]
set_property IOSTANDARD LVCMOS33 [get_ports {wm8731_bclk}]
set_property IOSTANDARD LVCMOS33 [get_ports {wm8731_adcdat}]
set_property IOSTANDARD LVCMOS33 [get_ports {wm8731_daclrc}]
set_property IOSTANDARD LVCMOS33 [get_ports {wm8731_adclrc}]

set_property PACKAGE_PIN AE23 [get_ports {wm8731_scl}]
set_property PACKAGE_PIN AF23 [get_ports {wm8731_sda}]
set_property PACKAGE_PIN AF20 [get_ports {wm8731_dacdat}]
set_property PACKAGE_PIN AF21 [get_ports {wm8731_bclk}]
set_property PACKAGE_PIN AG22 [get_ports {wm8731_adcdat}]
set_property PACKAGE_PIN AH22 [get_ports {wm8731_daclrc}]
set_property PACKAGE_PIN AG24 [get_ports {wm8731_adclrc}]