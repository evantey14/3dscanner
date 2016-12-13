module depth_reconstruction(clk, px_x, px_y, worldpt1, worldpt2, worldpt3, pt_done);
		input wire clk;
		input wire signed [11:0] px_x;
		input wire signed [11:0] px_y;
		
		output  signed [12:0] worldpt1;
		output  signed [12:0] worldpt2;
		output  signed [12:0] worldpt3;
		output  pt_done;
		
		parameter DECIMAL_FACTOR = 36'd64; // multiply by this to preserve decimal points, then divide later
		parameter DECIMAL_FACTOR_BITS = 6;

	  // -- CALIBRATION PARAMETERS --
	  // INTRINSICS
	  // inv(KK) = [0.0013    0       -0.4891
	  //            0         0.0014  -0.3624
	  //            0         0       1.0000]
		parameter iKK11_num = 36'sd343;
		parameter iKK11_den = 36'sd18;
		//parameter iKK12     = 0;
		parameter iKK13_num = -36'sd512818;
		parameter iKK13_den = 36'sd20;
		//parameter iKK21     = 0;
		parameter iKK22_num = 36'sd181;
		parameter iKK22_den = 36'sd17;
		parameter iKK23_num = -36'sd189987;
		parameter iKK23_den = 36'sd19;
		
	  // EXTRINSICS
	  parameter img_w = 720;
	  parameter img_h = 508;

	  // inv(Rc) = [-.0679    .9811   -.1813
	  //            .9977     .0663   -.0148
	  //            -.0025    -.1819  -.9833]
		parameter iRc11_num = -36'sd35587;
		parameter iRc11_den = 36'sd19; 
		parameter iRc12_num = 36'sd8037;
		parameter iRc12_den = 36'sd13;
		parameter iRc13_num = -36'sd23765;
		parameter iRc13_den = 36'sd17;
		parameter iRc21_num = 36'sd8173;
		parameter iRc21_den = 36'sd13;
		parameter iRc22_num = 36'sd69509;
		parameter iRc22_den = 36'sd20;
		parameter iRc23_num = -36'sd1941;
		parameter iRc23_den = 36'sd17;
		parameter iRc31_num = -36'sd1317;
		parameter iRc31_den = 36'sd19;
		parameter iRc32_num = -36'sd745;
		parameter iRc32_den = 36'sd12;
		parameter iRc33_num = -36'sd128885;
		parameter iRc33_den = 36'sd17;

		parameter Tc1_num = 36'sd15122;
		parameter Tc1_numDEC = 36'sd967808;
		parameter Tc1_den = 36'sd12;
		parameter Tc2_num = -36'sd9015;
		parameter Tc2_numDEC = -36'sd576960;
		parameter Tc2_den = 36'sd7;
		parameter Tc3_num = 36'sd15569;
		parameter Tc3_numDEC = 36'sd996416;
		parameter Tc3_den = 36'sd6;

		// num = nT * inv(Rc) * Tc = -1812.8
		// den = nT * inv(Rc) * inv(KK) = [-0.0005    0.0069   -7.6026]
		// lambda = calc_num/(calc_den*u)
		parameter calc_num_num = -36'sd29005;
		parameter calc_num_den = 36'sd4;
		parameter calc_den1_num = -36'sd9;
		parameter calc_den1_den = 36'sd14;
		parameter calc_den2_num = 36'sd1802;
		parameter calc_den2_den = 36'sd18;
		parameter calc_den3_num = -36'sd973;
		parameter calc_den3_den = 36'sd7;
		parameter signed den1_numDEC = -36'sd576;
		parameter signed den2_numDEC = 36'sd115328;
		parameter signed den3_numDEC = -36'sd62272;
	  
		// CALCULATION
		wire signed [35:0] x_CAM;
		wire signed [35:0] y_CAM;
		wire signed [35:0] z_CAM;
		assign x_CAM = px_x;
		assign y_CAM = {24'b0,px_y};
		assign z_CAM = 1;

		wire signed [35:0] x_comp =  ((x_CAM * den1_numDEC) >>> calc_den1_den);
		wire signed [35:0] y_comp =  ((y_CAM * den2_numDEC) >>> calc_den2_den);
		wire signed [35:0] z_comp =  ((den3_numDEC) >>> calc_den3_den);

		// lambda_den and calc_num_num are shifted by log2_(DECIMAL_FACTOR) bits to preserve decimal points
		wire signed [35:0] lambda_den = z_comp + y_comp + x_comp;
		wire signed [35:0] calc_num_num_SHIFTED = calc_num_num * 'd512; 
		// vv---- ONE DECIMAL_FACTOR TOO BIG ----vv  
		
		reg [35:0] last_lambda_den;
		always @(posedge clk) last_lambda_den <= lambda_den;
		wire divider_start = lambda_den - last_lambda_den <= 1;
		reg started, last_div_start;
		always @(posedge clk) begin
			last_div_start <= divider_start;
			if (~last_div_start && divider_start) started <= 1;
		end
		wire signed [35:0] lambda_quotient;
		wire [35:0] remainder; // ** Note we drop the remainder
		wire divider_done;
		divider #(.WIDTH(36)) divider(.clk(clk), .sign(1), .start(divider_start),
										.dividend(calc_num_num_SHIFTED), .divider(lambda_den),
										.quotient(lambda_quotient), .remainder(remainder),
										.ready(divider_done));
		wire signed [35:0] lambda = lambda_quotient >>> calc_num_den;
		
		wire signed [35:0] x_CAMlambda, y_CAMlambda, z_CAMlambda;
		wire signed [35:0] iKKCAMlambda1, iKKCAMlambda2, iKKCAMlambda3;
		wire signed [35:0] worldpt_prod1, worldpt_prod2, worldpt_prod3;


		assign div_d = divider_done;
		assign div_s = divider_start;
		assign x_CAMlambda = x_CAM * lambda;
		assign y_CAMlambda = y_CAM * lambda;
		assign z_CAMlambda = z_CAM * lambda;

		assign iKKCAMlambda1 = ((iKK11_num * x_CAMlambda) >>> (iKK11_den)) + //iKK12 = 0
									  ((iKK13_num * z_CAMlambda) >>> (iKK13_den));
		assign iKKCAMlambda2 = ((iKK22_num * y_CAMlambda) >>> (iKK22_den)) + //iKK21 = 0
									  ((iKK23_num * z_CAMlambda) >>> (iKK23_den));
		assign iKKCAMlambda3 = (z_CAMlambda); //iKK31, iKK32 = 0


		assign worldpt_prod1 = (((iKKCAMlambda1 << Tc1_den) - Tc1_numDEC) >>> Tc1_den);
		assign worldpt_prod2 = (((iKKCAMlambda2 << Tc2_den) - Tc2_numDEC) >>> Tc2_den);
		assign worldpt_prod3 = (((iKKCAMlambda3 << Tc3_den) - Tc3_numDEC) >>> Tc3_den);


		// vv---- CORRECTED DECIMAL_FACTOR ----vv
		assign worldpt1 = (((worldpt_prod1 * iRc11_num) >>> iRc11_den) + 
							 ((worldpt_prod2 * iRc12_num) >>> iRc12_den) +
							 ((worldpt_prod3 * iRc13_num) >>> iRc13_den)) >>> 3; // truncates to lower 12 bits auto.
		assign worldpt2 = (((worldpt_prod1 * iRc21_num) >>> iRc21_den) +
							 ((worldpt_prod2 * iRc22_num) >>> iRc22_den) +
							 ((worldpt_prod3 * iRc23_num) >>> iRc23_den)) >>> 3;
		assign worldpt3 = (((worldpt_prod1 * iRc31_num) >>> iRc31_den) +
							 ((worldpt_prod2 * iRc32_num) >>> iRc32_den) +
							 ((worldpt_prod3 * iRc33_num) >>> iRc33_den)) >>> 3;
		assign pt_done = 0;
		

		//pt_done <= 1;
		//end
		//end
endmodule
