`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:36:32 11/27/2016 
// Design Name: 
// Module Name:    zbt_controller 
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
module zbt_controller(
    clk,hcount,vcount,x,y,
	 zbtc_write_data,zbtc_write_addr
    );
	 input clk;
	 input [10:0] hcount;
	 input [9:0] 	vcount;
	 input [7:0] x;
	 input [9:0] y;
	 output [18:0] zbtc_write_addr;
	 output [35:0] zbtc_write_data;
	 
	 reg [18:0] addr;
	 
	 always @(posedge clk) begin
		addr <= (hcount[1:0]==2'd1) ? {y,x} : addr;
	 end
	 
	 assign zbtc_write_addr = addr;
	 assign zbtc_write_data = 'hFFFF_FFFF_F;
	 
	 
endmodule
