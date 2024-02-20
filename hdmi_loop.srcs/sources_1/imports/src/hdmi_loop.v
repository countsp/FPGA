`timescale 1ns/1ps
`define	VIDEO_1920_1080 1
//`define	VIDEO_3840_2160 1
module hdmi_loop
(
	input                              sys_clk_p,
	input                              sys_clk_n,
	output[1:0]                        led,
	input[0:0]                         key,
	inout                              hdmi1_scl,
	inout                              hdmi1_sda,
	inout                              hdmi1_edid_scl,
	inout                              hdmi1_edid_sda,
	inout                              hdmi2_scl,
	inout                              hdmi2_sda,
	inout                              hdmi2_edid_scl,
	inout                              hdmi2_edid_sda,	
	output                             hdmi1_nreset,
	output                             hdmi2_nreset,
	input                              vin1_clk,
	input                              vin1_hs,
	input                              vin1_vs,
	input                              vin1_de,
	input[47:0]                        vin1_data,
	output                             vout1_clk,
	output                             vout1_hs,
	output                             vout1_vs,
	output                             vout1_de,
	output[35:0]                       vout1_data,
	input                              vin2_clk,
	input                              vin2_hs,
	input                              vin2_vs,
	input                              vin2_de,
	input[47:0]                        vin2_data,
	output                             vout2_clk,
	output                             vout2_hs,
	output                             vout2_vs,
	output                             vout2_de,
	output[35:0]                       vout2_data
);

wire power_on_rst;
wire power_on_rst1;
wire locked;

reg vin1_hs_d0;
reg vin1_vs_d0;
reg vin1_de_d0;
reg[47:0] vin1_data_d0;
reg vin1_hs_d1;
reg vin1_vs_d1;
reg vin1_de_d1;
reg[47:0] vin1_data_d1;
reg vin1_hs_d2;
reg vin1_vs_d2;
reg vin1_de_d2;
reg[47:0] vin1_data_d2;

reg vin2_hs_d0;
reg vin2_vs_d0;
reg vin2_de_d0;
reg[47:0] vin2_data_d0;
reg vin2_hs_d1;
reg vin2_vs_d1;
reg vin2_de_d1;
reg[47:0] vin2_data_d1;
reg vin2_hs_d2;
reg vin2_vs_d2;
reg vin2_de_d2;
reg[47:0] vin2_data_d2;

wire edid1_scl_i;
wire edid1_scl_o;
wire edid1_scl_t;
wire edid1_sda_i;
wire edid1_sda_o;
wire edid1_sda_t;

wire edid2_scl_i;
wire edid2_scl_o;
wire edid2_scl_t;
wire edid2_sda_i;
wire edid2_sda_o;
wire edid2_sda_t;

wire cfg_done;
wire cfg_error;

assign vout1_clk = vin1_clk;
assign vout1_hs = vin1_hs_d2;
assign vout1_vs = vin1_vs_d2;
assign vout1_de = vin1_de_d2;
//
 

assign vout2_clk = vin2_clk;
assign vout2_hs = vin2_hs_d2;
assign vout2_vs = vin2_vs_d2;
assign vout2_de = vin2_de_d2;


