`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:48:07 12/07/2016 
// Design Name: 
// Module Name:    write_to_zbt 
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
module write_to_zbt(
		input wire clk,
		input wire reset,
		input wire point_ready_pulse,
		input wire [10:0] x,
		input wire [10:0] y,
		output reg [18:0] write_addr,
		output reg [35:0] write_data,
		output reg [18:0] max_zbt_addr // largest ZBT address we've written to
    );
	 
	reg [10:0] point;
	reg [2:0] counter;
	reg last_point_ready_pulse;
	always @(posedge clk) begin
		last_point_ready_pulse <= point_ready_pulse;
		if(reset) write_addr <= 0;
		max_zbt_addr <= (write_addr > max_zbt_addr) ? write_addr : max_zbt_addr; 
		if(point_ready_pulse && ~last_point_ready_pulse) begin
			write_addr <= write_addr + 1;
			write_data <= {6'b0,x,y,10'b1111_1111_00};
		end
	end
endmodule
