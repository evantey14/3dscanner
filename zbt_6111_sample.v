//
// File:   zbt_6111_sample.v
// Date:   26-Nov-05
// Author: I. Chuang <ichuang@mit.edu>
//
// Sample code for the MIT 6.111 labkit demonstrating use of the ZBT
// memories for video display.  Video input from the NTSC digitizer is
// displayed within an XGA 1024x768 window.  One ZBT memory (ram0) is used
// as the video frame buffer, with 8 bits used per pixel (black & white).
//
// Since the ZBT is read once for every four pixels, this frees up time for 
// data to be stored to the ZBT during other pixel times.  The NTSC decoder
// runs at 27 MHz, whereas the XGA runs at 65 MHz, so we synchronize
// signals between the two (see ntsc2zbt.v) and let the NTSC data be
// stored to ZBT memory whenever it is available, during cycles when
// pixel reads are not being performed.
//
// We use a very simple ZBT interface, which does not involve any clock
// generation or hiding of the pipelining.  See zbt_6111.v for more info.
//
// switch[7] selects between display of NTSC video and test bars
// switch[6] is used for testing the NTSC decoder
// switch[1] selects between test bar periods; these are stored to ZBT
//           during blanking periods
// switch[0] selects vertical test bars (hardwired; not stored in ZBT)
//
//
// Bug fix: Jonathan P. Mailoa <jpmailoa@mit.edu>
// Date   : 11-May-09
//
// Use ramclock module to deskew clocks;  GPH
// To change display from 1024*787 to 800*600, use clock_40mhz and change
// accordingly. Verilog ntsc2zbt.v will also need changes to change resolution.
//
// Date   : 10-Nov-11

///////////////////////////////////////////////////////////////////////////////
//
// 6.111 FPGA Labkit -- Template Toplevel Module
//
// For Labkit Revision 004
//
//
// Created: October 31, 2004, from revision 003 file
// Author: Nathan Ickes
//
///////////////////////////////////////////////////////////////////////////////
//
// CHANGES FOR BOARD REVISION 004
//
// 1) Added signals for logic analyzer pods 2-4.
// 2) Expanded "tv_in_ycrcb" to 20 bits.
// 3) Renamed "tv_out_data" to "tv_out_i2c_data" and "tv_out_sclk" to
//    "tv_out_i2c_clock".
// 4) Reversed disp_data_in and disp_data_out signals, so that "out" is an
//    output of the FPGA, and "in" is an input.
//
// CHANGES FOR BOARD REVISION 003
//
// 1) Combined flash chip enables into a single signal, flash_ce_b.
//
// CHANGES FOR BOARD REVISION 002
//
// 1) Added SRAM clock feedback path input and output
// 2) Renamed "mousedata" to "mouse_data"
// 3) Renamed some ZBT memory signals. Parity bits are now incorporated into 
//    the data bus, and the byte write enables have been combined into the
//    4-bit ram#_bwe_b bus.
// 4) Removed the "systemace_clock" net, since the SystemACE clock is now
//    hardwired on the PCB to the oscillator.
//
///////////////////////////////////////////////////////////////////////////////
//
// Complete change history (including bug fixes)
//
// 2011-Nov-10: Changed resolution to 1024 * 768.
//					 Added back ramclok to deskew RAM clock
//
// 2009-May-11: Fixed memory management bug by 8 clock cycle forecast. 
//              Changed resolution to  800 * 600.
//              Reduced clock speed to 40MHz.
//              Disconnected zbt_6111's ram_clk signal. 
//              Added ramclock to control RAM.
//              Added notes about ram1 default values.
//              Commented out clock_feedback_out assignment.
//              Removed delayN modules because ZBT's latency has no more effect.
//
// 2005-Sep-09: Added missing default assignments to "ac97_sdata_out",
//              "disp_data_out", "analyzer[2-3]_clock" and
//              "analyzer[2-3]_data".
//
// 2005-Jan-23: Reduced flash address bus to 24 bits, to match 128Mb devices
//              actually populated on the boards. (The boards support up to
//              256Mb devices, with 25 address lines.)
//
// 2004-Oct-31: Adapted to new revision 004 board.
//
// 2004-May-01: Changed "disp_data_in" to be an output, and gave it a default
//              value. (Previous versions of this file declared this port to
//              be an input.)
//
// 2004-Apr-29: Reduced SRAM address busses to 19 bits, to match 18Mb devices
//              actually populated on the boards. (The boards support up to
//              72Mb devices, with 21 address lines.)
//
// 2004-Apr-29: Change history started
//
///////////////////////////////////////////////////////////////////////////////

