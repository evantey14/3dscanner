function world_coords_pol = depth_reconstruction(img_name)
    calib = load('./calib_imgs/Calib_Results.mat');
    % Tc = translation vector
    % Rc = rotationVectorToMatrix(omc);
    Rc = [ -0.067877 	 0.997691 	 -0.002512;
            0.981080 	 0.066289 	 -0.181899;
           -0.181312 	 -0.014811 	 -0.983314];
    Tc =  [3.692039; -70.430003; 243.274270];
    
    % -- Intrinsic matrix -- 
    KK = [calib.fc(1) calib.alpha_c*calib.fc(1) calib.cc(1);
          0           calib.fc(2)               calib.cc(2);
          0           0                         1];
    
    img = format_ntsc_img(img_name);
    px_coords = skeletonize(img);
    % -- Hard coded: transpose of normal to light plane for laser @ 40 deg
    % tan 40 = 1.2, one decimal pt of precis ion
    nT = [6 0 5];
    
    % lambda = num/(den*u)
    num = nT * inv(Rc) * Tc;
    den = nT * inv(Rc) * inv(KK);
    
    world_coords = zeros(size(px_coords,2), 3);
    world_coords_pol = zeros(size(px_coords,2), 3);
    for y = 1:size(px_coords,1)
        x = px_coords(y);
        if(x ~= 1)
            px_cam_coords = [calib.cc(1) - x; calib.cc(2) - y; 1];

            lambda = num/(den * px_cam_coords);
            world_pt = inv(Rc) * (inv(KK)*lambda*px_cam_coords - Tc);
            world_coords(y,:) = world_pt;
        end
    end
     
    % Rotate around the x axis
    Rx = [1 0 0; 0 cosd(10) -sind(10); 0 sind(10) cosd(10)];
    world_coords_rot = zeros(size(world_coords,1)*36, 3);
    for i = 1:size(world_coords, 1)
        pt = transpose(world_coords(i,:));
        for ang = 1:36
            pt = Rx*pt;
            world_coords_rot((i-1)*36+ang,:) = pt;
        end
    end

    plot3(world_coords_rot(:,1), world_coords_rot(:,2), world_coords_rot(:,3), '.', 'markersize', 10);
    xlabel('X');
    ylabel('Y');
    zlabel('Z');
    rotate3d;    
    grid on
end
