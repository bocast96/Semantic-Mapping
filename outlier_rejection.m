function [Pts, rgb] = outlier_rejection(Pts, rgb, max_distance)
    % rejects points farther than some distance from the center of density of
    % the cloud
    meanx = mean(Pts(:,1));
    meany = mean(Pts(:,2));
    meanz = mean(Pts(:,3));
    center = [meanx, meany, meanz];
    outliers = [];

    for i = 1:length(Pts)
       pt = Pts(i,:);
       dist = norm(pt-center);
       if dist > max_distance
           outliers = [outliers i];
       end
    end
    
    Pts(outliers, :) = [];
    rgb(outliers, :) = [];
end