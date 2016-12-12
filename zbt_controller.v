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
	 zbtc_write_data,zbtc_write_addr,
	 zbtc_read_addr,zbtc_read_data,px_out
    );
	 input clk;
	 input [10:0] hcount;
	 input [9:0] 	vcount;
	 input [9:0] x;
	 input [9:0] y;
	 input [7:0] pixel;
	 output [18:0] zbtc_write_addr;
	 output reg [35:0] zbtc_write_data;
	 output [18:0] zbtc_read_addr;
	 input [35:0] zbtc_read_data;
	 output [7:0] px_out;
	 
	 wire [18:0] addr; 
	 reg [18:0] old_addr;
	 
//	 always @(posedge clk) begin
//		addr <= (hcount[1:0]==2'd3) ? {y,x[9:2]} : addr;
//		//zbtc_write_data <= {4'b0,pixel,pixel,pixel,pixel};
//		old_addr <= (hcount[1:0]==2'd3) ? addr : old_addr;
//	 end
	reg [7:0] old_pixel; 
	wire [35:0] zbt_pixel = zbtc_read_data;
	wire [1:0] idx;
	reg [1:0] old_idx;
	always @(posedge clk) begin
		//zbt_pixel <= (hcount[1:0]==2'd2) ? zbtc_read_data[7:0] : zbt_pixel;
		old_pixel <= (hcount[1:0]==2'd2) ? pixel : old_pixel;
		old_addr <= (hcount[1:0]==2'd2) ? addr : old_addr;
		old_idx <= (hcount[1:0]==2'd2) ? idx : old_idx;
	end
	 assign addr = {y,x[9:2]};
	 assign idx = x[1:0];
	 
	 //assign zbtc_write_data = old_pixel>zbt_pixel? {4'b0,old_pixel,old_pixel,old_pixel,old_pixel} : {4'b0,zbt_pixel,zbt_pixel,zbt_pixel,zbt_pixel} ;
	 always @(*) begin
		case (old_idx)
			2'd0:  zbtc_write_data = old_pixel > zbt_pixel[31:24] ? {4'b0,old_pixel,zbt_pixel[23:0]}: zbt_pixel;
			2'd1:  zbtc_write_data = old_pixel > zbt_pixel[23:16] ? {4'b0,zbt_pixel[31:24],old_pixel,zbt_pixel[15:0]}: zbt_pixel;
			2'd2:  zbtc_write_data = old_pixel > zbt_pixel[15:8] ? {4'b0,zbt_pixel[31:16],old_pixel,zbt_pixel[7:0]}: zbt_pixel;
			2'd3:  zbtc_write_data = old_pixel > zbt_pixel[7:0] ? {4'b0,zbt_pixel[31:8],old_pixel}: zbt_pixel;
		endcase
	 end
	 assign zbtc_write_addr = old_addr;
	 assign zbtc_read_addr = addr;
	 //assign zbtc_write_data = pixel;//{4'b0,pixel,pixel,pixel,pixel};
	 //assign zbtc_write_data = 36'hFFFF_FFFF_FF;
endmodule
