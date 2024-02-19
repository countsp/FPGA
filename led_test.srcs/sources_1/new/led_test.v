//===========================================================================
// Module name: led_test.v
//===========================================================================
`timescale 1ns / 1ps

module led_test 
(             
	input         	    sys_clk_p,      // Differentia system clock 200Mhz input on board
	input         	    sys_clk_n,
	input         	    rst_n,          // reset ,low active            
	output reg [1:0]  	led,            // LED,use for control the LED signal on board
	output        	    fan_pwm         //fan control
 );
//define the time counter
reg [31:0]   timer;                  
assign fan_pwm = 1'b0;
//===========================================================================
//Differentia system clock to single end clock
//===========================================================================
wire        sys_clk;

// IBUFDS: Differential Input Buffer
//         Kintex-7
// Xilinx HDL Language Template, version 2017.4
   
IBUFDS #(
	.DIFF_TERM("TRUE"),       // Differential Termination
	.IBUF_LOW_PWR("TRUE"),     // Low power="TRUE", Highest performance="FALSE" 
	.IOSTANDARD("DEFAULT")     // Specify the input I/O standard
) u_ibuf_sys_clk (
	.O(sys_clk),  // Buffer output
	.I(sys_clk_p),  // Diff_p buffer input (connect directly to top-level port)
	.IB(sys_clk_n) // Diff_n buffer input (connect directly to top-level port)
);               
//===========================================================================
// cycle counter:from 0 to 1 sec
//===========================================================================
  always @(posedge sys_clk or negedge rst_n)    
    begin
      if (~rst_n)                           
          timer <= 32'd0;                     // when the reset signal valid,time counter clearing
      else if (timer == 32'd199_999_999)    //1 seconds count(200M-1=199999999)
          timer <= 32'd0;                       //count done,clearing the time counter
      else
		    timer <= timer + 1'b1;            //timer counter = timer counter + 1
    end

//===========================================================================
// LED control
//===========================================================================
  always @(posedge sys_clk or negedge rst_n)   
    begin
      if (~rst_n)                      
          led <= 2'b00;                  //when the reset signal active         
      else if (timer == 32'd49_999_999)    //time counter count to 0.25 sec,LED1 lighten
          led <= 2'b01;                 
      else if (timer == 32'd99_999_999)    //time counter count to 0.5 sec,LED2 lighten
          led <= 2'b10;                  
      else if (timer == 32'd149_999_999)   //time counter count to 0.75 sec,
          led <= 2'b00;                                          
      else if (timer == 32'd199_999_999)   //time counter count to 1 sec,LED1,LED2 lighten
          led <= 2'b11;                         
    end
    
endmodule
