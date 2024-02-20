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

//================================================================================
//  Revision History:
//  Date          By            Revision    Change Description
//--------------------------------------------------------------------------------
//  2017/8/9     meisq          1.0         Original
//  2019/11/15   meisq          1.1         add HPA ctrl
//*******************************************************************************/

module lut_adv7619(
	input[9:0]             lut_index, // Look-up table index address
	output reg[31:0]       lut_data   // I2C device address register address register data
);

always@(*)
begin
	case(lut_index)
		10'd0     :lut_data <= {8'h98,16'hF4,8'h80};  //CEC
		10'd1     :lut_data <= {8'h98,16'hF4,8'h80};  //CEC
		10'd2     :lut_data <= {8'h98,16'hF5,8'h7C};  //INFOFRAME
		10'd3     :lut_data <= {8'h98,16'hF8,8'h4C};  //DPLL
		10'd4     :lut_data <= {8'h98,16'hF9,8'h64};  //KSV
		10'd5     :lut_data <= {8'h98,16'hFA,8'h6C};  //EDID
		10'd6     :lut_data <= {8'h98,16'hFB,8'h68};  //HDMI
		10'd7     :lut_data <= {8'h98,16'hFD,8'h44};  //CP
		10'd8     :lut_data <= {8'h68,16'hC0,8'h03};  //ADI Recommended Write
		10'd9     :lut_data <= {8'h98,16'h01,8'h06};  //Prim_Mode =110b HDMI-GR
		10'd10    :lut_data <= {8'h98,16'h02,8'hF2};  //Auto CSC, RGB out, Set op_656 bit
		10'd11    :lut_data <= {8'h98,16'h03,8'h40};  //0x54 - 2 x 24-bit SDR 4:4:4 interleaved mode 0 0x40 - 24-bit 4:4:4 SDR mode 0x54 2 ¡Á SDR 4:4:4 Interleaved
		10'd12    :lut_data <= {8'h98,16'h05,8'h28};  //AV Codes Off
		10'd13    :lut_data <= {8'h98,16'h06,8'hA0};  //No inversion on VS,HS pins
		10'd14    :lut_data <= {8'h98,16'h0C,8'h42};  //Power up part
		10'd15    :lut_data <= {8'h98,16'h15,8'h90};  //Disable Tristate of Pins
		10'd16    :lut_data <= {8'h98,16'h19,8'h83};  //LLC DLL phase
		10'd17    :lut_data <= {8'h98,16'h33,8'h40};  //LLC DLL MUX enable
		10'd18    :lut_data <= {8'h68,16'h9B,8'h03};  //ADI recommended setting
		10'd19    :lut_data <= {8'h4C,16'hB5,8'h01};  //Setting MCLK to 256Fs
		10'd20    :lut_data <= {8'h68,16'h93,8'h03};  //ADI recommended setting
		10'd21    :lut_data <= {8'h68,16'h5A,8'h80};  //ADI recommended setting
		10'd22    :lut_data <= {8'h68,16'hC0,8'h03};  //ADI Required write
		10'd23    :lut_data <= {8'h68,16'h00,8'h00};  //Set HDMI Input Port A (BG_MEAS_PORT_SEL = 001b)
		10'd24    :lut_data <= {8'h68,16'h02,8'h03};  //ALL BG Ports enabled
		10'd25    :lut_data <= {8'h68,16'h03,8'h98};  //ADI Required Write
		10'd26    :lut_data <= {8'h68,16'h10,8'hA5};  //ADI Required Write
		10'd27    :lut_data <= {8'h68,16'h45,8'h04};  //ADI Required Write
		10'd28    :lut_data <= {8'h68,16'h97,8'hC0};  //ADI Required Write
		10'd29    :lut_data <= {8'h68,16'h3D,8'h10};  //ADI Required Write
		10'd30    :lut_data <= {8'h68,16'h3E,8'h69};  //ADI reccommended writes
		10'd31    :lut_data <= {8'h68,16'h3F,8'h46};  //ADI reccommended writes
		10'd32    :lut_data <= {8'h68,16'h4E,8'hFE};  //ADI reccommended writes
		10'd33    :lut_data <= {8'h68,16'h4F,8'h08};  //ADI reccommended writes
		10'd34    :lut_data <= {8'h68,16'h50,8'h00};  //ADI Recommended Write
		10'd35    :lut_data <= {8'h68,16'h57,8'hA3};  //ADI reccommended writes
		10'd36    :lut_data <= {8'h68,16'h58,8'h07};  //ADI reccommended writes
		10'd37    :lut_data <= {8'h68,16'h83,8'hFC};  //Enable clock terminators for port A & B
		10'd38    :lut_data <= {8'h68,16'h84,8'h03};  //FP MODE
		10'd39    :lut_data <= {8'h68,16'h85,8'h10};  //ADI recommended setting
		10'd40    :lut_data <= {8'h68,16'h86,8'h9B};  //ADI recommended setting
		10'd41    :lut_data <= {8'h68,16'h89,8'h03};  //HF Gain
		10'd42    :lut_data <= {8'h68,16'h6C,8'hA3};  //HPA takes its value from HPA_MAN_VALUE_X
		10'd43    :lut_data <= {8'h68,16'h83,8'hFF};
		10'd44    :lut_data <= {8'h98,16'h20,8'h30};
		10'd45    :lut_data <= {8'hfe, 16'd1500, 8'h00};//delay 1500ms
		10'd46    :lut_data <= {8'h68,16'h83,8'hFC};
		10'd47    :lut_data <= {8'h98,16'h20,8'hF0};
		10'd48    :lut_data <= {8'h72,16'hC7,8'h00}; //sil9136 begin
		10'd49    :lut_data <= {8'h72,16'h08,8'h60};
		10'd50    :lut_data <= {8'h72,16'h09,8'h00};
		10'd51    :lut_data <= {8'h72,16'h0A,8'h00};
		10'd52    :lut_data <= {8'h72,16'h1E,8'h00};
		10'd53    :lut_data <= {8'h72,16'h1A,8'h01};
		default:lut_data <= {8'hff,16'hffff,8'hff};
	endcase
end


endmodule 



module lut_adv7619_4k(
	input[9:0]             lut_index, // Look-up table index address
	output reg[31:0]       lut_data   // I2C device address register address register data
);

always@(*)
begin
	case(lut_index)
		10'd0     :lut_data <=	{8'h98, 16'hF4,8'h80}; //CEC
		10'd1     :lut_data <=	{8'h98, 16'hF5,8'h7C}; //INFOFRAME
		10'd2     :lut_data <=	{8'h98, 16'hF8,8'h4C}; //DPLL
		10'd3     :lut_data <=	{8'h98, 16'hF9,8'h64}; //KSV
		10'd4     :lut_data <=	{8'h98, 16'hFA,8'h6C}; //EDID
		10'd5     :lut_data <=	{8'h98, 16'hFB,8'h68}; //HDMI
		10'd6     :lut_data <=	{8'h98, 16'hFD,8'h44}; //CP
		10'd7     :lut_data <=	{8'h68, 16'hC0,8'h03}; //ADI Required Write
		10'd8     :lut_data <=	{8'h98, 16'h00,8'h19}; //Set VID_STD
		10'd9     :lut_data <=	{8'h98, 16'h01,8'h05}; //Prim_Mode =101b HDMI-Comp
		10'd10    :lut_data <=	{8'h98, 16'h02,8'hF2}; //Auto CSC, RGB out, Set op_656 bit
		10'd11    :lut_data <=	{8'h98, 16'h03,8'h54}; //2x24 bit SDR 444 interleaved mode 0
		10'd12    :lut_data <=	{8'h98, 16'h05,8'h28}; //AV Codes Off
		10'd13    :lut_data <=	{8'h98, 16'h06,8'hA0}; //No inversion on VS,HS pins
		10'd14    :lut_data <=	{8'h98, 16'h0C,8'h42}; //Power up part
		10'd15    :lut_data <=	{8'h98, 16'h15,8'h80}; //Disable Tristate of Pins
		10'd16    :lut_data <=	{8'h98, 16'h19,8'h88}; //LLC DLL phase
		10'd17    :lut_data <=	{8'h98, 16'h33,8'h40}; //LLC DLL MUX enable
		10'd18    :lut_data <=	{8'h98, 16'hDD,8'h00}; //ADI Required Write
		10'd19    :lut_data <=	{8'h98, 16'hE7,8'h04}; //ADI Required Write 
		10'd20    :lut_data <=	{8'h4C, 16'hB5,8'h01}; //Setting MCLK to 256Fs
		10'd21    :lut_data <=	{8'h4C, 16'hC3,8'h80}; //ADI Required Write
		10'd22    :lut_data <=	{8'h4C, 16'hCF,8'h03}; //ADI Required Write
		10'd23    :lut_data <=	{8'h4C, 16'hDB,8'h80}; //ADI Required Write
		10'd24    :lut_data <=	{8'h68, 16'hC0,8'h03}; //ADI Required write
		10'd25    :lut_data <=	{8'h68, 16'h00,8'h08}; //Set HDMI Input Port A (BG_MEAS_PORT_SEL = 001b)
		10'd26    :lut_data <=	{8'h68, 16'h02,8'h03}; //ALL BG Ports enabled
		10'd27    :lut_data <=	{8'h68, 16'h03,8'h98}; //ADI Required Write
		10'd28    :lut_data <=	{8'h68, 16'h10,8'hA5}; //ADI Required Write
		10'd29    :lut_data <=	{8'h68, 16'h1B,8'h00}; //ADI Required Write
		10'd30    :lut_data <=	{8'h68, 16'h45,8'h04}; //ADI Required Write
		10'd31    :lut_data <=	{8'h68, 16'h97,8'hC0}; //ADI Required Write
		10'd32    :lut_data <=	{8'h68, 16'h3E,8'h69}; //ADI Required Write
		10'd33    :lut_data <=	{8'h68, 16'h3F,8'h46}; //ADI Required Write
		10'd34    :lut_data <=	{8'h68, 16'h4E,8'hFE}; //ADI Required Write 
		10'd35    :lut_data <=	{8'h68, 16'h4F,8'h08}; //ADI Required Write
		10'd36    :lut_data <=  {8'h68, 16'h50,8'h00}; //ADI Required Write
		10'd37    :lut_data <=  {8'h68, 16'h57,8'hA3}; //ADI Required Write
		10'd38    :lut_data <=  {8'h68, 16'h58,8'h07}; //ADI Required Write
		10'd39    :lut_data <=  {8'h68, 16'h6F,8'h08}; //ADI Required Write
		10'd40    :lut_data <=  {8'h68, 16'h83,8'hFC}; //Enable clock terminators for port A & B 
		10'd41    :lut_data <=  {8'h68, 16'h84,8'h03}; //FP MODE
		10'd42    :lut_data <=  {8'h68, 16'h85,8'h10}; //ADI Required Write 
		10'd43    :lut_data <=  {8'h68, 16'h86,8'h9B}; //ADI Required Write 
		10'd44    :lut_data <=  {8'h68, 16'h89,8'h03}; //HF Gain
		10'd45    :lut_data <=  {8'h68, 16'h9B,8'h03}; //ADI Required Write
		10'd46    :lut_data <=  {8'h68, 16'h93,8'h03}; //ADI Required Write
		10'd47    :lut_data <=  {8'h68, 16'h5A,8'h80}; //ADI Required Write
		10'd48    :lut_data <=  {8'h68, 16'h9C,8'h80}; //ADI Required Write
		10'd49    :lut_data <=  {8'h68, 16'h9C,8'hC0}; //ADI Required Write
		10'd50    :lut_data <=  {8'h68, 16'h9C,8'h00}; //ADI Required Write 
		10'd51    :lut_data <=  {8'h68,16'h6C,8'hA3};  //HPA takes its value from HPA_MAN_VALUE_X
		10'd52    :lut_data <=  {8'h68,16'h83,8'hFF};
		10'd53    :lut_data <=  {8'h98,16'h20,8'h30};
		10'd54    :lut_data <=  {8'hfe, 16'd1500, 8'h00};
		10'd55    :lut_data <=  {8'h68,16'h83,8'hFC};
		10'd56    :lut_data <=  {8'h98,16'h20,8'hF0};
		10'd57    :lut_data <=  {8'h72, 16'hC7,8'h00};
		10'd58    :lut_data <=  {8'h72, 16'h08,8'h60};
		10'd59    :lut_data <=  {8'h72, 16'h09,8'h00};
		10'd60    :lut_data <=  {8'h72, 16'h0A,8'h00};
		10'd61    :lut_data <=  {8'h72, 16'h1E,8'h00};
		10'd62    :lut_data <=  {8'h72, 16'h1A,8'h01};
		default:lut_data <= {8'hff,16'hffff,8'hff};
	endcase
end


endmodule 