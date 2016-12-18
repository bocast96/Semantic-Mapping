function [point_clouds] = get_points_012()
    % update your path
    path = 'Data\SingleObject\scene_012\frames\frame_';
    point_clouds = cell(373,2);
    
    for idx = 0:373
        num = num2str(idx);
        i = imread(strcat(path, num, '_rgb.png'));
        id = imread(strcat(path, num, '_depth.png'));
        
        if idx < 151
            x = 0;
        else
            x = 150;
        end
        
        rec = [x, 0, 400, 400];
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