`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:06:30 11/28/2016 
// Design Name: 
// Module Name:    gaussian_blurrer 
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
module gaussian_blurrer #(parameter PX_WIDTH=8, FILTER_SIZE=25)
		(clk,reset,fvh_in,dv_in,fvh_out,dv_out,lines,px_blurred,done);
	 
	input clk,reset,fvh_in,dv_in;
	output fvh_out,dv_out; // pass through
	input [PX_WIDTH-1:0] lines [0:FILTER_SIZE-1], // format(seq): [line1 px1-5][line2 px1-5] ... 
	output reg [PX_WIDTH-1:0] px_blurred;
	output reg done;
	 
	parameter [6:0] COEFFS [0:FILTER_SIZE-1] = '{'d24,'d35,'d39,'d35,'d24,
																			'd35,'d50,'d57,'d50,'d35,
																			'd39,'d57,'d64,'d57,'d39,
																			'd35,'d50,'d57,'d50,'d35,
																			'd24,'d35,'d39,'d35,'d24};
	reg [19:0] sum;
	reg [6:0] idx;

	// Convolve Gaussian filter with lines
	always @(posedge clk) begin
		if(reset) idx <= 0;
		else if(idx < FILTER_SIZE)begin
			idx <= idx+1;
			sum <= sum + COEFFS[idx]*lines[idx];
		end
		else if(idx == FILTER_SIZE) begin
			px_blurred <= (sum >> 'd10);
			done <= 1;
		end
	end
endmodule
