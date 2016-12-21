function [point_clouds] = get_points_000(start, finish, step)
   % Segmenting object 000
    % update your path
    path = 'Data\SingleObject\scene_000\frames\frame_';
    len = finish - start + 1;
    point_clouds = cell(len,2);
    cur = start;
    
    for idx = 1:step:len
        num = num2str(cur);
        i = imread(strcat(path, num, '_rgb.png'));
        id = imread(strcat(path, num, '_depth.png'));
        if cur < 181
            x = 0; y = 0;
            xl = 500; yl = 440;
        elseif idx > 180 && idx < 220
            x = 10; y = 10;
            xl = 600; yl = 440;
        else
            x = 200; y = 0;
            xl = 600; yl = 350;
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