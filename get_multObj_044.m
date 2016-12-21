function [point_clouds] = get_multObj_044(start, finish, step)
    % update your path
    path = 'Data\MultipleObjects\scene_044\frames\frame_';
    len = finish - start + 1;
    point_clouds = cell(len,2);
    cur = start;
    for idx = 1:step:len
        num = num2str(cur);
        i = imread(strcat(path, num, '_rgb.png'));
        id = imread(strcat(path, num, '_depth.png'));
        if cur < 350
            x = 0; y = 550;
        else
            x = 100; y = 400;
        end
        
        rec = [x, 0, 500, y];
        i = imcrop(i, rec);
        id = imcrop(id, rec);
        
        [pcx, pcy, pcz, r, g, b, ~, ~, ~, ~] = depthToCloud_full_RGB(id, i, 'params/calib_xtion.mat');
        Pts = [pcx pcy pcz];
        rgb = [r g b]/255;
        
        %%
        [Pts, rgb] = removeLargestPlain(Pts, rgb, 20, 20);
        %pcshow(Pts, rgb);

        %%
        [Pts, rgb] = removeLargestPlain(Pts, rgb, 20, 20);
        %pcshow(Pts, rgb);

        %%
        [Pts, rgb] = outlier_rejection(Pts, rgb, 300);
        %pcshow(Pts, rgb);
        
        point_clouds{idx, 1} = Pts;
        point_clouds{idx, 2} = rgb;
        cur = cur+1;
        clear Pts && rgb && i && id && pcx && pcy && pcz && r && g && b
    end
    
end