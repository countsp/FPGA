module sd_card_audio(
    input                       clk,
    input                       rst_n,
    input                       key1,
    output [1:0]                state_code,
    
    input                       bclk,        // Audio bit clock
    output                      dacdat1,     // DAC audio data output
    output                      dacdat2,     // DAC audio data output
    output                      dacdat3,     // DAC audio data output
    output                      dacdat4,     // DAC audio data output
    output                      dacdat5,     // DAC audio data output
    output                      dacdat6,     // DAC audio data output
    
    input                       adclrc,      // ADC sample rate left-right clock

    output                      sd_ncs,      // SD card chip select (SPI mode)
    output                      sd_dclk,     // SD card clock
    output                      sd_mosi,     // SD card controller data output
    input                       sd_miso      // SD card controller data input
);

// Signal declarations
wire             button_negedge;              // Press button, one clock cycle    
wire             sd_sec_read;                 // SD card sector read
wire [31:0]      sd_sec_read_addr;            // SD card sector read address
wire [7:0]       sd_sec_read_data;            // SD card sector read data
wire             sd_sec_read_data_valid;      // SD card sector read data valid
wire             sd_sec_read_end;             // SD card sector read end

wire             wav_data_wr_en1, wav_data_wr_en2, wav_data_wr_en3;
wire             wav_data_wr_en4, wav_data_wr_en5, wav_data_wr_en6;

wire [7:0]       wav_data1, wav_data2, wav_data3, wav_data4, wav_data5, wav_data6;

wire [15:0]      wrusedw1, wrusedw2, wrusedw3, wrusedw4, wrusedw5, wrusedw6;

wire [31:0]      read_data1, read_data2, read_data3, read_data4, read_data5, read_data6;

wire             read_data_en1, read_data_en2, read_data_en3;
wire             read_data_en4, read_data_en5, read_data_en6;

wire             rdempty1, rdempty2, rdempty3, rdempty4, rdempty5, rdempty6;

wire [15:0]      tx_left_data1, tx_left_data2, tx_left_data3, tx_left_data4, tx_left_data5, tx_left_data6;
wire [15:0]      tx_right_data1, tx_right_data2, tx_right_data3, tx_right_data4, tx_right_data5, tx_right_data6;

wire             sd_init_done;                // SD card initialization completed

// Assignments for audio data
assign tx_left_data1 = {read_data1[23:16], read_data1[31:24]};
assign tx_right_data1 = {read_data1[7:0], read_data1[15:8]};
assign tx_left_data2 = {read_data2[23:16], read_data2[31:24]};
assign tx_right_data2 = {read_data2[7:0], read_data2[15:8]};
assign tx_left_data3 = {read_data3[23:16], read_data3[31:24]};
assign tx_right_data3 = {read_data3[7:0], read_data3[15:8]};
assign tx_left_data4 = {read_data4[23:16], read_data4[31:24]};
assign tx_right_data4 = {read_data4[7:0], read_data4[15:8]};
assign tx_left_data5 = {read_data5[23:16], read_data5[31:24]};
assign tx_right_data5 = {read_data5[7:0], read_data5[15:8]};
assign tx_left_data6 = {read_data6[23:16], read_data6[31:24]};
assign tx_right_data6 = {read_data6[7:0], read_data6[15:8]};

// Button debounce
ax_debounce #(.FREQ(50)) ax_debounce_m0 (
    .clk             (clk),
    .rst             (~rst_n),
    .button_in       (key1),
    .button_posedge  (),
    .button_negedge  (button_negedge),
    .button_out      ()
);

// Audio transmitters
audio_tx audio_tx_m1 (.rst (~rst_n), .clk (clk), .sck_bclk (bclk), .ws_lrc (adclrc), .sdata (dacdat1), .left_data (tx_left_data1), .right_data (tx_right_data1), .read_data_en (read_data_en1));
audio_tx audio_tx_m2 (.rst (~rst_n), .clk (clk), .sck_bclk (bclk), .ws_lrc (adclrc), .sdata (dacdat2), .left_data (tx_left_data2), .right_data (tx_right_data2), .read_data_en (read_data_en2));
audio_tx audio_tx_m3 (.rst (~rst_n), .clk (clk), .sck_bclk (bclk), .ws_lrc (adclrc), .sdata (dacdat3), .left_data (tx_left_data3), .right_data (tx_right_data3), .read_data_en (read_data_en3));
audio_tx audio_tx_m4 (.rst (~rst_n), .clk (clk), .sck_bclk (bclk), .ws_lrc (adclrc), .sdata (dacdat4), .left_data (tx_left_data4), .right_data (tx_right_data4), .read_data_en (read_data_en4));
audio_tx audio_tx_m5 (.rst (~rst_n), .clk (clk), .sck_bclk (bclk), .ws_lrc (adclrc), .sdata (dacdat5), .left_data (tx_left_data5), .right_data (tx_right_data5), .read_data_en (read_data_en5));
audio_tx audio_tx_m6 (.rst (~rst_n), .clk (clk), .sck_bclk (bclk), .ws_lrc (adclrc), .sdata (dacdat6), .left_data (tx_left_data6), .right_data (tx_right_data6), .read_data_en (read_data_en6));

