`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:31:07 12/04/2016 
// Design Name: 
// Module Name:    skeletonize 
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
module skeletonize(clk, reset, fvh_in, dv_in, px_in, current_row, midpoint);
   input wire clk, reset, dv_in;
	input wire [2:0] fvh_in;
	input wire [7:0] px_in;
	output reg [8:0] current_row;
	output reg [9:0] midpoint;
	
	parameter S_WHITE_BLOCK = 2'b00;
	parameter S_WHITE_NOISE = 2'b01;
	parameter S_BLACK = 2'b10;
	
	parameter BLACK = 8'h00;
	parameter WHITE = 8'hFF;
	
	parameter NOISE_TOLERANCE = 3;
	
	reg [2:0] last_fvh;
	
	reg [9:0] max_length;
	reg [9:0] current_length;
	reg [9:0] max_idx;
	reg [9:0] current_idx;
	reg [9:0] current_start_idx;
	reg [9:0] current_end_idx;
	reg [2:0] state;
	reg [2:0] last_state;
	reg [2:0] noise_counter;
	assign new_frame = ~last_fvh[1] && fvh_in[1];
	assign new_line = ~last_fvh[0] && fvh_in[0];
	reg first_row;
	always @(posedge clk) begin
		last_fvh[2:0] <= fvh_in;
		last_state <= state;
		// See whether this is first row to output current_row properly
		if(reset || new_frame) first_row <= 1;
		if(new_line && first_row) first_row <= 0; 
		
		// Reinitialize all variables on each new line/frame
		// Reinitialize all variables on each new line/frame
		if (reset || new_frame || new_line) begin
			max_length <= 0;
			current_length <= 0;
			max_idx <= 0;
			current_idx <= 0;
			current_start_idx <= 0;
			current_end_idx <= 0;
			state <= S_BLACK;
			if (new_line) begin
				current_row <= (first_row) ? 0 : current_row+1;
				// Output the midpoint column
				if (current_end_idx - current_start_idx > max_length) begin
					midpoint <= (current_end_idx + current_start_idx)%2 == 0 ? 
									((current_end_idx + current_start_idx) >> 1) : ((current_end_idx + current_start_idx + 1) >> 1);
				end
				else midpoint <= max_idx;
			end
		end
		else begin
			current_idx <= current_idx + 1;
			case(state)
				S_WHITE_BLOCK: begin
					if (px_in == BLACK) begin
						state <= S_WHITE_NOISE;
						noise_counter <= 1;
					end
					else if (px_in == WHITE) begin
						current_length <= current_length + 1;
						current_end_idx <= current_idx;
					end
				end 
				S_WHITE_NOISE: begin
					if (px_in == BLACK) begin
						noise_counter <= noise_counter + 1;
						if(noise_counter >= NOISE_TOLERANCE) begin
							state <= S_BLACK;
							// Record the chain of whites we just ended
							if (current_end_idx - current_start_idx > max_length) begin
								max_length <= current_end_idx - current_start_idx + 1;
								max_idx <= (current_end_idx + current_start_idx)%2 == 0 ? 
									((current_end_idx + current_start_idx) >> 1) : ((current_end_idx + current_start_idx + 1) >> 1);
							end
						end
					end
					else if (px_in == WHITE) begin 
						state <= S_WHITE_BLOCK;
						current_length <= current_length + noise_counter + 1; // fill in noisy pixels
						current_end_idx <= current_idx;
					end
				end
				S_BLACK: begin
					if (px_in == BLACK) state <= S_BLACK;
					else if (px_in == WHITE) begin
						state <= S_WHITE_BLOCK;
						current_start_idx <= current_idx;
						current_end_idx <= current_idx;
						current_length <= 1;
					end
				end
			endcase
		end
	end
endmodule