module zbt_6111_sample(beep, audio_reset_b, 
		       ac97_sdata_out, ac97_sdata_in, ac97_synch,
	       ac97_bit_clock,
	       
	       vga_out_red, vga_out_green, vga_out_blue, vga_out_sync_b,
	       vga_out_blank_b, vga_out_pixel_clock, vga_out_hsync,
	       vga_out_vsync,

	       tv_out_ycrcb, tv_out_reset_b, tv_out_clock, tv_out_i2c_clock,
	       tv_out_i2c_data, tv_out_pal_ntsc, tv_out_hsync_b,
	       tv_out_vsync_b, tv_out_blank_b, tv_out_subcar_reset,

	       tv_in_ycrcb, tv_in_data_valid, tv_in_line_clock1,
	       tv_in_line_clock2, tv_in_aef, tv_in_hff, tv_in_aff,
	       tv_in_i2c_clock, tv_in_i2c_data, tv_in_fifo_read,
	       tv_in_fifo_clock, tv_in_iso, tv_in_reset_b, tv_in_clock,

	       ram0_data, ram0_address, ram0_adv_ld, ram0_clk, ram0_cen_b,
	       ram0_ce_b, ram0_oe_b, ram0_we_b, ram0_bwe_b, 

	       ram1_data, ram1_address, ram1_adv_ld, ram1_clk, ram1_cen_b,
	       ram1_ce_b, ram1_oe_b, ram1_we_b, ram1_bwe_b,

	       clock_feedback_out, clock_feedback_in,

	       flash_data, flash_address, flash_ce_b, flash_oe_b, flash_we_b,
	       flash_reset_b, flash_sts, flash_byte_b,

	       rs232_txd, rs232_rxd, rs232_rts, rs232_cts,

	       mouse_clock, mouse_data, keyboard_clock, keyboard_data,

	       clock_27mhz, clock1, clock2,

	       disp_blank, disp_data_out, disp_clock, disp_rs, disp_ce_b,
	       disp_reset_b, disp_data_in,

	       button0, button1, button2, button3, button_enter, button_right,
	       button_left, button_down, button_up,

	       switch,

	       led,
	       
	       user1, user2, user3, user4,
	       
	       daughtercard,

	       systemace_data, systemace_address, systemace_ce_b,
	       systemace_we_b, systemace_oe_b, systemace_irq, systemace_mpbrdy,
	       
	       analyzer1_data, analyzer1_clock,
 	       analyzer2_data, analyzer2_clock,
 	       analyzer3_data, analyzer3_clock,
 	       analyzer4_data, analyzer4_clock);

   output beep, audio_reset_b, ac97_synch, ac97_sdata_out;
   input  ac97_bit_clock, ac97_sdata_in;
   
   output [7:0] vga_out_red, vga_out_green, vga_out_blue;
   output vga_out_sync_b, vga_out_blank_b, vga_out_pixel_clock,
	  vga_out_hsync, vga_out_vsync;

   output [9:0] tv_out_ycrcb;
   output tv_out_reset_b, tv_out_clock, tv_out_i2c_clock, tv_out_i2c_data,
	  tv_out_pal_ntsc, tv_out_hsync_b, tv_out_vsync_b, tv_out_blank_b,
	  tv_out_subcar_reset;
   
   input  [19:0] tv_in_ycrcb;
   input  tv_in_data_valid, tv_in_line_clock1, tv_in_line_clock2, tv_in_aef,
	  tv_in_hff, tv_in_aff;
   output tv_in_i2c_clock, tv_in_fifo_read, tv_in_fifo_clock, tv_in_iso,
	  tv_in_reset_b, tv_in_clock;
   inout  tv_in_i2c_data;
        
   inout  [35:0] ram0_data;
   output [18:0] ram0_address;
   output ram0_adv_ld, ram0_clk, ram0_cen_b, ram0_ce_b, ram0_oe_b, ram0_we_b;
   output [3:0] ram0_bwe_b;
   
   inout  [35:0] ram1_data;
   output [18:0] ram1_address;
   output ram1_adv_ld, ram1_clk, ram1_cen_b, ram1_ce_b, ram1_oe_b, ram1_we_b;
   output [3:0] ram1_bwe_b;

   input  clock_feedback_in;
   output clock_feedback_out;
   
   inout  [15:0] flash_data;
   output [23:0] flash_address;
   output flash_ce_b, flash_oe_b, flash_we_b, flash_reset_b, flash_byte_b;
   input  flash_sts;
   
   output rs232_txd, rs232_rts;
   input  rs232_rxd, rs232_cts;

   input  mouse_clock, mouse_data, keyboard_clock, keyboard_data;

   input  clock_27mhz, clock1, clock2;

   output disp_blank, disp_clock, disp_rs, disp_ce_b, disp_reset_b;  
   input  disp_data_in;
   output  disp_data_out;
   
   input  button0, button1, button2, button3, button_enter, button_right,
	  button_left, button_down, button_up;
   input  [7:0] switch;
   output [7:0] led;

   inout [31:0] user1, user2, user3, user4;
   
   inout [43:0] daughtercard;

   inout  [15:0] systemace_data;
   output [6:0]  systemace_address;
   output systemace_ce_b, systemace_we_b, systemace_oe_b;
   input  systemace_irq, systemace_mpbrdy;

   output [15:0] analyzer1_data, analyzer2_data, analyzer3_data, 
		 analyzer4_data;
   output analyzer1_clock, analyzer2_clock, analyzer3_clock, analyzer4_clock;

   ////////////////////////////////////////////////////////////////////////////
   //
   // I/O Assignments
   //
   ////////////////////////////////////////////////////////////////////////////
   
   // Audio Input and Output
   assign beep= 1'b0;
   assign audio_reset_b = 1'b0;
   assign ac97_synch = 1'b0;
   assign ac97_sdata_out = 1'b0;
