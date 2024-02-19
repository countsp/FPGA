//////////////////////////////////////////////////////////////////////////////////
//  key test                                                                    //
//                                                                              //
//  Author: lhj                                                                 //
//                                                                              //
//          ALINX(shanghai) Technology Co.,Ltd                                  //
//          heijin                                                              //
//     WEB: http://www.alinx.com                                                //
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
                        
//================================================================================
//  Revision History:
//  Date          By            Revision    Change Description
//--------------------------------------------------------------------------------
//  2017/7/19    lhj         1.0         Original
//  2019/7/19    meisq       1.1         format
//*******************************************************************************/
                        
 `timescale 1ns / 1ps
module key_test
(
	input                 sys_clk_p,   // Differentia system clock 200Mhz input on board
	input                 sys_clk_n,
	input [1:0]           key_in,      //input four key signal,when the keydown,the value is 0
	output[1:0]           led          //LED display ,when the siganl high,LED lighten
);                        
 reg[1:0]                 led_r;       //define the first stage register , generate four D Flip-flop 
 reg[1:0]                 led_r1;      //define the second stage register ,generate four D Flip-flop
 //===========================================================================
 //Differentia system clock to single end clock
 //===========================================================================
 wire        sys_clk;
// IBUFDS: Differential Input Buffer
//         Kintex-7
// Xilinx HDL Language Template, version 2017.4
   
IBUFDS #(
	.DIFF_TERM("TRUE"),      // Differential Termination
	.IBUF_LOW_PWR("TRUE"),   // Low power="TRUE", Highest performance="FALSE" 
	.IOSTANDARD("DEFAULT")   // Specify the input I/O standard
) u_ibuf_sys_clk (
	.O(sys_clk),             // Buffer output
	.I(sys_clk_p),           // Diff_p buffer input (connect directly to top-level port)
	.IB(sys_clk_n)           // Diff_n buffer input (connect directly to top-level port)
);     
always@(posedge sys_clk)
begin
	led_r <= ~key_in;        //first stage latched data
end
                        
always@(posedge sys_clk)
begin
	led_r1 <= led_r;        //second stage latched data
end
                        
assign led = led_r1;
endmodule 
