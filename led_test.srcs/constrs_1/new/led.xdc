############## clock define##################
create_clock -period 5.000 [get_ports sys_clk_p] # 定义一个周期为5ns（相当于200MHz频率）的时钟，通过 sys_clk_p 端口输入。这与 Verilog 代码中用于系统时钟的差分输入端口 sys_clk_p 相对应。
set_property PACKAGE_PIN AE10 [get_ports sys_clk_p] # 指定 sys_clk_p 端口映射到 FPGA 的物理引脚 AE10。
set_property IOSTANDARD DIFF_SSTL15 [get_ports sys_clk_p] # 为 sys_clk_p 端口设置差分SSTL-1.5V I/O 标准。

############## key define##################
set_property PACKAGE_PIN AD24 [get_ports rst_n] # 将复位信号 rst_n 映射到 FPGA 的物理引脚 AD24。
set_property IOSTANDARD LVCMOS33 [get_ports rst_n] # 为 rst_n 端口设置3.3V CMOS I/O 标准。
#################fan define##################
set_property IOSTANDARD LVCMOS33 [get_ports fan_pwm] # 为 fan_pwm 端口设置3.3V CMOS I/O 标准。
set_property PACKAGE_PIN AB30 [get_ports fan_pwm] # 将风扇控制信号 fan_pwm 映射到 FPGA 的物理引脚 AB30。
##############LED define##################
set_property PACKAGE_PIN Y28 [get_ports {led[0]}] # 分别将它们映射到 FPGA 的物理引脚（Y28 和 AA28）
set_property IOSTANDARD LVCMOS33 [get_ports {led[0]}] # 设置为3.3V CMOS I/O 标准。

set_property PACKAGE_PIN AA28 [get_ports {led[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[1]}]

#############SPI Configurate Setting##################
set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 4 [current_design]
set_property CONFIG_MODE SPIx4 [current_design]
set_property BITSTREAM.CONFIG.CONFIGRATE 50 [current_design]
set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]
set_property BITSTREAM.CONFIG.UNUSEDPIN Pullup [current_design]
set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]



