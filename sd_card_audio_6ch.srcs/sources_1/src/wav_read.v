module wav_read(
    input clk,
    input rst,
    output ready,
    input find,
    input sd_init_done, // SD card initialization completed
    output reg [3:0] state_code, // state indication coding
    // 0: SD card is initializing
    // 1: wait for the button to press
    // 2: looking for the WAV file
    // 3: playing
    output reg sd_sec_read, // SD card sector read
    output reg [31:0] sd_sec_read_addr, // SD card sector read address
    input [7:0] sd_sec_read_data, // SD card sector read data
    input sd_sec_read_data_valid, // SD card sector read data valid
    input sd_sec_read_end, // SD card sector read end

    input [15:0] fifo_wr_cnt1, // FIFO1 write used words
    input [15:0] fifo_wr_cnt2, // FIFO2 write used words
    input [15:0] fifo_wr_cnt3, // FIFO2 write used words
    input [15:0] fifo_wr_cnt4, // FIFO2 write used words
    input [15:0] fifo_wr_cnt5, // FIFO2 write used words
    input [15:0] fifo_wr_cnt6, // FIFO2 write used words

    output reg wav_data_wr_en1, // WAV audio data write enable FIFO1
    output reg wav_data_wr_en2, // WAV audio data write enable FIFO2
    output reg wav_data_wr_en3, // WAV audio data write enable FIFO1
    output reg wav_data_wr_en4, // WAV audio data write enable FIFO2
    output reg wav_data_wr_en5, // WAV audio data write enable FIFO1
    output reg wav_data_wr_en6, // WAV audio data write enable FIFO2

    output reg [7:0] wav_data1, // WAV audio data FIFO1
    output reg [7:0] wav_data2, // WAV audio data FIFO2
    output reg [7:0] wav_data3, // WAV audio data FIFO1
    output reg [7:0] wav_data4, // WAV audio data FIFO2
    output reg [7:0] wav_data5, // WAV audio data FIFO1
    output reg [7:0] wav_data6 // WAV audio data FIFO2
);

// Parameters and local parameters
parameter  FIFO_DEPTH     = 1024;
localparam S_IDLE         = 0;
localparam S_FIND         = 1;
localparam S_PLAY_WAIT    = 2;
localparam S_PLAY         = 3;
localparam S_END          = 4;
localparam HEADER_SIZE    = 88;

// State machine and registers
reg [3:0] state;
reg [9:0] rd_cnt;
reg [7:0] header_0, header_1, header_2, header_3;
reg [7:0] header_4, header_5, header_6, header_7;
reg [31:0] file_len1, file_len2, file_len3, file_len4, file_len5, file_len6;
reg [31:0] play_cnt1, play_cnt2, play_cnt3, play_cnt4, play_cnt5, play_cnt6;
reg found1, found2, found3, found4, found5, found6;
reg [31:0] file1_start_addr, file2_start_addr, file3_start_addr, file4_start_addr, file5_start_addr, file6_start_addr;
reg read_file1, read_file2, read_file3, read_file4, read_file5, read_file6;

// Ready signal assignment
assign ready = (state == S_IDLE);

// State machine logic
always @(posedge clk or posedge rst) begin
    if (rst == 1'b1) begin
        state <= S_IDLE;
        sd_sec_read <= 1'b0;
        sd_sec_read_addr <= 32'd8196;
        state_code <= 4'd0;
        read_file1 <= 1'b1;
        read_file2 <= 1'b0;
        read_file3 <= 1'b0;
        read_file4 <= 1'b0;
        read_file5 <= 1'b0;
        read_file6 <= 1'b0;
    end else if (sd_init_done == 1'b0) begin
        state <= S_IDLE;
    end else begin
        case(state)
            S_IDLE: begin
                state_code <= 4'd1;
                if (find == 1'b1)
                    state <= S_FIND;
                sd_sec_read_addr <= {sd_sec_read_addr[31:3], 3'd0}; // Address 8 aligned
            end
            S_FIND: begin
                state_code <= 4'd2;
                if (sd_sec_read_end == 1'b1) begin
                    if (found1 == 1'b1 && found2 == 1'b1 && found3 == 1'b1 && found4 == 1'b1 && found5 == 1'b1 && found6 == 1'b1) begin
                        state <= S_PLAY_WAIT;
                        sd_sec_read <= 1'b0;
                    end else
                        sd_sec_read_addr <= sd_sec_read_addr + 32'd8; // Search every 8 sectors (4K)
                end else
                    sd_sec_read <= 1'b1;
            end
            S_PLAY_WAIT: begin
                if (fifo_wr_cnt1 <= (FIFO_DEPTH - 512) && fifo_wr_cnt2 <= (FIFO_DEPTH - 512) && fifo_wr_cnt3 <= (FIFO_DEPTH - 512) && fifo_wr_cnt4 <= (FIFO_DEPTH - 512) && fifo_wr_cnt5 <= (FIFO_DEPTH - 512) && fifo_wr_cnt6 <= (FIFO_DEPTH - 512))
                    state <= S_PLAY;
            end
            S_PLAY: begin
                state_code <= 4'd3;
                if (sd_sec_read_end == 1'b1) begin
                    // File play logic
                    if (read_file1) begin
                        sd_sec_read_addr <= file1_start_addr + ((play_cnt1 - HEADER_SIZE) >> 9);
                        read_file1 <= 1'b0;
                        read_file2 <= 1'b1;
                    end else if (read_file2) begin
                        sd_sec_read_addr <= file2_start_addr + ((play_cnt2 - HEADER_SIZE) >> 9);
                        read_file2 <= 1'b0;
                        read_file3 <= 1'b1;
                    end else if (read_file3) begin
                        sd_sec_read_addr <= file3_start_addr + ((play_cnt3 - HEADER_SIZE) >> 9);
                        read_file3 <= 1'b0;
                        read_file4 <= 1'b1;
                    end else if (read_file4) begin
                        sd_sec_read_addr <= file4_start_addr + ((play_cnt4 - HEADER_SIZE) >> 9);
                        read_file4 <= 1'b0;
                        read_file5 <= 1'b1;
                    end else if (read_file5) begin
                        sd_sec_read_addr <= file4_start_addr + ((play_cnt4 - HEADER_SIZE) >> 9);
                        read_file5 <= 1'b0;
                        read_file6 <= 1'b1;
                    end else if (read_file6) begin
                        sd_sec_read_addr <= file4_start_addr + ((play_cnt4 - HEADER_SIZE) >> 9);
                        read_file1 <= 1'b1;
                    end
                    sd_sec_read <= 1'b0;
                    if (play_cnt1 >= file_len1 && play_cnt2 >= file_len2 && play_cnt3 >= file_len3 && play_cnt4 >= file_len4 && play_cnt5 >= file_len5 && play_cnt6 >= file_len6)
                        state <= S_END;
                    else
                        state <= S_PLAY_WAIT;
                end else
                    sd_sec_read <= 1'b1;
            end
            S_END: begin
                state <= S_IDLE;
            end
            default: begin
                state <= S_IDLE;
            end
        endcase
    end
end


endmodule

