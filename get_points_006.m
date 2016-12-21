function [point_clouds] = get_points_006(start, finish, step)
    % update your path
    path = 'Data\SingleObject\scene_006\frames\frame_';
    len = finish - start + 1;
    point_clouds = cell(len,2);
    cur = start;
    
    for idx = 1:step:len
        num = num2str(cur);
        i = imread(strcat(path, num, '_rgb.png'));
        id = imread(strcat(path, num, '_depth.png'));
        
        if cur < 121
            x = 0; y = 0;
            xl = 500; yl = 500;
        elseif cur < 251
            x = 0; y = 0;
            xl = 600; yl = 400;
        elseif cur < 351
            x = 100; y = 0;
            xl = 600; yl = 400;
        else
            x = 180; y = 0;
            xl = 600; yl = 400;
        end
        
        rec = [x, y, xl, yl];
        i = imcrop(i, rec);
        id = imcrop(id, rec);
        
        [pcx, pcy, pcz, r, g, b, ~, ~, ~, ~] = depthToCloud_full_RGB(id, i, 'params/calib_xtion.mat');
        Pts = [pcx pcy pcz];
        rgb = [r g b]/255;
        
        %%
        [Pts, rgb] = removeLargestPlain(Pts, rgb, 15, 20);
        %pcshow(Pts, rgb);

        %%
        [Pts, rgb] = removeLargestPlain(Pts, rgb, 15, 20);
        %pcshow(Pts, rgb);

        %%
        [Pts, rgb] = outlier_rejection(Pts, rgb, 160);
        %pcshow(Pts, rgb);
        
        point_clouds{idx, 1} = Pts;
        point_clouds{idx, 2} = rgb;
        cur = cur+1;
        clear Pts && rgb && i && id && pcx && pcy && pcz && r && g && b
    end
    
end