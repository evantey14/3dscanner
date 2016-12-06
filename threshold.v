`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:28:29 11/28/2016 
// Design Name: 
// Module Name:    threshold 
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

// temporary thresholding module
// if data in < 127, set to 0, if > 127, set to 255
// pass field, vertical, horizontal, and data_valid values associated with the pixel
module threshold(clk, fvh_in, dv_in, fvh_out, dv_out, din, dout);
	input clk;
	input [2:0] fvh_in;
	input dv_in;
	output reg [2:0] fvh_out;
	output reg dv_out; 
	input [7:0] din; 
	output reg [7:0] dout; 
	always @(posedge clk) begin
		dout <= (din > 8'b0011_1111) ? 8'b1111_1111 : 8'b0000_0000;
		fvh_out <= fvh_in;
		dv_out <= dv_in;
	end
endmodule
