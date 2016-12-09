`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:24:01 12/08/2016 
// Design Name: 
// Module Name:    trigLUT 
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
module trigLUT(
		input [8:0] angle,
		output reg [7:0] sin,
		output reg [7:0] cos
    );
		always @(*) begin
			case(angle)
				0: begin cos = 64; sin = 0; end
				5: begin cos = 64; sin = 6; end
				10: begin cos = 63; sin = 11; end
				15: begin cos = 62; sin = 17; end
				20: begin cos = 60; sin = 22; end
				25: begin cos = 58; sin = 27; end
				30: begin cos = 55; sin = 32; end
				35: begin cos = 52; sin = 37; end
				40: begin cos = 49; sin = 41; end
				45: begin cos = 45; sin = 45; end
				50: begin cos = 41; sin = 49; end
				55: begin cos = 37; sin = 52; end
				60: begin cos = 32; sin = 55; end
				65: begin cos = 27; sin = 58; end
				70: begin cos = 22; sin = 60; end
				75: begin cos = 17; sin = 62; end
				80: begin cos = 11; sin = 63; end
				85: begin cos = 6; sin = 64; end
				90: begin cos = 0; sin = 64; end
				95: begin cos = -6; sin = 64; end
				100: begin cos = -11; sin = 63; end
				105: begin cos = -17; sin = 62; end
				110: begin cos = -22; sin = 60; end
				115: begin cos = -27; sin = 58; end
				120: begin cos = -32; sin = 55; end
				125: begin cos = -37; sin = 52; end
				130: begin cos = -41; sin = 49; end
				135: begin cos = -45; sin = 45; end
				140: begin cos = -49; sin = 41; end
				145: begin cos = -52; sin = 37; end
				150: begin cos = -55; sin = 32; end
				155: begin cos = -58; sin = 27; end
				160: begin cos = -60; sin = 22; end
				165: begin cos = -62; sin = 17; end
				170: begin cos = -63; sin = 11; end
				175: begin cos = -64; sin = 6; end
				180: begin cos = -64; sin = 0; end
				185: begin cos = -64; sin = -6; end
				190: begin cos = -63; sin = -11; end
				195: begin cos = -62; sin = -17; end
				200: begin cos = -60; sin = -22; end
				205: begin cos = -58; sin = -27; end
				210: begin cos = -55; sin = -32; end
				215: begin cos = -52; sin = -37; end
				220: begin cos = -49; sin = -41; end
				225: begin cos = -45; sin = -45; end
				230: begin cos = -41; sin = -49; end
				235: begin cos = -37; sin = -52; end
				240: begin cos = -32; sin = -55; end
				245: begin cos = -27; sin = -58; end
				250: begin cos = -22; sin = -60; end
				255: begin cos = -17; sin = -62; end
				260: begin cos = -11; sin = -63; end
				265: begin cos = -6; sin = -64; end
				270: begin cos = 0; sin = -64; end
				275: begin cos = 6; sin = -64; end
				280: begin cos = 11; sin = -63; end
				285: begin cos = 17; sin = -62; end
				290: begin cos = 22; sin = -60; end
				295: begin cos = 27; sin = -58; end
				300: begin cos = 32; sin = -55; end
				305: begin cos = 37; sin = -52; end
				310: begin cos = 41; sin = -49; end
				315: begin cos = 45; sin = -45; end
				320: begin cos = 49; sin = -41; end
				325: begin cos = 52; sin = -37; end
				330: begin cos = 55; sin = -32; end
				335: begin cos = 58; sin = -27; end
				340: begin cos = 60; sin = -22; end
				345: begin cos = 62; sin = -17; end
				350: begin cos = 63; sin = -11; end
				355: begin cos = 64; sin = -6; end
			endcase
		end
endmodule