// Audio buffers (FIFO)
afifo_8i_32o_1024 audio_buf1 (.rd_clk (clk), .wr_clk (clk), .rst (1'b0), .wr_en (wav_data_wr_en1), .rd_en (read_data_en1 & ~rdempty1), .din (wav_data1), .empty (rdempty1), .wr_data_count (wrusedw1[9:0]), .dout (read_data1));
afifo_8i_32o_1024 audio_buf2 (.rd_clk (clk), .wr_clk (clk), .rst (1'b0), .wr_en (wav_data_wr_en2), .rd_en (read_data_en2 & ~rdempty2), .din (wav_data2), .empty (rdempty2), .wr_data_count (wrusedw2[9:0]), .dout (read_data2));
afifo_8i_32o_1024 audio_buf3 (.rd_clk (clk), .wr_clk (clk), .rst (1'b0), .wr_en (wav_data_wr_en3), .rd_en (read_data_en3 & ~rdempty3), .din (wav_data3), .empty (rdempty3), .wr_data_count (wrusedw3[9:0]), .dout (read_data3));
afifo_8i_32o_1024 audio_buf4 (.rd_clk (clk), .wr_clk (clk), .rst (1'b0), .wr_en (wav_data_wr_en4), .rd_en (read_data_en4 & ~rdempty4), .din (wav_data4), .empty (rdempty4), .wr_data_count (wrusedw4[9:0]), .dout (read_data4));
afifo_8i_32o_1024 audio_buf5 (.rd_clk (clk), .wr_clk (clk), .rst (1'b0), .wr_en (wav_data_wr_en5), .rd_en (read_data_en5 & ~rdempty5), .din (wav_data5), .empty (rdempty5), .wr_data_count (wrusedw5[9:0]), .dout (read_data5));
afifo_8i_32o_1024 audio_buf6 (.rd_clk (clk), .wr_clk (clk), .rst (1'b0), .wr_en (wav_data_wr_en6), .rd_en (read_data_en6 & ~rdempty6), .din (wav_data6), .empty (rdempty6), .wr_data_count (wrusedw6[9:0]), .dout (read_data6));

// WAV read module
wav_read wav_read_m0 (
    .clk (clk),
    .rst (~rst_n),
    .ready (),
    .find (button_negedge),
    .sd_init_done (sd_init_done),
    .state_code (state_code),
    .sd_sec_read (sd_sec_read),
    .sd_sec_read_addr (sd_sec_read_addr),
    .sd_sec_read_data (sd_sec_read_data),
    .sd_sec_read_data_valid (sd_sec_read_data_valid),
    .sd_sec_read_end (sd_sec_read_end),
    .fifo_wr_cnt1 (wrusedw1),
    .fifo_wr_cnt2 (wrusedw2),
    .fifo_wr_cnt3 (wrusedw3),
    .fifo_wr_cnt4 (wrusedw4),
    .fifo_wr_cnt5 (wrusedw5),
    .fifo_wr_cnt6 (wrusedw6),
    .wav_data_wr_en1 (wav_data_wr_en1),
    .wav_data_wr_en2 (wav_data_wr_en2),
    .wav_data_wr_en3 (wav_data_wr_en3),
    .wav_data_wr_en4 (wav_data_wr_en4),
    .wav_data_wr_en5 (wav_data_wr_en5),
    .wav_data_wr_en6 (wav_data_wr_en6),
    .wav_data1 (wav_data1),
    .wav_data2 (wav_data2),
    .wav_data3 (wav_data3),
    .wav_data4 (wav_data4),
    .wav_data5 (wav_data5),
    .wav_data6 (wav_data6)
);

// SD card interface
sd_card_top sd_card_top_m0 (
    .clk (clk),
    .rst (~rst_n),
    .SD_nCS (sd_ncs),
    .SD_DCLK (sd_dclk),
    .SD_MOSI (sd_mosi),
    .SD_MISO (sd_miso),
    .sd_init_done (sd_init_done),
    .sd_sec_read (sd_sec_read),
    .sd_sec_read_addr (sd_sec_read_addr),
    .sd_sec_read_data (sd_sec_read_data),
    .sd_sec_read_data_valid (sd_sec_read_data_valid),
    .sd_sec_read_end (sd_sec_read_end),
    .sd_sec_write (1'b0),
    .sd_sec_write_addr (32'd0),
    .sd_sec_write_data (),
    .sd_sec_write_data_req (),
    .sd_sec_write_end ()
);

endmodule
