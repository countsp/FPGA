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
//  2017/6/21    meisq         1.0         Original
//*************************************************************************/
module sd_card_audio(
	input                       clk,
	input                       rst_n,
	input                       key1,
	output[1:0]                 state_code,
	
	input                       bclk,         //audio bit clock
	output                      dacdat1,       //DAC audio data output 
	output                      dacdat2,       //DAC audio data output 
	output                      dacdat3,       //DAC audio data output 
	output                      dacdat4,       //DAC audio data output 
	output                      dacdat5,       //DAC audio data output 
	output                      dacdat6,       //DAC audio data output 
	
	input                       adclrc,       //ADC sample rate left right clock

	output                      sd_ncs,       //SD card chip select (SPI mode)  
	output                      sd_dclk,      //SD card clock
	output                      sd_mosi,      //SD card controller data output
	input                       sd_miso       //SD card controller data input
);

wire             button_negedge;              //press button ,one clock cycle    
wire             sd_sec_read;                 //SD card sector read
wire[31:0]       sd_sec_read_addr;            //SD card sector read address
wire[7:0]        sd_sec_read_data;            //SD card sector read data
wire             sd_sec_read_data_valid;      //SD card sector read data valid
wire             sd_sec_read_end;             //SD card sector read end

wire             wav_data_wr_en1;              //wav audio data write enable
wire             wav_data_wr_en2;              //wav audio data write enable
wire             wav_data_wr_en3;              //wav audio data write enable
wire             wav_data_wr_en4;              //wav audio data write enable
wire             wav_data_wr_en5;              //wav audio data write enable
wire             wav_data_wr_en6;              //wav audio data write enable


wire[7:0]        wav_data1;                    //wav audio data
wire[7:0]        wav_data2;                    //wav audio data
wire[7:0]        wav_data3;                    //wav audio data
wire[7:0]        wav_data4;                    //wav audio data
wire[7:0]        wav_data5;                    //wav audio data
wire[7:0]        wav_data6;                    //wav audio data

wire[15:0]       wrusedw1;                     //fifo write Used Words
wire[15:0]       wrusedw2;                     //fifo write Used Words
wire[15:0]       wrusedw3;                     //fifo write Used Words
wire[15:0]       wrusedw4;                     //fifo write Used Words
wire[15:0]       wrusedw5;                     //fifo write Used Words
wire[15:0]       wrusedw6;                     //fifo write Used Words

wire[31:0]       read_data1;                   //fifo read data
wire[31:0]       read_data2;                   //fifo read data
wire[31:0]       read_data3;                   //fifo read data
wire[31:0]       read_data4;                   //fifo read data
wire[31:0]       read_data5;                   //fifo read data
wire[31:0]       read_data6;                   //fifo read data

wire             read_data_en1;                //fifo read enable
wire             read_data_en2;                //fifo read enable
wire             read_data_en3;                //fifo read enable
wire             read_data_en4;                //fifo read enable
wire             read_data_en5;                //fifo read enable
wire             read_data_en6;                //fifo read enable

wire             rdempty1;                     //fifo read empty
wire             rdempty2;                     //fifo read empty
wire             rdempty3;                     //fifo read empty
wire             rdempty4;                     //fifo read empty
wire             rdempty5;                     //fifo read empty
wire             rdempty6;                     //fifo read empty

wire[15:0]       tx_left_data1;                //left channel audio data
wire[15:0]       tx_left_data2;                //left channel audio data
wire[15:0]       tx_left_data3;                //left channel audio data
wire[15:0]       tx_left_data4;                //left channel audio data
wire[15:0]       tx_left_data5;                //left channel audio data
wire[15:0]       tx_left_data6;                //left channel audio data

wire[15:0]       tx_right_data1;               //right channel audio data
wire[15:0]       tx_right_data2;               //right channel audio data
wire[15:0]       tx_right_data3;               //right channel audio data
wire[15:0]       tx_right_data4;               //right channel audio data
wire[15:0]       tx_right_data5;               //right channel audio data
wire[15:0]       tx_right_data6;               //right channel audio data

wire             sd_init_done;                //SD card initialization completed


assign tx_left_data1 = {read_data1[23:16],read_data1[31:24]};
assign tx_right_data1 = {read_data1[7:0],read_data1[15:8]};

// added for ch2
assign tx_left_data2 = {read_data2[23:16],read_data2[31:24]};
assign tx_right_data2 = {read_data2[7:0],read_data2[15:8]};

assign tx_left_data3 = {read_data3[23:16],read_data3[31:24]};
assign tx_right_data3 = {read_data3[7:0],read_data3[15:8]};

