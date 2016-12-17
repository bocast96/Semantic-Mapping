function [Pts, rgb] = removeLargestPlain(Pts,rgb, threshold, iterations)
    %{ 
        Pts = [pcx, pcy, pcz]
        rgb = [r, g, b] / 255 first two are from depthToCloud_full_RGB
        threshold = threshold for tao
        iterations = number of iterations
    %}
    
    len = length(Pts);
    t = 1;
    largest_plain = [];

    while t <= iterations
        % getting 3 rand points
        idx = randi(len, 1,3);
        A = Pts(idx(1),:);
        B = Pts(idx(2),:);
        C = Pts(idx(3),:);

        % getting normal
        AB = B - A;
        AC = C - A;
        N = cross(AB, AC)';
        d = (-A) * N;
        % find points in plain
        tmp_plain = [];
        for i = 1:len
           pt = Pts(i,:);
           tao = ((pt * N) + d) / norm(N); % check math with TA
           %D = pt - A;
           %tao = dot(N,D);

           if abs(tao) <= threshold
               tmp_plain = [tmp_plain, i];
           end
        end


        if length(tmp_plain) > length(largest_plain)
            largest_plain = tmp_plain;
        end

        t = t+1;
    end

    %plane = Pts(largest_plain,:);
    %plane_rgb = rgb(largest_plain,:);
    %pcshow(plane, plane_rgb);
    
    % removing plain
    Pts(largest_plain, :) = [];
    rgb(largest_plain, :) = [];
end