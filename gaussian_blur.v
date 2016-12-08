`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:55:40 11/30/2016 
// Design Name: 
// Module Name:    gaussian_blur 
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
module gaussian_blur #(parameter FILTER_SIZE=25, IMG_WIDTH=720)
		(clk,reset,fvh_in,dv_in,fvh_out,dv_out,px_in,blurred_px);
	 
	input wire clk,reset, dv_in;
	input wire [2:0] fvh_in;
	output reg [2:0] fvh_out;
	output reg dv_out; // pass through
	input wire [7:0] px_in;
	output wire [7:0] blurred_px;
	
	parameter FILTER_WIDTH = 5;
	parameter PX_DELAY = 2*IMG_WIDTH+2; //# clock cycles bw receiving a px and calculating the blurred version of it
	parameter [FILTER_SIZE*6-1:0] COEFFS = {6'd24,6'd35,6'd39,6'd35,6'd24,
																6'd35,6'd50,6'd57,6'd50,6'd35,
																6'd39,6'd57,6'd63,6'd57,6'd39,
																6'd35,6'd50,6'd57,6'd50,6'd35,
																6'd24,6'd35,6'd39,6'd35,6'd24};
	
	//parameter [FILTER_SIZE*6-1:0] COEFFS = {6'd0,6'd0,6'd0,6'd0,6'd0,
	//															6'd0,6'd0,6'd0,6'd0,6'd0,
	//															6'd51,6'd51,6'd51,6'd51,6'd51,
	//															6'd0,6'd0,6'd0,6'd0,6'd0,
	//															6'd0,6'd0,6'd0,6'd0,6'd0};
	reg [7:0] filter [0:24]; // top left to bottom right
	reg [7:0] line_buffer1 [0:IMG_WIDTH-FILTER_WIDTH-1];
	reg [7:0] line_buffer2 [0:IMG_WIDTH-FILTER_WIDTH-1];
	reg [7:0] line_buffer3 [0:IMG_WIDTH-FILTER_WIDTH-1];
	reg [7:0] line_buffer4 [0:IMG_WIDTH-FILTER_WIDTH-1];
	
	reg [2:0] fvh_buffer [0:PX_DELAY-1];
	reg dv_buffer [0:PX_DELAY-1];
	
	integer i, j, k, idx;
	reg [19:0] filter_sum;
	always @(posedge clk) begin
		// Delay fvh with the pixel it accompanies
		fvh_buffer[PX_DELAY-1] <= fvh_in;
		dv_buffer[PX_DELAY-1] <= dv_in;
		for(k=0; k<PX_DELAY-1; k=k+1) begin
			fvh_buffer[k] <= fvh_buffer[k+1];
			dv_buffer[k] <= dv_buffer[k+1];
		end
		fvh_out[2:0] <= fvh_buffer[0];
		dv_out <= dv_buffer[0];
		
		// Shift filter
		filter[24] <= px_in;
		for(i=0; i<'d24; i=i+1) begin
			case(i)
				4: filter[i] <= line_buffer1[0];
				9: filter[i] <= line_buffer2[0];
				14: filter[i] <= line_buffer3[0];
				19: filter[i] <= line_buffer4[0];
				default: filter[i] <= filter[i+1];
			endcase
		end
		
		// Shift line buffer
		line_buffer1[IMG_WIDTH-FILTER_WIDTH-1] <= filter[5];
		line_buffer2[IMG_WIDTH-FILTER_WIDTH-1] <= filter[10];
		line_buffer3[IMG_WIDTH-FILTER_WIDTH-1] <= filter[15];
		line_buffer4[IMG_WIDTH-FILTER_WIDTH-1] <= filter[20];
		for(j=0; j<IMG_WIDTH-FILTER_WIDTH-1; j=j+1) begin
			line_buffer1[j] <= line_buffer1[j+1];
			line_buffer2[j] <= line_buffer2[j+1];
			line_buffer3[j] <= line_buffer3[j+1];
			line_buffer4[j] <= line_buffer4[j+1];
		end
		
		filter_sum = 
			COEFFS[1*6-1-:6]*filter[0]+
			COEFFS[2*6-1-:6]*filter[1]+
			COEFFS[3*6-1-:6]*filter[2]+
			COEFFS[4*6-1-:6]*filter[3]+
			COEFFS[5*6-1-:6]*filter[4]+
			COEFFS[6*6-1-:6]*filter[5]+
			COEFFS[7*6-1-:6]*filter[6]+
			COEFFS[8*6-1-:6]*filter[7]+
			COEFFS[9*6-1-:6]*filter[8]+
			COEFFS[10*6-1-:6]*filter[9]+
			COEFFS[11*6-1-:6]*filter[10]+
			COEFFS[12*6-1-:6]*filter[11]+
			COEFFS[13*6-1-:6]*filter[12]+
			COEFFS[14*6-1-:6]*filter[13]+
			COEFFS[15*6-1-:6]*filter[14]+
			COEFFS[16*6-1-:6]*filter[15]+
			COEFFS[17*6-1-:6]*filter[16]+
			COEFFS[18*6-1-:6]*filter[17]+
			COEFFS[19*6-1-:6]*filter[18]+
			COEFFS[20*6-1-:6]*filter[19]+
			COEFFS[21*6-1-:6]*filter[20]+
			COEFFS[22*6-1-:6]*filter[21]+
			COEFFS[23*6-1-:6]*filter[22]+
			COEFFS[24*6-1-:6]*filter[23]+
			COEFFS[25*6-1-:6]*filter[24];
	end
	
	assign blurred_px = (filter_sum >> 'd8);
	//assign blurred_px = filter_sum;
endmodule
