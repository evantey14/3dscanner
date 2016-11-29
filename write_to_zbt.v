`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:42:00 11/27/2016 
// Design Name: 
// Module Name:    write_to_zbt 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module write_to_zbt(
	input wire [1:0] index,
	output reg [35:0] value
    );
	 always @(index)
		case (index)
			2'd0: value = 36'b000000000000000000_0100101100_01001011; // 300, 300 
			2'd1: value = 36'b000000000000000000_0110010000_01100100; // 400, 400
			2'd2: value = 36'b000000000000000000_0111110100_01111101; // 500, 500
			2'd3: value = 36'b000000000000000000_1001011000_10010110; // 600, 600
			default: value = 0;
		endcase
endmodule
