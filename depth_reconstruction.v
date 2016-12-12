module depth_reconstruction(clk, px_x, px_y, worldpt1, worldpt2, worldpt3, pt_done);
		input wire clk;
		input wire signed [11:0] px_x;
		input wire signed [11:0] px_y;
		
		output reg signed [12:0] worldpt1;
		output reg signed [12:0] worldpt2;
		output reg signed [12:0] worldpt3;
		output reg pt_done;
		
		parameter DECIMAL_FACTOR = 64; // multiply by this to preserve decimal points, then divide later
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

		parameter Tc1_num = 36'sd30245;
		parameter Tc1_den = 36'sd13;
		parameter Tc2_num = -36'sd9015;
		parameter Tc2_den = 36'sd7;
		parameter Tc3_num = 36'sd31139;
		parameter Tc3_den = 36'sd7;

		// num = nT * inv(Rc) * Tc = -1812.8
		// den = nT * inv(Rc) * inv(KK) = [-0.0005    0.0069   -7.6026]
		// lambda = calc_num/(calc_den*u)
		parameter calc_num_num = -36'sd29005;
		parameter calc_num_den = 36'sd4;
		parameter calc_den1_num = -36'sd9;
		parameter calc_den1_den = 36'sd14;
		parameter calc_den2_num = 36'sd3605;
		parameter calc_den2_den = 36'sd19;
		parameter calc_den3_num = -36'sd62281;
		parameter calc_den3_den = 36'sd13;
	  
		// CALCULATION
		wire signed [11:0] x_CAM;
		wire signed [11:0] y_CAM;
		wire signed [11:0] z_CAM;
		assign x_CAM = px_x;
		assign y_CAM = px_y;
		assign z_CAM = 1;

		wire signed [35:0] temp = (calc_den1_num * x_CAM * DECIMAL_FACTOR);
		wire signed [35:0] temp2 =  (calc_den1_num * x_CAM * DECIMAL_FACTOR) >>> calc_den1_den;
		wire signed [35:0] temp3 = (calc_den2_num * y_CAM * DECIMAL_FACTOR);
		wire signed [35:0] temp4 =  (calc_den2_num * y_CAM * DECIMAL_FACTOR) >>> calc_den2_den;
		wire signed [35:0] temp5 = (calc_den3_num * z_CAM * DECIMAL_FACTOR);
		wire signed [35:0] temp6 =  (calc_den3_num * z_CAM * DECIMAL_FACTOR) >>> calc_den3_den;
		// lambda_den and calc_num_num are shifted by log2_(DECIMAL_FACTOR) bits to preserve decimal points
		wire signed [35:0] lambda_den = ((calc_den1_num * x_CAM * DECIMAL_FACTOR) >>> calc_den1_den) +
								((calc_den2_num * y_CAM * DECIMAL_FACTOR) >>> calc_den2_den) +
								((calc_den3_num * z_CAM * DECIMAL_FACTOR) >>> calc_den3_den);
		wire signed [35:0] calc_num_num_SHIFTED = calc_num_num * DECIMAL_FACTOR * DECIMAL_FACTOR; 
		
		// vv---- ONE DECIMAL_FACTOR TOO BIG ----vv  
		
		reg [35:0] last_lambda_den;
		always @(posedge clk) last_lambda_den <= lambda_den;
		assign divider_start = (last_lambda_den != lambda_den);
		wire [35:0] lambda_quotient;
		wire [35:0] remainder; // ** Note we drop the remainder
		wire divider_done;
		divider #(.WIDTH(36)) divider(.clk(clk), .sign(1), .start(divider_start),
										.dividend(calc_num_num_SHIFTED), .divider(lambda_den),
										.quotient(lambda_quotient), .remainder(remainder),
										.ready(divider_done));
		wire [35:0] lambda = lambda_quotient >>> calc_num_den;
		
		reg signed [35:0] x_CAMlambda, y_CAMlambda, z_CAMlambda;
		reg signed [35:0] iKKCAMlambda1, iKKCAMlambda2, iKKCAMlambda3;
		reg signed [35:0] worldpt_prod1, worldpt_prod2, worldpt_prod3;

		reg last_divider_done;
		assign divider_done_edge = ~last_divider_done && divider_done;
		
		always @(posedge clk) begin
			last_divider_done <= divider_done;
			if (divider_done_edge) begin
			x_CAMlambda = x_CAM * lambda;
			y_CAMlambda = y_CAM * lambda;
			z_CAMlambda = z_CAM * lambda;

			iKKCAMlambda1 = ((iKK11_num * x_CAMlambda) >>> (iKK11_den)) + //iKK12 = 0
										  ((iKK13_num * z_CAMlambda) >>> (iKK13_den));
			iKKCAMlambda2 = ((iKK22_num * y_CAMlambda) >>> (iKK22_den)) + //iKK21 = 0
										  ((iKK23_num * z_CAMlambda) >>> (iKK23_den));
			iKKCAMlambda3 = (z_CAMlambda); //iKK31, iKK32 = 0

			worldpt_prod1 = (((iKKCAMlambda1 << Tc1_den) - Tc1_num * DECIMAL_FACTOR) >>> Tc1_den);
			worldpt_prod2 = (((iKKCAMlambda2 << Tc2_den) - Tc2_num * DECIMAL_FACTOR) >>> Tc2_den);
			worldpt_prod3 = (((iKKCAMlambda3 << Tc3_den) - Tc3_num * DECIMAL_FACTOR) >>> Tc3_den);

			// vv---- CORRECTED DECIMAL_FACTOR ----vv
			worldpt1 = (((iRc11_num * worldpt_prod1) >>> iRc11_den) + 
								 ((iRc12_num * worldpt_prod2) >>> iRc12_den) +
								 ((iRc13_num * worldpt_prod3) >>> iRc13_den)) >>> DECIMAL_FACTOR_BITS; // truncates to lower 12 bits auto.
			worldpt2 = (((iRc21_num * worldpt_prod1) >>> iRc21_den) +
								 ((iRc22_num * worldpt_prod2) >>> iRc22_den) +
								 ((iRc23_num * worldpt_prod3) >>> iRc23_den)) >>> DECIMAL_FACTOR_BITS;
			worldpt3 = (((iRc31_num * worldpt_prod1) >>> iRc31_den) +
								 ((iRc32_num * worldpt_prod2) >>> iRc32_den) +
								 ((iRc33_num * worldpt_prod3) >>> iRc33_den)) >>> DECIMAL_FACTOR_BITS;
			end
		end
endmodule
