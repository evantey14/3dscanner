`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:		 Gim P. Hom
//
// Create Date:    13:26:09 05/07/06
// Module Name:    rs232transmit
//
// Revision:
// Revision 0.01 - File Created		5/7/2006  GPH
// Additional Comments:	  This file will transmit ascii characters to a RS-232 
// interface. The baud rate for the example is preset to 115,200

// This transmitter uses a shift register to shift out the data.
//
// Character is sent when send goes high.
// 
// The calcuations assume a clock of 27 mhz.
//
// Baud Rate       DIVISOR  Exact   Actual Baud   % error
//  230,400         117    117.1875 230,769.23      0.16%
//  115,200         234    234.375  115,384.62      0.16%
//   57,600         468    468.75   57,692.31       0.16%
//   38,400         703    703.125  38,406.83       0.02%
//   19,200         1,406  1406.25  19,203.41       0.02%
//    9,600         2,812  2812.5   9,601.71        0.02%
//    4,800         5,625  5625     4,800.00        0.00%
//    2,400        11,250  11250    2,400.00        0.00%
//    1,200        22,500  22500    1,200.00        0.00%
////////////////////////////////////////////////////////////////////////////////
module rs232transmit(clk, reset, data, send, xmit_data, xmit_clk, start_send);

// this section sets up the clk;
    parameter DIVISOR =  352;//234; // create 115,200 baud rate clock, not exact, but should work.
	 parameter MARK = 1'b1;
	 parameter STOP_BIT = 1'b1;
	 parameter START_BIT =1'b0;

    input [7:0] data;        // 8 bit ascii data
	 input send;  				  // posedge of send will send a character
	 input clk, reset;  		  // clock_27mhz and reset
	 
	 output  xmit_data, xmit_clk;
	 reg xmit_clk;
	 
	 reg old_send, xmit_bit;
	 output start_send;
	 wire start_send; 
	  
    reg [15:0] count;
	 reg [10:0] temp;

    always @ (posedge clk) old_send <= send;
	 assign start_send = ~old_send && send;
//  the above two lines generates a pulse to start the transmission.


    always @ (posedge clk)
    begin
    	count <= xmit_clk ? 0 : count+1;
    	xmit_clk <= count == DIVISOR-2; //558
		
		if (reset) 
		  begin
		   count <= 0;
			xmit_bit <= MARK;
			temp <= 10'hff; 
		  end 
		else
		   if (start_send) 	temp <= {MARK, STOP_BIT, data, START_BIT}; 
			else
		  		begin
					if (xmit_clk) 	
		     			begin
			  			temp <= {MARK, temp[9:1]};
			  			xmit_bit <= temp[0];
						end 
				end
	 end
	 
	 assign xmit_data  = xmit_bit; 

endmodule
