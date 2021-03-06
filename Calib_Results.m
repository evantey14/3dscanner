% Intrinsic and Extrinsic Camera Parameters
%
% This script file can be directly executed under Matlab to recover the camera intrinsic and extrinsic parameters.
% IMPORTANT: This file contains neither the structure of the calibration objects nor the image coordinates of the calibration points.
%            All those complementary variables are saved in the complete matlab data file Calib_Results.mat.
% For more information regarding the calibration model visit http://www.vision.caltech.edu/bouguetj/calib_doc/


%-- Focal length:
fc = [ 764.374026547320000 ; 723.786878984221858 ];

%-- Principal point:
cc = [ 373.826457477544466 ; 262.279719819997865 ];

%-- Skew coefficient:
alpha_c = 0.000000000000000;

%-- Distortion coefficients:
kc = [ -0.415528250181453 ; 1.406896515272318 ; -0.006657309979862 ; -0.000645283068385 ; 0.000000000000000 ];

%-- Focal length uncertainty:
fc_error = [ 8.414040132242336 ; 8.276105574313227 ];

%-- Principal point uncertainty:
cc_error = [ 11.854486381564545 ; 10.885057693453513 ];

%-- Skew coefficient uncertainty:
alpha_c_error = 0.000000000000000;

%-- Distortion coefficients uncertainty:
kc_error = [ 0.062089311399748 ; 0.423412075892276 ; 0.003505633784443 ; 0.003138867869896 ; 0.000000000000000 ];

%-- Image size:
nx = 720;
ny = 508;


%-- Various other variables (may be ignored if you do not use the Matlab Calibration Toolbox):
%-- Those variables are used to control which intrinsic parameters should be optimized

n_ima = 24;						% Number of calibration images
est_fc = [ 1 ; 1 ];					% Estimation indicator of the two focal variables
est_aspect_ratio = 1;				% Estimation indicator of the aspect ratio fc(2)/fc(1)
center_optim = 1;					% Estimation indicator of the principal point
est_alpha = 0;						% Estimation indicator of the skew coefficient
est_dist = [ 1 ; 1 ; 1 ; 1 ; 0 ];	% Estimation indicator of the distortion coefficients


%-- Extrinsic parameters:
%-- The rotation (omc_kk) and the translation (Tc_kk) vectors for every calibration image and their uncertainties

%-- Image #1:
omc_1 = [ -1.720428e+00 ; -2.136291e+00 ; 3.636277e-01 ];
Tc_1  = [ -3.325785e+01 ; -1.004537e+02 ; 4.937005e+02 ];
omc_error_1 = [ 1.644220e-02 ; 1.941307e-02 ; 3.318373e-02 ];
Tc_error_1  = [ 7.765140e+00 ; 7.447325e+00 ; 5.756094e+00 ];

%-- Image #2:
omc_2 = [ 1.463370e+00 ; 1.734235e+00 ; -4.840024e-01 ];
Tc_2  = [ -6.311839e+01 ; -7.869957e+01 ; 3.163794e+02 ];
omc_error_2 = [ 1.144650e-02 ; 1.509823e-02 ; 1.786198e-02 ];
Tc_error_2  = [ 4.994813e+00 ; 4.752752e+00 ; 3.721630e+00 ];

%-- Image #3:
omc_3 = [ 1.845273e+00 ; 1.681208e+00 ; -2.126250e-01 ];
Tc_3  = [ -6.505499e+01 ; -6.313868e+01 ; 3.609842e+02 ];
omc_error_3 = [ 1.321621e-02 ; 1.410909e-02 ; 2.198503e-02 ];
Tc_error_3  = [ 5.678119e+00 ; 5.433248e+00 ; 4.536439e+00 ];

%-- Image #4:
omc_4 = [ -1.216269e+00 ; -2.421945e+00 ; 9.081688e-01 ];
Tc_4  = [ 1.175727e+01 ; -1.068415e+02 ; 4.316998e+02 ];
omc_error_4 = [ 1.382133e-02 ; 1.504371e-02 ; 2.359004e-02 ];
Tc_error_4  = [ 6.788916e+00 ; 6.510223e+00 ; 4.631061e+00 ];

%-- Image #5:
omc_5 = [ -1.870473e+00 ; -2.201596e+00 ; -5.699466e-01 ];
Tc_5  = [ -3.736791e+01 ; -7.420368e+01 ; 2.862056e+02 ];
omc_error_5 = [ 1.176071e-02 ; 1.839364e-02 ; 2.815083e-02 ];
Tc_error_5  = [ 4.542192e+00 ; 4.350141e+00 ; 4.008507e+00 ];

