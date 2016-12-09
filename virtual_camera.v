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
	 input reset,
    input left,
    input right,
	 input up,
	 input down,
	 input rot_left,
	 input rot_right,
    output [10:0] x_offset,
	 output [10:0] y_offset,
	 output [8:0] angle
    );
	reg [24:0] counter = 0;
	// incrementer (clock, reset, inc, dec, step, init, max_value, value);
	incrementer inc1(clk,reset,right,left,1,300,1000,x_offset);
	incrementer inc2(clk,reset,down,up,1,300,1000,y_offset);
	incrementer inc3(clk,reset,rot_left,rot_right,5,0,355,angle);
endmodule