`ifdef  VIDEO_1920_1080
assign vout1_data = {vin1_data_d2[35:28],4'd0,vin1_data_d2[23:16],4'd0,vin1_data_d2[11:4],4'd0};//24-Bit SDR
assign vout2_data = {vin2_data_d2[35:28],4'd0,vin2_data_d2[23:16],4'd0,vin2_data_d2[11:4],4'd0};//24-Bit SDR
parameter EDID_NAME = "1080_edid.txt"; 
`elsif VIDEO_3840_2160
assign vout1_data = {vin1_data_d2[7:0],4'd0,vin1_data_d2[23:16],4'd0,vin1_data_d2[15:8],4'd0}; //24-Bit SDRx2 p1
assign vout2_data = {vin2_data_d2[7:0],4'd0,vin2_data_d2[23:16],4'd0,vin2_data_d2[15:8],4'd0}; //24-Bit SDRx2 p1
parameter EDID_NAME = "4k_edid.txt"; 
`endif
//


assign hdmi1_nreset = ~power_on_rst;
assign hdmi2_nreset = ~power_on_rst;
assign led[0] = cfg_done;
assign led[1] = cfg_error;
assign hdmi1_edid_scl = ~edid1_scl_t == 1'b1 ? edid1_scl_o : 1'bz;
assign edid1_scl_i = hdmi1_edid_scl;
assign hdmi1_edid_sda = ~edid1_sda_t == 1'b1 ? edid1_sda_o : 1'bz;
assign edid1_sda_i = hdmi1_edid_sda;

assign hdmi2_edid_scl = ~edid2_scl_t == 1'b1 ? edid2_scl_o : 1'bz;
assign edid2_scl_i = hdmi2_edid_scl;
assign hdmi2_edid_sda = ~edid2_sda_t == 1'b1 ? edid2_sda_o : 1'bz;
assign edid2_sda_i = hdmi2_edid_sda;
wire clk100m;

sys_pll sys_pll_m0
(
	.clk_out1(clk100m     ),
	// Clock in ports
	.clk_in1_p(sys_clk_p),
	.clk_in1_n(sys_clk_n)
 );
reset_power_on#
(
	.FREQ(100),
	.MAX_TIME(200),
	.POLARITY(1)
)
reset_power_on_m0(            
	.clk                        (clk100m                  ),               
	.user_rst                   (~key[0]                  ),//user reset high active
	.power_on_rst               (power_on_rst             ) //power on resethigh active     
);

reset_power_on#
(
	.FREQ(100),
	.MAX_TIME(1000),
	.POLARITY(1)
)
reset_power_on_m1(            
	.clk                        (clk100m                  ),               
	.user_rst                   (~key[0]                  ),//user reset high active
	.power_on_rst               (power_on_rst1            ) //power on resethigh active     
);

wire[9:0]                       lut1_index;
wire[31:0]                      lut1_data;
//I2C master controller
i2c_config#(.CLOCK_FREQ(100000000)) i2c_config_m0(
	.rst                        (power_on_rst1            ),
	.clk                        (clk100m                  ),
	.clk_div_cnt                (16'd199                  ),
	.i2c_addr_2byte             (1'b0                     ),
	.lut_index                  (lut1_index               ),
	.lut_dev_addr               (lut1_data[31:24]         ),
	.lut_reg_addr               (lut1_data[23:8]          ),
	.lut_reg_data               (lut1_data[7:0]           ),
	.error                      (cfg_error                ),
	.done                       (cfg_done                 ),
	.i2c_scl                    (hdmi1_scl                ),
	.i2c_sda                    (hdmi1_sda                )
);
//configure look-up table
`ifdef  VIDEO_1920_1080
lut_adv7619 
`elsif VIDEO_3840_2160
lut_adv7619_4k
`endif lut_m0(
	.lut_index                  (lut1_index               ),
	.lut_data                   (lut1_data                )
);

wire[9:0]                       lut2_index;
wire[31:0]                      lut2_data;
//I2C master controller
i2c_config#(.CLOCK_FREQ(100000000)) i2c_config_m1(
	.rst                        (power_on_rst1            ),
	.clk                        (clk100m                  ),
	.clk_div_cnt                (16'd199                  ),
	.i2c_addr_2byte             (1'b0                     ),
	.lut_index                  (lut2_index               ),
	.lut_dev_addr               (lut2_data[31:24]         ),
	.lut_reg_addr               (lut2_data[23:8]          ),
	.lut_reg_data               (lut2_data[7:0]           ),
	.error                      (                         ),
	.done                       (                         ),
	.i2c_scl                    (hdmi2_scl                ),
	.i2c_sda                    (hdmi2_sda                )
);
//configure look-up table
`ifdef  VIDEO_1920_1080
lut_adv7619 
`elsif VIDEO_3840_2160
lut_adv7619_4k
`endif

lut_m1(
	.lut_index                  (lut2_index               ),
	.lut_data                   (lut2_data                )
);

EEPROM_8b#
(
	.kSampleClkFreqInMHz(100),
	.kInitFileName(EDID_NAME)
)

EEPROM_8b_m0(
      .SampleClk               (clk100m                  ),
      .sRst                    (power_on_rst             ),
      .aSDA_I                  (edid1_sda_i              ),
      .aSDA_O                  (edid1_sda_o              ),
      .aSDA_T                  (edid1_sda_t              ),
      .aSCL_I                  (edid1_scl_i              ),
      .aSCL_O                  (edid1_scl_o              ),
      .aSCL_T                  (edid1_scl_t              )
);

EEPROM_8b#
(
	.kSampleClkFreqInMHz(100),
	.kInitFileName(EDID_NAME)
)

EEPROM_8b_m1(
      .SampleClk               (clk100m                  ),
      .sRst                    (power_on_rst             ),
      .aSDA_I                  (edid2_sda_i              ),
      .aSDA_O                  (edid2_sda_o              ),
      .aSDA_T                  (edid2_sda_t              ),
      .aSCL_I                  (edid2_scl_i              ),
      .aSCL_O                  (edid2_scl_o              ),
      .aSCL_T                  (edid2_scl_t              )
);

always@(posedge vin1_clk)
begin
    vin1_hs_d0 <= vin1_hs;
    vin1_vs_d0 <= vin1_vs;
    vin1_de_d0 <= vin1_de;
    vin1_data_d0 <= vin1_data;
    vin1_hs_d1 <= vin1_hs_d0;
    vin1_vs_d1 <= vin1_vs_d0;
    vin1_de_d1 <= vin1_de_d0;
    vin1_data_d1 <= vin1_data_d0; 
    vin1_hs_d2 <= vin1_hs_d1;
    vin1_vs_d2 <= vin1_vs_d1;
    vin1_de_d2 <= vin1_de_d1;
    vin1_data_d2 <= vin1_data_d1;   
end


always@(posedge vin2_clk)
begin
    vin2_hs_d0 <= vin2_hs;
    vin2_vs_d0 <= vin2_vs;
    vin2_de_d0 <= vin2_de;
    vin2_data_d0 <= vin2_data;
    vin2_hs_d1 <= vin2_hs_d0;
    vin2_vs_d1 <= vin2_vs_d0;
    vin2_de_d1 <= vin2_de_d0;
    vin2_data_d1 <= vin2_data_d0; 
    vin2_hs_d2 <= vin2_hs_d1;
    vin2_vs_d2 <= vin2_vs_d1;
    vin2_de_d2 <= vin2_de_d1;
    vin2_data_d2 <= vin2_data_d1;   
end

endmodule 