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
    clk,hcount,vcount,x,y,pixel,
	 zbtc_write_data,zbtc_write_addr
    );
	 input clk;
	 input [10:0] hcount;
	 input [9:0] 	vcount;
	 input [9:0] x;
	 input [9:0] y;
	 input [7:0] pixel;
	 output reg [18:0] zbtc_write_addr;
	 output reg [35:0] zbtc_write_data;
	 
	 reg [18:0] addr;
	 
	 always @(posedge clk) begin
		zbtc_write_addr <= (hcount[1:0]==2'd1) ? {y,x[9:2]} : addr;
		zbtc_write_data <= pixel;
	 end
	 
	 //assign zbtc_write_addr = addr;
	 //assign zbtc_write_data = pixel;//{4'b0,pixel,pixel,pixel,pixel};
	 //assign zbtc_write_data = 36'hFFFF_FFFF_FF;
endmodule
