`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:19:08 12/08/2016 
// Design Name: 
// Module Name:    incrementer 
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
module incrementer(
		input clk,
		input reset,
		input increment,
		input decrement,
		input [9:0] step,
		input [10:0] init,
		input [10:0] max_val,
		output reg [10:0] value
    );
		reg [23:0] counter = 0;
		always @(posedge clk) begin
			if (reset) value <= init;
			if (increment) begin
			end
			if (increment) begin
				if (counter == 0) value <= value + step > max_val ? 0 : value + step;
				counter <= counter + 1;
			end
			if (decrement) begin
				if (counter == 0) value <= value < step ? max_val : value - step;
				counter <= counter + 1;
			end
		end

endmodule