// added for ch2
assign tx_left_data4 = {read_data4[23:16],read_data4[31:24]};
assign tx_right_data4 = {read_data4[7:0],read_data4[15:8]};


assign tx_left_data5 = {read_data5[23:16],read_data5[31:24]};
assign tx_right_data5 = {read_data5[7:0],read_data5[15:8]};

assign tx_left_data6 = {read_data6[23:16],read_data6[31:24]};
assign tx_right_data6 = {read_data6[7:0],read_data6[15:8]};

ax_debounce#(.FREQ(50)) ax_debounce_m0
(
	.clk             (clk),
	.rst             (~rst_n),
	.button_in       (key1),
	.button_posedge  (),
	.button_negedge  (button_negedge),
	.button_out      ()
);

audio_tx audio_tx_m1
(
.rst (~rst_n ),
.clk (clk ),
.sck_bclk (bclk ),
.ws_lrc (adclrc ),
.sdata (dacdat1 ),
.left_data (tx_left_data1 ),
.right_data (tx_right_data1 ),
.read_data_en (read_data_en1 )
);

audio_tx audio_tx_m2
(
.rst (~rst_n ),
.clk (clk ),
.sck_bclk (bclk ),
.ws_lrc (adclrc ),
.sdata (dacdat2 ),
.left_data (tx_left_data2 ),
.right_data (tx_right_data2 ),
.read_data_en (read_data_en2 )
);

audio_tx audio_tx_m3
(
.rst (~rst_n ),
.clk (clk ),
.sck_bclk (bclk ),
.ws_lrc (adclrc ),
.sdata (dacdat3 ),
.left_data (tx_left_data3 ),
.right_data (tx_right_data3 ),
.read_data_en (read_data_en3 )
);

audio_tx audio_tx_m4
(
.rst (~rst_n ),
.clk (clk ),
.sck_bclk (bclk ),
.ws_lrc (adclrc ),
.sdata (dacdat4 ),
.left_data (tx_left_data4 ),
.right_data (tx_right_data4 ),
.read_data_en (read_data_en4 )
);

audio_tx audio_tx_m5
(
.rst (~rst_n ),
.clk (clk ),
.sck_bclk (bclk ),
.ws_lrc (adclrc ),
.sdata (dacdat5 ),
.left_data (tx_left_data5 ),
.right_data (tx_right_data5 ),
.read_data_en (read_data_en5 )
);
audio_tx audio_tx_m6
(
.rst (~rst_n ),
.clk (clk ),
.sck_bclk (bclk ),
.ws_lrc (adclrc ),
.sdata (dacdat6 ),
.left_data (tx_left_data6 ),
.right_data (tx_right_data6 ),
.read_data_en (read_data_en6 )
);


