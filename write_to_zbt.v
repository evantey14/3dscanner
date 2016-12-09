`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:42:00 11/27/2016 
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
	input wire [8:0] index,
	output reg [35:0] value
    );
	 always @(index)
		case (index)
5'd0: value = {6'b0,-10'd100,-10'd100,-10'd100};
5'd1: value = {6'b0,-10'd100,-10'd100,10'd0};
5'd2: value = {6'b0,-10'd100,-10'd100,10'd100};
5'd3: value = {6'b0,-10'd100,10'd0,-10'd100};
5'd4: value = {6'b0,-10'd100,10'd0,10'd0};
5'd5: value = {6'b0,-10'd100,10'd0,10'd100};
5'd6: value = {6'b0,-10'd100,10'd100,-10'd100};
5'd7: value = {6'b0,-10'd100,10'd100,10'd0};
5'd8: value = {6'b0,-10'd100,10'd100,10'd100};
5'd9: value = {6'b0,10'd0,-10'd100,-10'd100};
5'd10: value = {6'b0,10'd0,-10'd100,10'd0};
5'd11: value = {6'b0,10'd0,-10'd100,10'd100};
5'd12: value = {6'b0,10'd0,10'd0,-10'd100};
5'd13: value = {6'b0,10'd0,10'd0,10'd0};
5'd14: value = {6'b0,10'd0,10'd0,10'd100};
5'd15: value = {6'b0,10'd0,10'd100,-10'd100};
5'd16: value = {6'b0,10'd0,10'd100,10'd0};
5'd17: value = {6'b0,10'd0,10'd100,10'd100};
5'd18: value = {6'b0,10'd100,-10'd100,-10'd100};
5'd19: value = {6'b0,10'd100,-10'd100,10'd0};
5'd20: value = {6'b0,10'd100,-10'd100,10'd100};
5'd21: value = {6'b0,10'd100,10'd0,-10'd100};
5'd22: value = {6'b0,10'd100,10'd0,10'd0};
5'd23: value = {6'b0,10'd100,10'd0,10'd100};
5'd24: value = {6'b0,10'd100,10'd100,-10'd100};
5'd25: value = {6'b0,10'd100,10'd100,10'd0};
5'd26: value = {6'b0,10'd100,10'd100,10'd100};
5'd27: value = {6'b0,10'd300,10'd100,10'd100};
5'd28: value = {6'b0,10'd300,-10'd100,10'd100};
5'd29: value = {6'b0,10'd300,10'd100,-10'd100};
5'd30: value = {6'b0,10'd300,-10'd100,-10'd100};
			default: value = 0;
		endcase
endmodule
