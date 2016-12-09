`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:37:54 12/03/2016 
// Design Name: 
// Module Name:    virtual_camera 
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
module virtual_camera(
    input clk,
    input left,
    input right,
	 input up,
	 input down,
	 input rot_left,
	 input rot_right,
    output reg [10:0] x_offset,
	 output reg [10:0] y_offset,
	 output reg [8:0] angle
    );
	initial x_offset = 300;
	initial y_offset = 300;
	initial angle = 0;
	reg old_left, old_right, old_up, old_down, old_rot_left, old_rot_right;
	always @(posedge clk) begin
			if (old_left == 0 && left == 1) x_offset <= x_offset + -10'd1;
			if (old_right == 0 && right == 1) x_offset <= x_offset + 1;
			if (old_up == 0 && up == 1) y_offset <= y_offset + -10'd1;
			if (old_down == 0 && down == 1) y_offset <= y_offset + 1;
			if (old_rot_left == 0 && rot_left == 1) angle <= angle + -10'd5;
			if (old_rot_right == 0 && rot_right == 1) angle <= angle + 5;
			old_left <= left;
			old_right <= right;
			old_up <= up;
			old_down <= down;
			old_rot_left <= rot_left;
			old_rot_right <= rot_right;
	end
endmodule
