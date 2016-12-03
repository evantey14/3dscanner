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
    output reg [5:0] camera_offset
    );
	initial camera_offset = 0;
	always @(posedge clk) begin
		if (left) camera_offset <= camera_offset + 'd63;
		else if (right) camera_offset <= camera_offset + 1;
	end
endmodule
