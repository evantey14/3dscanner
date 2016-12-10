`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:43:15 12/10/2016 
// Design Name: 
// Module Name:    save_frame 
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
module save_frame(
		input clk,
		input reset,
		input capture,
		input vsync,
		output reg latch
    );
	reg old_capture, old_vsync, ready, running;
	always @(posedge clk) begin
		old_capture <= capture;
		old_vsync <= vsync;
		if (reset) ready <= 0;
		if (~old_capture && capture) ready <= 1;
		if (ready) begin
			if (~old_vsync && vsync && running) begin // ending vsync
				ready <= 0;
				running <= 0;
				latch <= 0;
			end
			else if (~old_vsync && vsync && ~running) begin // starting vsync
				ready <= 1;
				running <= 1;
				latch <= 1;
			end
		end
	end

endmodule
