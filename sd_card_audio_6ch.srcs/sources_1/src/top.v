//////////////////////////////////////////////////////////////////////////////////
//                                                                              //
//                                                                              //
//  Author: meisq                                                               //
//          msq@qq.com                                                          //
//          ALINX(shanghai) Technology Co.,Ltd                                  //
//          heijin                                                              //
//     WEB: http://www.alinx.cn/                                                //
//     BBS: http://www.heijin.org/                                              //
//                                                                              //
//////////////////////////////////////////////////////////////////////////////////
//                                                                              //
// Copyright (c) 2017,ALINX(shanghai) Technology Co.,Ltd                        //
//                    All rights reserved                                       //
//                                                                              //
// This source file may be used and distributed without restriction provided    //
// that this copyright statement is not removed from the file and that any      //
// derivative work contains the original copyright notice and the associated    //
// disclaimer.                                                                  //
//                                                                              //
//////////////////////////////////////////////////////////////////////////////////
  
//==========================================================================
//  Revision History:
//  Date          By            Revision    Change Description
//--------------------------------------------------------------------------
//  2017/7/24    meisq         1.0         Original
//  2019/11/11   meisq         1.1         av7k325
//*************************************************************************/
`timescale 1ps/1ps
module top
(
	input                              rst_n,	           //reset input
	input                              key,                    //record play button
	output[1:0]                        led,
	output                             fan_pwm,                // fan control
	
	output                             dacdat1,
	output                             dacdat2, 
	output                             dacdat3, 
	output                             dacdat4, 
	output                             dacdat5, 
	output                             dacdat6,           	   //DAC audio data output 
	
	output                             sd_ncs,                 //SD card chip select (SPI mode)
	output                             sd_dclk,                //SD card clock
	output                             sd_mosi,                //SD card controller data output
	input                              sd_miso,                //SD card controller data input	
	
	
	output reg 			   ccclk,
	output reg 			   lrc,
	input                              sys_clk_p,
	input                              sys_clk_n
);

wire                            sys_clk;
wire                            clk_50m;
wire                            clk_16m;
wire[1:0]                       state_code;

// timer for clk division (bclk and lrc)
reg[31:0]			timer =32'd0;
reg[31:0]			lrc_timer = 32'd0;

assign led = state_code[1:0];
assign fan_pwm = 1'b0;     

//create sys_clk            
IBUFDS sys_clk_ibufgds
(
	.O  (sys_clk),
	.I  (sys_clk_p),
	.IB (sys_clk_n)
);

//create 50M clk 
sys_pll sys_pll_m0
 (
	.clk_in1                    (sys_clk                  ),
	.clk_out1                   (clk_50m                  ),
	.clk_out2                   (clk_16m                  ), 
	.reset                      (1'b0                     ),
	.locked                     (                         )
 );
 

//create bclk of i2s
always @(posedge clk_50m or negedge rst_n) 
begin
    if (~rst_n) 
    begin
        // Reset counter and output clock
        timer <= 0;
        ccclk <= 0;
    end 
    
    else if (timer == 34) 
    begin
            // Toggle cclk and reset counter
            ccclk <= ~ccclk;
            timer <= 0;
    end 
    
    else 
    timer <= timer + 1;
     
end

//create lrc of i2s
always @(negedge ccclk or negedge rst_n) 

begin
    if (~rst_n) 
    begin
        // Reset counter and output clock
        lrc_timer <= 0;
        lrc <= 0;
    end 
    
    else if (lrc_timer == 15) 
    begin
            // Toggle cclk and reset counter
            lrc <= ~lrc;
            lrc_timer <= 0;
    end 
    
    else 
    lrc_timer <= lrc_timer + 1;
     
end


//with a led display of state_code
// 0(4'b0000):SD card is initializing
// 1(4'b0001):wait for the button to press
// 2(4'b0010):looking for the WAV file
// 3(4'b0011):playing

sd_card_audio  sd_card_audio_m0(
	.clk                        (clk_50m                  ),
	.rst_n                      (rst_n                    ),
	.key1                       (key                     ),
	.state_code                 (state_code               ),
	
	.bclk                       (ccclk              ),
	.dacdat1                    (dacdat1            ),
	.dacdat2                    (dacdat2            ),
	.dacdat3                    (dacdat3            ),
	.dacdat4                    (dacdat4            ),
	.dacdat5                    (dacdat5            ),
	.dacdat6                    (dacdat6            ),
	.adclrc                     (lrc            ),
	
	.sd_ncs                     (sd_ncs                   ),
	.sd_dclk                    (sd_dclk                  ),
	.sd_mosi                    (sd_mosi                  ),
	.sd_miso                    (sd_miso                  )
);

endmodule
