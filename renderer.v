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
		input [10:0] x_offset,
		input [10:0] y_offset,
		input [8:0] angle,
		input [35:0] zbt0_read_data,
		output[18:0] zbt0_read_addr,
		output[9:0] x,
		output [9:0] y,
		output [7:0] pixel
    );
		reg [35:0] data;
		wire [9:0] z;
		reg [8+2:0] addr;
		wire signed [7:0] sin, cos;
		trigLUT lut(angle, sin, cos);
		always @(posedge clk) begin
			addr <= addr + 1;
			data <= (hcount[1:0]==2'd1) ? zbt0_read_data : data;
		end
		assign zbt0_read_addr = addr;
		wire signed [9:0] raw_x = data[29:20];
		wire signed [9:0] raw_z = data[9:0];
		wire signed [17:0] inter_x = cos*raw_x + sin*raw_z;
		wire signed [17:0] inter_z = sin*raw_x - cos*raw_z;
		assign x = inter_x[17:6] + {x_offset,3'b000};
		assign y = data[19:10] + {y_offset, 3'b000};
		assign z = (inter_z[17:6]+350);
		assign pixel = z[9:2];
endmodule
