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
			2'd0: value = 18'b011111010001111101;//{10'd500,11'd500}>>2;
			default: value = 0;
		endcase
endmodule
