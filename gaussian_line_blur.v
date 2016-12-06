`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:56:15 12/04/2016 
// Design Name: 
// Module Name:    gaussian_line_blur 
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
module gaussian_line_blur(
    input clk,
    input reset,
    input [2:0] fvh_in,
    input dv_in,
    output reg [2:0] fvh_out,
    output reg dv_out,
    input [7:0] px_in,
    output [7:0] blurred_px
    );
	parameter FILTER_SIZE = 11;
	parameter PX_DELAY = 6;
	parameter [6*FILTER_SIZE-1:0] COEFFS = {6'd23,6'd23,6'd23,6'd23,6'd23,6'd23,6'd23,6'd23,6'd23,6'd23,6'd23};
	
	reg [7:0] window [0:FILTER_SIZE-1];
	reg [2:0] fvh_buffer [0:PX_DELAY-1];
	reg [PX_DELAY-1:0] dv_buffer;
	integer i, k;
	reg [19:0] filter_sum;
	always @(posedge clk) begin
		fvh_buffer[PX_DELAY-1] <= fvh_in;
		dv_buffer[PX_DELAY-1] <= dv_in;
		for(k=0; k<PX_DELAY-1; k=k+1) begin
			fvh_buffer[k] <= fvh_buffer[k+1];
			dv_buffer[k] <= dv_buffer[k+1];
		end
		fvh_out[2:0] <= fvh_buffer[0];
		dv_out <= dv_buffer[0];
		
		window[FILTER_SIZE-1] <= px_in;
		for(i=0; i<FILTER_SIZE-1; i=i+1) begin
			window[i] <= window[i+1];
		end
		filter_sum = 
			COEFFS[1*6-1-:6]*window[0]+
			COEFFS[2*6-1-:6]*window[1]+
			COEFFS[3*6-1-:6]*window[2]+
			COEFFS[4*6-1-:6]*window[3]+
			COEFFS[5*6-1-:6]*window[4]+
			COEFFS[6*6-1-:6]*window[5]+
			COEFFS[7*6-1-:6]*window[6]+
			COEFFS[8*6-1-:6]*window[7]+
			COEFFS[9*6-1-:6]*window[8]+
			COEFFS[10*6-1-:6]*window[9]+
			COEFFS[11*6-1-:6]*window[10];
			
	end
	assign blurred_px = (filter_sum >> 'd8);
	//assign blurred_px = filter_sum;
endmodule
