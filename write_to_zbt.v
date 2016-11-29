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
			2'd0: value = 18'b010010110001001011; // 300, 300 
			2'd1: value = 18'b011001000001100100; // 400, 400
			2'd2: value = 18'b011111010001111101; // 500, 500
			2'd3: value = 18'b100101100010010110; // 600, 600
			default: value = 0;
		endcase
endmodule
