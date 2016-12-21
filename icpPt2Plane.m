function [ homogeneousMatrix ] = icpPt2Plane( currPtCloud, ptCloudAcc )
%ICP2 Summary of this function goes here
%   Detailed explanation goes here

    origPtCloud = currPtCloud;
    homogeneousMatrix = eye(4,4);
    
    for j = 0:40
              
        %currPtCloud = pctransform(currPtCloud, tform);
        sz = numel(currPtCloud.Location(:,1));
        onesColumn = zeros(sz,1);
        onesColumn(:,1) = 1;
        ptMat = [origPtCloud.Location onesColumn]';
        transformedPts = homogeneousMatrix*ptMat;
        currPtCloud = pointCloud(transformedPts(1:3,:)', 'Color', ...
            currPtCloud.Color);

        normals = pcnormals(currPtCloud);

        px = currPtCloud.Location(:,1);
        py = currPtCloud.Location(:,2);
        pz = currPtCloud.Location(:,3);
        P = [px py pz];

        nx = normals(:,1);
        ny = normals(:,2);
        nz = normals(:,3);
        N = [nx ny nz];

        sensorCenter = [0,-0.3,0.3];
        for k = 1 : numel(px)
           p1 = sensorCenter - [px(k),py(k),pz(k)];
           p2 = [nx(k),ny(k),nz(k)];
           % Flip the normal vector if it is not pointing towards the sensor.
           angle = atan2(norm(cross(p1,p2)),p1*p2');
           if angle > pi/2 || angle < -pi/2
               nx(k) = -nx(k);
               ny(k) = -ny(k);
               nz(k) = -nz(k);
           end
        end

        %hold on
        %quiver3(px,py,pz,nx,ny,nz);
        %hold off

        qx = ptCloudAcc.Location(:,1);
        qy = ptCloudAcc.Location(:,2);
        qz = ptCloudAcc.Location(:,3);
        Q = [qx qy qz];

        
        IDX = knnsearch(Q, P);

        q2 =  zeros(numel(px),3);
        for k = 1:(numel(px))              
           q2(k,:) = Q(IDX(k),:);
        end

        qx = q2(:,1);
        qy = q2(:,2);
        qz = q2(:,3);
        
        
        A = [ nz.*py - ny.*pz, nx.*pz - nz.*px, ny.*px - nx.*py, ...
            nx, ny, nz ];

        sol = nx.*qx + ny.*qy + nz.*qz - nx.*px - ny.*py - nz.*pz;

        x_hat = pinv(A)*sol;

        alpha = x_hat(1);
        beta = x_hat(2);
        gamma = x_hat(3);
        tx = x_hat(4);
        ty = x_hat(5);
        tz = x_hat(6);

        rotationMatrix = [ 1, alpha*beta - gamma, alpha*gamma + beta; ...
            gamma, alpha*beta*gamma + 1, beta*gamma-alpha;...
            -beta, alpha, 1; 0, 0, 0];
        
        %[ cos(gamma)*cos(beta), ...
         %   (-1)*sin(gamma)*cos(alpha) + cos(gamma)*sin(beta)*sin(alpha),...
          %  sin(beta);...
           % sin(gamma)*cos(beta), cos(gamma)*cos(alpha) + ...
            %sin(gamma)*sin(beta)*sin(alpha), ...
            %(-1)*cos(gamma)*sin(alpha) + sin(gamma)*sin(beta)*cos(alpha); ...
            %(-1)*sin(beta), cos(beta)*sin(alpha), cos(beta)*cos(alpha); 0, 0, 0];
        %[ 1, -gamma, beta; gamma, 1, -alpha;...
         %   -beta, alpha, 1; 0, 0, 0];



        %sin(gamma)*sin(alpha) + cos(gamma)*sin(beta)*sin(alpha)

        translationVector = [tx; ty; tz; 1];



        currMatrix = [rotationMatrix, translationVector];
        homogeneousMatrix = currMatrix*homogeneousMatrix;

        for index = 1:3
           homogeneousMatrix(index, index) = 1; 
        end
    end
    
    %mahalVec = mahal(eye(4,4), homogeneousMatrix)
   
    
    %transformedPts = homogeneousMatrix*ptMat;
    %transformedPtCloud = pointCloud(transformedPts(1:3,:)', 'Color', ...
     %   currPtCloud.Color);
end

