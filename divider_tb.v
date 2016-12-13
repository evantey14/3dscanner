`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   16:22:08 12/11/2016
// Design Name:   divider
// Module Name:   /afs/athena.mit.edu/user/l/n/lnj/3dscanner/3dscanner/divider_tb.v
// Project Name:  3dscanner
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: divider
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module divider_tb;

	// Inputs
	reg clk;
	reg sign;
	reg start;
	reg [35:0] dividend;
	reg [35:0] divider;

	// Outputs
	wire [35:0] quotient;
	wire [35:0] remainder;
	wire ready;

	// Instantiate the Unit Under Test (UUT)
	divider #(.WIDTH(36)) uut(
		.clk(clk), 
		.sign(sign), 
		.start(start), 
		.dividend(dividend), 
		.divider(divider), 
		.quotient(quotient), 
		.remainder(remainder), 
		.ready(ready)
	);

	always #5 clk <= ~clk;
	initial begin
		// Initialize Inputs
		clk = 0;
		sign = 1;
		start = 0;
		dividend = 0;
		divider = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// -10/2 = -5
//		dividend = -8'shA;
//		divider = 8'sh2;
//		start = 1;
//		#10 start = 0;
//		// -15/5 = -3
//		#90
//		dividend = -8'shF;
//		divider = 8'sh5;
//		start = 1;
//		#10 start = 0;
		dividend = -36'sh14850560;
		divider = 36'shFFFFFFEE2;
		start = 1;
		#10 start = 0;
	end
      
endmodule

