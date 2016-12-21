function [point_clouds] = get_multObj_050(start, finish, step)
    % update your path
    path = 'Data\MultipleObjects\scene_050\frames\frame_';
    len = finish - start + 1;
    point_clouds = cell(len,2);
    cur = start;
    for idx = 1:step:len
        num = num2str(cur);
        i = imread(strcat(path, num, '_rgb.png'));
        id = imread(strcat(path, num, '_depth.png'));
        if cur < 150
            x = 0;
            xl = 400; yl = 400;
        elseif cur < 300
            x = 0;
            xl = 500; yl = 350;
        elseif cur < 450
            x = 150;
            xl = 500; yl = 300;            
        else
            x = 200;
            xl = 500; yl = 250;
        end
        
        rec = [x, 0, xl, yl];
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
        [Pts, rgb] = outlier_rejection(Pts, rgb, 250);
        %pcshow(Pts, rgb);
        
        point_clouds{idx, 1} = Pts;
        point_clouds{idx, 2} = rgb;
        cur = cur+1;
        clear Pts && rgb && i && id && pcx && pcy && pcz && r && g && b
    end
    
end