/*
*/
   // ac97_sdata_in is an input

   // Video Output
   assign tv_out_ycrcb = 10'h0;
   assign tv_out_reset_b = 1'b0;
   assign tv_out_clock = 1'b0;
   assign tv_out_i2c_clock = 1'b0;
   assign tv_out_i2c_data = 1'b0;
   assign tv_out_pal_ntsc = 1'b0;
   assign tv_out_hsync_b = 1'b1;
   assign tv_out_vsync_b = 1'b1;
   assign tv_out_blank_b = 1'b1;
   assign tv_out_subcar_reset = 1'b0;
   
   // Video Input
   //assign tv_in_i2c_clock = 1'b0;
   assign tv_in_fifo_read = 1'b1;
   assign tv_in_fifo_clock = 1'b0;
   assign tv_in_iso = 1'b1;
   //assign tv_in_reset_b = 1'b0;
   assign tv_in_clock = clock_27mhz;//1'b0;
   //assign tv_in_i2c_data = 1'bZ;
   // tv_in_ycrcb, tv_in_data_valid, tv_in_line_clock1, tv_in_line_clock2, 
   // tv_in_aef, tv_in_hff, and tv_in_aff are inputs
   
   // SRAMs

/* change lines below to enable ZBT RAM bank0 */

/*
   assign ram0_data = 36'hZ;
   assign ram0_address = 19'h0;
   assign ram0_clk = 1'b0;
   assign ram0_we_b = 1'b1;
   assign ram0_cen_b = 1'b0;	// clock enable
*/

/* enable RAM pins */

   assign ram0_ce_b = 1'b0;
   assign ram0_oe_b = 1'b0;
   assign ram0_adv_ld = 1'b0;
   assign ram0_bwe_b = 4'h0; 

/**********/
/*
   assign ram1_data = 36'hZ; 
   assign ram1_address = 19'h0;
   assign ram1_clk = 1'b0;
   assign ram1_we_b = 1'b1;
   assign ram1_cen_b = 1'b1;
*/	
   //These values has to be set to 0 like ram0 if ram1 is used.
   
   assign ram1_ce_b = 1'b0;
   assign ram1_oe_b = 1'b0;
   assign ram1_adv_ld = 1'b0;
   assign ram1_bwe_b = 4'h0;

   // clock_feedback_out will be assigned by ramclock
   // assign clock_feedback_out = 1'b0;  //2011-Nov-10
   // clock_feedback_in is an input
   
   // Flash ROM
   assign flash_data = 16'hZ;
   assign flash_address = 24'h0;
   assign flash_ce_b = 1'b1;
   assign flash_oe_b = 1'b1;
   assign flash_we_b = 1'b1;
   assign flash_reset_b = 1'b0;
   assign flash_byte_b = 1'b1;
   // flash_sts is an input

   // RS-232 Interface
  //assign rs232_txd = 1'b1;
   assign rs232_rts = 1'b1;
   // rs232_rxd and rs232_cts are inputs

   // PS/2 Ports
   // mouse_clock, mouse_data, keyboard_clock, and keyboard_data are inputs

   // LED Displays
