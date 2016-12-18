function [point_clouds] = get_points_006()
    % update your path
    path = 'Data\SingleObject\scene_006\frames\frame_';
    point_clouds = cell(414,2);
    
    for idx = 0:414
        num = num2str(idx);
        i = imread(strcat(path, num, '_rgb.png'));
        id = imread(strcat(path, num, '_depth.png'));
        
        if idx < 121
            x = 0; y = 0;
            xl = 500; yl = 500;
        elseif idx > 120 && idx < 251
            x = 0; y = 0;
            xl = 600; yl = 400;
        elseif idx > 250 && idx < 351
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
        
        point_clouds{idx+1, 1} = Pts;
        point_clouds{idx+1, 2} = rgb;
        clear Pts && rgb && i && id && pcx && pcy && pcz && r && g && b
    end
    
end