%-- Image #6:
omc_6 = [ 1.983390e+00 ; 1.315377e+00 ; 1.062878e+00 ];
Tc_6  = [ -8.132939e+01 ; -4.212584e+01 ; 3.070199e+02 ];
omc_error_6 = [ 1.691947e-02 ; 1.047006e-02 ; 1.999860e-02 ];
Tc_error_6  = [ 5.001279e+00 ; 4.730961e+00 ; 4.973520e+00 ];

%-- Image #7:
omc_7 = [ -1.609982e+00 ; -1.952658e+00 ; 7.166068e-01 ];
Tc_7  = [ -1.001310e+01 ; -9.899761e+01 ; 4.292753e+02 ];
omc_error_7 = [ 1.461456e-02 ; 1.336987e-02 ; 2.331756e-02 ];
Tc_error_7  = [ 6.756810e+00 ; 6.476491e+00 ; 4.478485e+00 ];

%-- Image #8:
omc_8 = [ 9.972170e-01 ; 2.264824e+00 ; -8.848848e-01 ];
Tc_8  = [ -1.983613e+00 ; -8.605383e+01 ; 4.060365e+02 ];
omc_error_8 = [ 9.912784e-03 ; 1.734940e-02 ; 2.008502e-02 ];
Tc_error_8  = [ 6.376497e+00 ; 6.124407e+00 ; 4.178720e+00 ];

%-- Image #9:
omc_9 = [ 1.488906e+00 ; 1.558728e+00 ; -8.253273e-01 ];
Tc_9  = [ -7.941409e+01 ; -6.497954e+01 ; 3.615059e+02 ];
omc_error_9 = [ 1.219309e-02 ; 1.603579e-02 ; 1.747577e-02 ];
Tc_error_9  = [ 5.695332e+00 ; 5.485778e+00 ; 3.956379e+00 ];

%-- Image #10:
omc_10 = [ 1.337865e+00 ; 1.595551e+00 ; -3.505644e-02 ];
Tc_10  = [ -6.580482e+01 ; -7.940498e+01 ; 4.092775e+02 ];
omc_error_10 = [ 1.299261e-02 ; 1.496776e-02 ; 1.756791e-02 ];
Tc_error_10  = [ 6.440044e+00 ; 6.180399e+00 ; 5.335821e+00 ];

%-- Image #11:
omc_11 = [ -1.849340e+00 ; -1.071667e+00 ; 6.715544e-01 ];
Tc_11  = [ -3.204757e+01 ; -7.234449e+01 ; 5.861960e+02 ];
omc_error_11 = [ 1.658110e-02 ; 1.144125e-02 ; 2.033417e-02 ];
Tc_error_11  = [ 9.163344e+00 ; 8.837281e+00 ; 6.346672e+00 ];

%-- Image #12:
omc_12 = [ 2.668642e+00 ; 1.452878e+00 ; 3.931900e-03 ];
Tc_12  = [ -7.546856e+01 ; -6.709084e+00 ; 4.038022e+02 ];
omc_error_12 = [ 2.610419e-02 ; 1.413913e-02 ; 5.000207e-02 ];
Tc_error_12  = [ 6.343566e+00 ; 6.124024e+00 ; 5.889157e+00 ];

%-- Image #13:
omc_13 = [ -7.826763e-01 ; -2.552461e+00 ; 1.012271e+00 ];
Tc_13  = [ 4.085729e+01 ; -1.125898e+02 ; 5.202448e+02 ];
omc_error_13 = [ 1.329545e-02 ; 1.708811e-02 ; 2.407457e-02 ];
Tc_error_13  = [ 8.168712e+00 ; 7.863104e+00 ; 5.960764e+00 ];

%-- Image #14:
omc_14 = [ -1.667213e+00 ; -2.229615e+00 ; 1.924762e-01 ];
Tc_14  = [ -6.854314e+01 ; -8.351464e+01 ; 3.761911e+02 ];
omc_error_14 = [ 1.663614e-02 ; 2.127976e-02 ; 3.576429e-02 ];
Tc_error_14  = [ 5.978428e+00 ; 5.720106e+00 ; 4.760872e+00 ];

