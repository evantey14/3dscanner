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
module manual_write_to_zbt(
	input clk,
	output reg [18:0] addr,
	output reg [35:0] value
    );
	
	 parameter size = 8;
	 always @(posedge clk) begin
		if (addr >= size) addr <= 0;
		else addr <= addr+1;
	 end
	 
	 always @(addr)
		case (addr)
			3'd0: value = {6'b0,10'd100,10'd100,10'b1111_1111_00};//36'b000000000000000000_0100101100_01001011; // 300, 300 
			3'd1: value = {6'b0,10'd100,10'd100,10'b0011_1111_00};//36'b000000000000000000_1001011000_10010110; // 600, 600
			3'd2: value = {6'b0,10'd200,10'd200,10'b1111_1111_00};//36'b000000000000000000_0111110100_01111101; // 500, 500
			3'd3: value = {6'b0,10'd300,10'd300,10'b0011_1111_00};//36'b000000000000000000_0110010000_01100100; // 400, 400
			3'd4: value = {6'b0,10'd400,10'd400,10'b1111_1111_00};//36'b000000000000000000_0100101100_01001011; // 300, 300 
			3'd5: value = {6'b0,10'd500,10'd500,10'b0011_1111_00};//36'b000000000000000000_1001011000_10010110; // 600, 600
			3'd6: value = {6'b0,10'd100,10'd100,10'b1111_1111_00};//36'b000000000000000000_0111110100_01111101; // 500, 500
			3'd7: value = {6'b0,10'd200,10'd200,10'b0011_1111_00};//36'b000000000000000000_0110010000_01100100; // 400, 400
			default: value = 0;
		endcase
endmodule