//audio_buf
afifo_8i_32o_1024 audio_buf1
(
.rd_clk (clk ), // Read side clock
.wr_clk (clk ), // Write side clock
.rst (1'b0 ), // Asynchronous clear
.wr_en (wav_data_wr_en1 ), // Write Request
.rd_en (read_data_en1 & ~rdempty ), // Read Request
.din (wav_data1 ), // Input Data
.empty (rdempty1 ), // Read side Empty flag
.full ( ), // Write side Full flag
.rd_data_count ( ), // Read Used Words
.wr_data_count (wrusedw1[9:0] ), // Write Used Words
.dout (read_data1 )
);

afifo_8i_32o_1024 audio_buf2
(
.rd_clk (clk ), // Read side clock
.wr_clk (clk ), // Write side clock
.rst (1'b0 ), // Asynchronous clear
.wr_en (wav_data_wr_en2 ), // Write Request
.rd_en (read_data_en2 & ~rdempty2 ), // Read Request
.din (wav_data2 ), // Input Data
.empty (rdempty2 ), // Read side Empty flag
.full ( ), // Write side Full flag
.rd_data_count ( ), // Read Used Words
.wr_data_count (wrusedw2[9:0] ), // Write Used Words
.dout (read_data2 )
);

afifo_8i_32o_1024 audio_buf3
(
.rd_clk (clk ), // Read side clock
.wr_clk (clk ), // Write side clock
.rst (1'b0 ), // Asynchronous clear
.wr_en (wav_data_wr_en3 ), // Write Request
.rd_en (read_data_en3 & ~rdempty3 ), // Read Request
.din (wav_data3 ), // Input Data
.empty (rdempty3 ), // Read side Empty flag
.full ( ), // Write side Full flag
.rd_data_count ( ), // Read Used Words
.wr_data_count (wrusedw3[9:0] ), // Write Used Words
.dout (read_data3 )
);


afifo_8i_32o_1024 audio_buf4
(
.rd_clk (clk ), // Read side clock
.wr_clk (clk ), // Write side clock
.rst (1'b0 ), // Asynchronous clear
.wr_en (wav_data_wr_en4 ), // Write Request
.rd_en (read_data_en4 & ~rdempty4 ), // Read Request
.din (wav_data4 ), // Input Data
.empty (rdempty4 ), // Read side Empty flag
.full ( ), // Write side Full flag
.rd_data_count ( ), // Read Used Words
.wr_data_count (wrusedw4[9:0] ), // Write Used Words
.dout (read_data4 )
);

afifo_8i_32o_1024 audio_buf5
(
.rd_clk (clk ), // Read side clock
.wr_clk (clk ), // Write side clock
.rst (1'b0 ), // Asynchronous clear
.wr_en (wav_data_wr_en5 ), // Write Request
.rd_en (read_data_en5 & ~rdempty5 ), // Read Request
.din (wav_data5 ), // Input Data
.empty (rdempty5 ), // Read side Empty flag
.full ( ), // Write side Full flag
.rd_data_count ( ), // Read Used Words
.wr_data_count (wrusedw5[9:0] ), // Write Used Words
.dout (read_data5 )
);

afifo_8i_32o_1024 audio_buf6
(
.rd_clk (clk ), // Read side clock
.wr_clk (clk ), // Write side clock
.rst (1'b0 ), // Asynchronous clear
.wr_en (wav_data_wr_en6 ), // Write Request
.rd_en (read_data_en6 & ~rdempty6 ), // Read Request
.din (wav_data6 ), // Input Data
.empty (rdempty6 ), // Read side Empty flag
.full ( ), // Write side Full flag
.rd_data_count ( ), // Read Used Words
.wr_data_count (wrusedw6[9:0] ), // Write Used Words
.dout (read_data6 )
);


wav_read wav_read_m0(
.clk (clk ),
.rst (~rst_n ),
.ready ( ),
.find (button_negedge ),
.sd_init_done (sd_init_done ),
.state_code (state_code ),
.sd_sec_read (sd_sec_read ),
.sd_sec_read_addr (sd_sec_read_addr ),
.sd_sec_read_data (sd_sec_read_data ),
.sd_sec_read_data_valid (sd_sec_read_data_valid ),
.sd_sec_read_end (sd_sec_read_end ),

.fifo_wr_cnt1 (wrusedw1 ),
.fifo_wr_cnt2 (wrusedw2 ),
.fifo_wr_cnt3 (wrusedw3 ),
.fifo_wr_cnt4 (wrusedw4 ),
.fifo_wr_cnt5 (wrusedw5 ),
.fifo_wr_cnt6 (wrusedw6 ),

.wav_data_wr_en1 (wav_data_wr_en1 ),
.wav_data_wr_en2 (wav_data_wr_en2 ),
.wav_data_wr_en3 (wav_data_wr_en3 ),
.wav_data_wr_en4 (wav_data_wr_en4 ),
.wav_data_wr_en5 (wav_data_wr_en5 ),
.wav_data_wr_en6 (wav_data_wr_en6 ),


.wav_data1 (wav_data1 ),
.wav_data2 (wav_data2 ),
.wav_data3 (wav_data3 ),
.wav_data4 (wav_data4 ),
.wav_data5 (wav_data5 ),
.wav_data6 (wav_data6 )



);

sd_card_top  sd_card_top_m0(
	.clk                       (clk                        ),
	.rst                       (~rst_n                     ),
	.SD_nCS                    (sd_ncs                     ),
	.SD_DCLK                   (sd_dclk                    ),
	.SD_MOSI                   (sd_mosi                    ),
	.SD_MISO                   (sd_miso                    ),
	.sd_init_done              (sd_init_done               ),
	.sd_sec_read               (sd_sec_read                ),
	.sd_sec_read_addr          (sd_sec_read_addr           ),
	.sd_sec_read_data          (sd_sec_read_data           ),
	.sd_sec_read_data_valid    (sd_sec_read_data_valid     ),
	.sd_sec_read_end           (sd_sec_read_end            ),
	.sd_sec_write              (1'b0                       ),
	.sd_sec_write_addr         (32'd0                      ),
	.sd_sec_write_data         (                           ),
	.sd_sec_write_data_req     (                           ),
	.sd_sec_write_end          (                           )
);
endmodule 