/*
   assign disp_blank = 1'b1;
   assign disp_clock = 1'b0;
   assign disp_rs = 1'b0;
   assign disp_ce_b = 1'b1;
   assign disp_reset_b = 1'b0;
   assign disp_data_out = 1'b0;
*/
   // disp_data_in is an input

   // Buttons, Switches, and Individual LEDs
   //lab3 assign led = 8'hFF;
   // button0, button1, button2, button3, button_enter, button_right,
   // button_left, button_down, button_up, and switches are inputs

   // User I/Os
   //assign user1 = 32'hZ;
   assign user2 = 32'hZ;
   assign user3 = 32'hZ;
   assign user4 = 32'hZ;

   // Daughtercard Connectors
   assign daughtercard = 44'hZ;

   // SystemACE Microprocessor Port
   assign systemace_data = 16'hZ;
   assign systemace_address = 7'h0;
   assign systemace_ce_b = 1'b1;
   assign systemace_we_b = 1'b1;
   assign systemace_oe_b = 1'b1;
   // systemace_irq and systemace_mpbrdy are inputs

   // Logic Analyzer
   assign analyzer1_data = 16'h0;
   assign analyzer1_clock = 1'b1;
   assign analyzer2_data = 16'h0;
   assign analyzer2_clock = 1'b1;
   assign analyzer3_data = 16'h0;
   assign analyzer3_clock = 1'b1;
   assign analyzer4_data = 16'h0;
   assign analyzer4_clock = 1'b1;
			    
 /*  ////////////////////////////////////////////////////////////////////////////
   // Demonstration of ZBT RAM as video memory

   // use FPGA's digital clock manager to produce a
   // 65MHz clock (actually 64.8MHz)
   wire clock_65mhz_unbuf,clock_65mhz;
   DCM vclk1(.CLKIN(clock_27mhz),.CLKFX(clock_65mhz_unbuf));
   // synthesis attribute CLKFX_DIVIDE of vclk1 is 10
   // synthesis attribute CLKFX_MULTIPLY of vclk1 is 24
   // synthesis attribute CLK_FEEDBACK of vclk1 is NONE
   // synthesis attribute CLKIN_PERIOD of vclk1 is 37
   BUFG vclk2(.O(clock_65mhz),.I(clock_65mhz_unbuf));

//   wire clk = clock_65mhz;  // gph 2011-Nov-10

 */
 ////////////////////////////////////////////////////////////////////////////
   // Demonstration of ZBT RAM as video memory

   // use FPGA's digital clock manager to produce a
   // 40MHz clock (actually 40.5MHz)
   wire clock_40mhz_unbuf,clock_40mhz;
   DCM vclk1(.CLKIN(clock_27mhz),.CLKFX(clock_40mhz_unbuf));
   // synthesis attribute CLKFX_DIVIDE of vclk1 is 2
   // synthesis attribute CLKFX_MULTIPLY of vclk1 is 3
   // synthesis attribute CLK_FEEDBACK of vclk1 is NONE
   // synthesis attribute CLKIN_PERIOD of vclk1 is 37
   BUFG vclk2(.O(clock_40mhz),.I(clock_40mhz_unbuf));

 //  wire clk = clock_40mhz;

	wire locked;
	//assign clock_feedback_out = 0; // gph 2011-Nov-10
	
	parameter IMG_WIDTH = 680;
	parameter IMG_HEIGHT = 480;
   
	// clock for interfacing with RAM
   ramclock rc(.ref_clock(clock_40mhz), .fpga_clock(clk),
					.ram0_clock(ram0_clk), 
					.ram1_clock(ram1_clk),   //uncomment if ram1 is used
					.clock_feedback_in(clock_feedback_in),
					.clock_feedback_out(clock_feedback_out), .locked(locked));

   
   // power-on reset generation
   wire power_on_reset;    // remain high for first 16 clocks
   SRL16 reset_sr (.D(1'b0), .CLK(clk), .Q(power_on_reset),
		   .A0(1'b1), .A1(1'b1), .A2(1'b1), .A3(1'b1));
   defparam reset_sr.INIT = 16'hFFFF;

   // ENTER button is user reset
   wire reset,user_reset;
   debounce db1(power_on_reset, clk, ~button_enter, user_reset);
   assign reset = user_reset | power_on_reset;

	// PAN and ROTATE buttons for virtual camera
	wire left, right, up, down, rot_left, rot_right;
	debounce db2(reset, clk, ~button_left, left);
	debounce db3(reset, clk, ~button_right, right);
	debounce db4(reset, clk, ~button_up, up);
	debounce db5(reset, clk, ~button_down, down);
	debounce db6(reset, clk, ~button1, rot_left);
	debounce db7(reset, clk, ~button0, rot_right);

	// BUTTON 3 for frame capture
	wire capture;
	debounce db8(reset, clk, ~button3, capture);
	
	// BUTTON0 for saving frames / sending to PC
	wire save;
	debounce db9(reset, clk, ~button2, save);
   
	// display module for debugging
	
   reg [63:0] dispdata;
   display_16hex hexdisp1(reset, clk, dispdata,
			  disp_blank, disp_clock, disp_rs, disp_ce_b,
			  disp_reset_b, disp_data_out);

   // generate basic XVGA video signals
   wire [10:0] hcount;
   wire [9:0]  vcount;
   wire hsync,vsync,blank;
   xvga xvga1(clk,hcount,vcount,hsync,vsync,blank);

   // instantiate ZBT RAM
   wire [35:0] zbt0_write_data, zbt1_write_data;
   wire [35:0] zbt0_read_data, zbt1_read_data;
   wire [18:0] zbt0_addr, zbt1_addr;
   wire        zbt0_we, zbt1_we;

   wire ram0_clk_not_used;
   zbt_6111 zbt0(clk, 1'b1, zbt0_we, zbt0_addr,
		   zbt0_write_data, zbt0_read_data,
		   ram0_clk_not_used,   //to get good timing, don't connect ram_clk to zbt_6111
		   ram0_we_b, ram0_address, ram0_data, ram0_cen_b);
	
	wire ram1_clk_not_used;
	zbt_6111 zbt1(clk, 1'b1, zbt1_we, zbt1_addr,
		   zbt1_write_data, zbt1_read_data,
		   ram1_clk_not_used,   //to get good timing, don't connect ram_clk to zbt_6111
		   ram1_we_b, ram1_address, ram1_data, ram1_cen_b);
	
   // ADC7185 NTSC decoder initialization module
   adv7185init adv7185(.reset(reset), .clock_27mhz(clock_27mhz), 
		       .source(1'b0), .tv_in_reset_b(tv_in_reset_b), 
		       .tv_in_i2c_clock(tv_in_i2c_clock), 
		       .tv_in_i2c_data(tv_in_i2c_data));

   // NTSC data stream decoder
	// takes tv_in_ycrcb and translates it to ycrcb, fvh, and dv per pixel
	wire [29:0] ycrcb;	// video data (luminance, chrominance)
	wire [2:0] fvh;	// sync for field, vertical, horizontal
   wire       dv;	// data valid
   ntsc_decode decode (.clk(tv_in_line_clock1), .reset(reset),
		       .tv_in_ycrcb(tv_in_ycrcb[19:10]), 
		       .ycrcb(ycrcb), .f(fvh[2]),
		       .v(fvh[1]), .h(fvh[0]), .data_valid(dv));
	
	// Gaussian Blur
	// Pass pixels through 3 Gaussian line blurs to decrease noise
	
	wire [2:0] fvh_blur;
	wire dv_blur;
	wire [7:0] blurred_px;
	gaussian_line_blur gaussian_blur(.clk(tv_in_line_clock1),.reset(reset),
										.fvh_in(fvh),.dv_in(dv),
										.fvh_out(fvh_blur),.dv_out(dv_blur),
										.px_in(ycrcb[29:22]),.blurred_px(blurred_px));
									
	wire [2:0] fvh_blur2;
	wire dv_blur2;
	wire [7:0] blurred_px2;
	gaussian_line_blur gaussian_blur2(.clk(tv_in_line_clock1),.reset(reset),
										.fvh_in(fvh_blur),.dv_in(dv_blur),
										.fvh_out(fvh_blur2),.dv_out(dv_blur2),
										.px_in(blurred_px),.blurred_px(blurred_px2));
	
	wire [2:0] fvh_blur3;
	wire dv_blur3;
	wire [7:0] blurred_px3;
	gaussian_line_blur gaussian_blur3(.clk(tv_in_line_clock1),.reset(reset),
										.fvh_in(fvh_blur2),.dv_in(dv_blur2),
										.fvh_out(fvh_blur3),.dv_out(dv_blur3),
										.px_in(blurred_px2),.blurred_px(blurred_px3));
	
	// Threshold
	// Floor / Ceiling pixel grayscale values to indicate lack / presence of laser line
	// passes fvh and dv with the associated pixels (for display)
	wire [7:0] thresholded_px;
	wire [2:0] fvh_thresh;
	wire dv_thresh;
	wire [7:0] thresholdv;
	incrementer inc1(clk,reset,up&switch[5],down&switch[5],2,50,255,thresholdv);
	threshold threshold (.clk(tv_in_line_clock1),.thresholdv(thresholdv),.fvh_in(fvh_blur3),.dv_in(dv_blur3),
				.fvh_out(fvh_thresh),.dv_out(dv_thresh),
				.din(blurred_px3),.dout(thresholded_px));
	
	// NTSC to ZBT
	// used for testing preprocessing
	// stores thresholded pixel stream into zbt0 for vga dislpay
	// outputs ntsc_addr, ntsc_data, and ntsc_we (which will get assigned to zbt0 parameters)
   wire [18:0] ntsc_addr;
   wire [35:0] ntsc_data;
   wire        ntsc_we;
   ntsc_to_zbt n2z (clk, tv_in_line_clock1, fvh_thresh, dv_thresh, thresholded_px,
		    ntsc_addr, ntsc_data, ntsc_we, 0);
	
	// Skeletonize
	// goes through each line of pixels and outputs the midpoint of the laser line
	// outputs current_row, midpoint, and asserts row_done at the end of a row
	wire [9:0] current_row;
	wire [9:0] midpoint;
	wire row_done;
	wire first_row;
	skeletonize skeletonize (.clk(tv_in_line_clock1),.reset(reset),
										.fvh_in(fvh_thresh),.dv_in(dv_thresh),
										.px_in(thresholded_px),.current_row(current_row),
										.midpoint(midpoint),.row_done(row_done), .first_row(first_row));

//DEBUGGING
//reg [10:0] last_current_row, last_midpoint;
//	reg [6:0] skel_counter;
//	reg [10:0] skel_max;
//	reg row_change, midpoint_change;
//	wire row_change_wire = last_current_row != current_row;
//	always @(posedge clk) begin
//		last_current_row <= current_row;
//		last_midpoint <= midpoint;
//		if (last_current_row != current_row) begin
//			skel_counter <= skel_counter+1;
//			row_change <= 1;
//		end
//		else row_change <= 0;
//		if (last_midpoint != midpoint) begin
//			midpoint_change <= 1;
//		end
//		else midpoint_change <= 0;
//	end


	// Depth Reconstruction
	wire [12:0] depth_x, depth_y, depth_z;
	wire pt_done;
	wire [35:0] outval;
	wire div_d, div_s;
	
	depth_reconstruction depth_reconstruction(.clk(clk),
										.px_x(500),.px_y(500),
										.worldpt1(depth_x),.worldpt2(depth_y),
										.worldpt3(depth_z),.pt_done(pt_done));
	
	// Save Frame
	// When capture is pressed, assert latch for the entire next vsync cycle
	// Latch should be anded into a later signal to allow data flow
	wire latch;
	save_frame save_frame(.clk(clk),.reset(reset),.capture(capture),
									.vsync(vsync),.latch(latch));
	
	// Write to ZBT
	// insert module here
	wire we = switch[6];
	wire [18:0] write_addr;
	wire [35:0] write_data_raw;
	wire [35:0] write_data = write_data_raw & {36{latch}};
	wire [18:0] w2z_max_zbt_addr;
	write_to_zbt w2z(.clk(clk), .reset(reset), 
							.point_ready_pulse(row_done & latch), .x(depth_y), 
							.y(depth_x), .write_addr(write_addr),
							.write_data(write_data_raw), .max_zbt_addr(w2z_max_zbt_addr));
	
	// Manually write to ZBT
	// Writes specified values to ZBT0
	wire [20:0] manual_write_addr;
	wire [35:0] manual_write_data;
	wire [18:0] size = 30;
	wire manual_we = switch[7]; // if 1, write directly into ZBT0, else use camera
	manual_write_to_zbt mw2z(clk, size, manual_write_addr, manual_write_data);
	
//////////////// ABOVE: storing into ZBT0 //////////////// BELOW: storing into ZBT1 ////////////////
	
	// Virtual Camera
	// simulate the monitor as a camera
	// take in user input and convert to a virtual camera offset	
	wire [10:0] x_offset, y_offset;
	wire [8:0] angle;
	virtual_camera vc(clk, reset, left, right, (up&~switch[5]), (down&~switch[5]), rot_left, rot_right, x_offset, y_offset, angle);

	// 3D Renderer
	// takes 3D points from ZBT0 and transform them into the monitor
	wire [20:0] renderer_read_addr;
	wire [9:0] x;
	wire [9:0] y;
	wire [7:0] renderer_pixel;
	wire [18:0] render_max_zbt_addr;
	assign render_max_zbt_addr = we ? w2z_max_zbt_addr : manual_we ? 'd30 : 18'h3FFFF;
	renderer rend(clk, hcount, vcount, x_offset, y_offset, angle,
			zbt0_read_data, render_max_zbt_addr, renderer_read_addr, x, y, renderer_pixel);
	
	// ZBT Controller
	// takes 2D monitor points, writes them to ZBT1
	wire [18:0] zbtc_read_addr; // address of data we want from ZBT0 (will be moved to 3D renderer or just changed to a counter)
	wire [18:0] zbtc_write_addr; // ZBT1 address we're writing data to 
	wire [35:0] zbtc_write_data; // pixel data we're writing into ZBT1
	wire [7:0] px_out;
	zbt_controller zbtc(clk, hcount, vcount, x, y, renderer_pixel,
			zbtc_write_data, zbtc_write_addr, zbtc_read_addr, zbt1_read_data, px_out);
	
   // VRAM
	// reads line from ZBT1 and outputs separated vr_pixel values
   wire [7:0] 	vr_pixel;
   wire [18:0] 	vram_read_addr;
	wire [35:0] 	vram_read_data = we||manual_we? zbt1_read_data: zbt0_read_data; // write from camera if not manual
   vram_display vd1(reset,clk,hcount,vcount,vr_pixel,vram_read_addr, vram_read_data); 

	// Blackout
	// Set all ZBT1 values to 0
	// Run whenever camera offset changes
	reg blackout_start; // signals the start of a blackout when camera offset changes
	reg [10:0] old_x_offset, old_y_offset;
	reg [8:0] old_angle;
	always @(posedge clk) begin
		if (old_angle != angle || old_x_offset != x_offset || old_y_offset != y_offset) blackout_start <= 1;
		else blackout_start <= 0;
		old_x_offset <= x_offset;
		old_y_offset <= y_offset;
		old_angle <= angle;
	end
	reg blackout; // boolean controller for zbt param decision. 1 during a blackout
	wire blackout_data = 0;
	reg [23:0] blackout_addr;
	always @(posedge clk) begin
		if (blackout_start) begin
			blackout <= 1;
			blackout_addr <= 0;
		end
		else begin
			if (blackout_addr == 23'hFFFFFF) blackout <= 0;
			blackout_addr <= blackout_addr + 1;
		end 	
	end
	
	// RS232 transmit image to PC
	// when user presses button0, lock the frame in ZBT0
	reg frame_lock = 0;
	reg old_frame_lock = 0;
	always @(posedge clk) frame_lock <= reset ? 0 : (frame_lock==0 && save==1) ? 1 : frame_lock;
	reg [10:0] rs232_addrh = 0;
	reg [9:0] rs232_addrv = 0;
	wire [18:0] rs232_addr = {1'b0, rs232_addrv, rs232_addrh[9:2]};
	reg [7:0] rs_232_px;
	reg [35:0] rs_232_data;
	
	
	reg [1:0] px_state = 0;	
	parameter S_READ = 2'b0;
	parameter S_DELAY = 2'b1;
	parameter S_SEND = 2'b10;
	reg [1:0] read_state = S_READ;
	
	reg send;
	reg [13:0] counter;
	parameter max_count = 14'hFFFFF;
	
	always @(posedge clk) begin
		old_frame_lock <= frame_lock;
		case (read_state)
			S_READ:
				begin
					if (frame_lock) begin 
						//rs232_addr <= rs232_addr + 1;
						if (rs232_addrv <= 767) begin
							if (rs232_addrh >= 1020) begin
								rs232_addrh <= 0;
								rs232_addrv <= rs232_addrv + 1;
							end
							else begin
								rs232_addrh <= rs232_addrh + 4;
							end
							read_state <= S_DELAY;
							counter <= 0;
						end
					
					end
				end
			S_DELAY:
				begin
					read_state <= S_SEND;
				end
			S_SEND:
				begin
					case (px_state) 
						0: 
							begin
								rs_232_px <= zbt0_read_data[7:0];
								if (counter == 0) send <= 1;
								else if (counter == max_count) px_state <= 1;
								else send <= 0;
								counter <= counter + 1;
							end
						1:
							begin
								rs_232_px <= zbt0_read_data[31:24];
								if (counter == 0) send <= 1;
								else if (counter == max_count) px_state <= 2;
								else send <= 0;
								counter <= counter + 1;
							end
						2:
							begin
								rs_232_px <= zbt0_read_data[23:16];
								if (counter == 0) send <= 1;
								else if (counter == max_count) px_state <= 3;
								else send <= 0;
								counter <= counter + 1;
							end
						3:
							begin
								rs_232_px <= zbt0_read_data[15:8];
								if (counter == 0) send <= 1;
								else if (counter == max_count) begin
									px_state <= 0;
									read_state <= S_READ;
								end
								else send <= 0;
								counter <= counter + 1;
							end
					endcase
				end
		endcase	
	end
	reg send_test = 0;
	reg [11:0] acounter = 0;
	always @(posedge clock_27mhz) begin
		if (acounter == 0) send_test<=1;
		else send_test <= 0;
		acounter <= acounter + 1;
	end
	wire [7:0] test_px = (rs232_addrh>200 && rs232_addrh<300) ? 8'd48 : 8'd117;
	rs232transmit sendx(clk, 0, rs_232_px, send, rs232_txd, xmit_clk, start_send);

	// Set ZBT params
   assign 	zbt0_addr = frame_lock? rs232_addr : zbt0_we ? (we ? write_addr : manual_we? manual_write_addr[20:2] : ntsc_addr) : (we ? renderer_read_addr[20:2] : manual_we ? renderer_read_addr[20:2] : vram_read_addr); 
   assign 	zbt0_we = frame_lock? 0 : hcount[1:0] == 2'd2;//manual_write? (skeletonize_we && (hcount[1:0]==2'd2)) : hcount[1:0]==2'd2; 
   assign 	zbt0_write_data = we ? write_data : manual_we ? manual_write_data : ntsc_data;
	
	assign 	zbt1_addr = blackout ? blackout_addr : (zbt1_we ? zbtc_write_addr : (hcount[1:0]==2'd0 ? zbtc_read_addr : vram_read_addr));
	assign 	zbt1_we = blackout ? blank : (hcount[1:0]==2'd2);
	assign 	zbt1_write_data = blackout ? blackout_data : zbtc_write_data;

   // select output pixel data

   reg [7:0] 	pixel;
   reg 	b,hs,vs;
   
   always @(posedge clk)
     begin
		//pixel <= switch[0] ? {hcount[8:6],5'b0} : vr_pixel;
		pixel <= vr_pixel;
		b <= blank;
		hs <= hsync;
		vs <= vsync;
     end

   // VGA Output.  In order to meet the setup and hold times of the
   // AD7125, we send it ~clk.
   assign vga_out_red = pixel;
   assign vga_out_green = pixel;
   assign vga_out_blue = pixel;
   assign vga_out_sync_b = 1'b1;    // not used
   assign vga_out_pixel_clock = ~clk;
   assign vga_out_blank_b = ~b;
   assign vga_out_hsync = hs;
   assign vga_out_vsync = vs;

   // debugging
   
	//assign user1[31] = row_done;
	assign user3[31] = clk;

  assign led = ~{zbt1_addr[18:13],reset,switch[0]};
//	always @(posedge clk) begin
//		dispdata <= {thresholdv,3'b0,angle,1'b0,y_offset,1'b0,x_offset,2'b0,w2z_max_zbt_addr};//,1'b0,write_addr
//	end

endmodule