%-- Image #15:
omc_15 = [ -2.349855e+00 ; -1.306488e+00 ; -1.602113e-01 ];
Tc_15  = [ -1.124913e+02 ; -3.640228e+01 ; 4.843088e+02 ];
omc_error_15 = [ 2.128612e-02 ; 1.403056e-02 ; 3.485041e-02 ];
Tc_error_15  = [ 7.592368e+00 ; 7.363707e+00 ; 6.030311e+00 ];

%-- Image #16:
omc_16 = [ 2.365784e+00 ; 1.381699e+00 ; 1.442290e+00 ];
Tc_16  = [ -8.206189e+01 ; -4.410860e+01 ; 5.041767e+02 ];
omc_error_16 = [ 2.178795e-02 ; 1.106813e-02 ; 2.578351e-02 ];
Tc_error_16  = [ 8.026501e+00 ; 7.682014e+00 ; 7.746496e+00 ];

%-- Image #17:
omc_17 = [ 1.873753e+00 ; 9.208315e-01 ; 9.796723e-02 ];
Tc_17  = [ -1.564150e+02 ; -3.433021e+01 ; 5.402961e+02 ];
omc_error_17 = [ 1.515394e-02 ; 1.416076e-02 ; 1.973677e-02 ];
Tc_error_17  = [ 8.521140e+00 ; 8.326096e+00 ; 8.554695e+00 ];

%-- Image #18:
omc_18 = [ -1.867220e+00 ; -1.533221e+00 ; -1.238085e+00 ];
Tc_18  = [ -5.946688e+01 ; -2.207424e+01 ; 3.413551e+02 ];
omc_error_18 = [ 1.289537e-02 ; 1.732469e-02 ; 2.148672e-02 ];
Tc_error_18  = [ 5.353632e+00 ; 5.171716e+00 ; 4.736593e+00 ];

%-- Image #19:
omc_19 = [ -1.368682e+00 ; -2.595380e+00 ; 8.982690e-01 ];
Tc_19  = [ -3.692681e+01 ; -1.222092e+02 ; 4.078144e+02 ];
omc_error_19 = [ 1.542947e-02 ; 1.424840e-02 ; 2.562931e-02 ];
Tc_error_19  = [ 6.498530e+00 ; 6.183186e+00 ; 4.509472e+00 ];

%-- Image #20:
omc_20 = [ 1.776611e+00 ; 2.267024e+00 ; -6.679258e-01 ];
Tc_20  = [ -1.701646e+01 ; -9.399825e+01 ; 4.122408e+02 ];
omc_error_20 = [ 1.185384e-02 ; 1.680079e-02 ; 2.708518e-02 ];
Tc_error_20  = [ 6.487953e+00 ; 6.165400e+00 ; 4.596326e+00 ];

%-- Image #21:
omc_21 = [ 1.695162e+00 ; 1.988768e+00 ; -3.768629e-01 ];
Tc_21  = [ -9.540556e+01 ; -9.882505e+01 ; 3.593383e+02 ];
omc_error_21 = [ 1.023616e-02 ; 1.564602e-02 ; 2.154912e-02 ];
Tc_error_21  = [ 5.682587e+00 ; 5.462550e+00 ; 4.488362e+00 ];

%-- Image #22:
omc_22 = [ -2.146719e+00 ; -1.558056e+00 ; -7.054058e-01 ];
Tc_22  = [ -1.207837e+02 ; -3.893661e+01 ; 3.876983e+02 ];
omc_error_22 = [ 1.643214e-02 ; 1.530610e-02 ; 2.629718e-02 ];
Tc_error_22  = [ 6.100480e+00 ; 5.980813e+00 ; 5.502195e+00 ];

%-- Image #23:
omc_23 = [ 2.634891e+00 ; 8.930266e-01 ; 7.233929e-01 ];
Tc_23  = [ 1.424636e+00 ; 2.063497e+00 ; 3.773244e+02 ];
omc_error_23 = [ 1.960868e-02 ; 8.014122e-03 ; 2.682740e-02 ];
Tc_error_23  = [ 5.931698e+00 ; 5.693596e+00 ; 5.577111e+00 ];

%-- Image #24:
omc_24 = [ 2.224013e+00 ; 9.876143e-01 ; 6.987518e-01 ];
Tc_24  = [ -7.756857e+01 ; -3.446492e+01 ; 3.254557e+02 ];
omc_error_24 = [ 1.698373e-02 ; 1.015579e-02 ; 2.129093e-02 ];
Tc_error_24  = [ 5.182442e+00 ; 4.963016e+00 ; 4.982065e+00 ];

