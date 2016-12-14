function coords =  skeletonize(img)
    noise_tolerance = 3;
    max_len = 0;
    max_len_midpt = 1;
    curr_start_idx = 1;
    counting = false;
    coords = zeros(size(img,1), size(img,2));
    
    for r = 1:size(img,1)
        for c = 1:size(img,2)
            % End a block
            if img(r,c) == 0 && counting
                counting = false;
                if c - curr_start_idx > max_len
                    max_len = c - curr_start_idx;
                    max_len_midpt = ceil((c + curr_start_idx)/2);
                end
            end
            
            % Start a new block
            if img(r,c) == 255 && ~counting
                counting = true;
                curr_start_idx = c;
            end
        end
        
        % Finish last count at end of row
        if counting
            if c - curr_start_idx > max_len
                max_len = c - curr_start_idx;
                max_len_midpt = ceil((c + curr_start_idx)/2);
            end 
        end
        coords(r,max_len_midpt) = 1;
        %coords(r) = max_len_midpt;
        max_len = 0;
        max_len_midpt = 1;
    end
end