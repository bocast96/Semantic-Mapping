function model = make_model(pts, step)
    %{
    pts is a cell array of point clouds and rgb values
    step is step int for loop
    %}
    len = length(pts);

    for i = 1:step:len
       pt = pointCloud(pts{i,1}, 'Color', pts{i,2}); 

       if i == 1
           ptCloudAcc = pt;
           transformedCloud = pt;
       else 
           %gridstep = 0.8;
           %subCurr = pcdownsample(pt, 'gridAverage', gridstep);
           %subModel = pcdownsample(ptCloudAcc, 'gridAverage', gridstep);

            t_matrix = icpPt2Plane(pt, ptCloudAcc);

            sz = numel(pt.Location(:,1));
            onesColumn = zeros(sz, 1);
            onesColumn(:,1) = 1;
            ptMat = [pt.Location onesColumn]';
            transformedPts = t_matrix*ptMat;

            transformedCloud = pointCloud(transformedPts(1:3, :)', 'Color', pt.Color);
       end

       ptCloudAcc = pointCloud([ptCloudAcc.Location; transformedCloud.Location], 'Color', [ptCloudAcc.Color; pt.Color]);
       %pcshow(ptCloudAcc);

    end

    ptCloudAcc = pcdenoise(ptCloudAcc);
    [a, b] = outlier_rejection(ptCloudAcc.Location, ptCloudAcc.Color, 200);
    ptCloudAcc = pointCloud(a, 'Color', b);
    pcshow(ptCloudAcc);
    model = ptCloudAcc;  
end