`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:51:57 11/29/2016 
// Design Name: 
// Module Name:    renderer 
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
module renderer(
		input clk,
		input [10:0] hcount,
		input [9:0] vcount,
		input [35:0] zbt0_read_data,
		output[18:0] zbt0_read_addr,
		output[35:0] renderer_output_data
    );
		reg [35:0] data;
		reg [3:0] addr;
		always @(posedge clk) begin
			addr <= addr + 1;
			data <= (hcount[1:0]==2'd1) ? zbt0_read_data : data;
		end
		assign zbt0_read_addr = addr;
		assign renderer_output_data = data;
endmodule
