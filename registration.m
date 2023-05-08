function resultMatrix =  registration(global_points,pointTouch)
% local STL points for the registration
point1 = [ 64.14 -35.83 2.57];
point2 = [ 63.61  34.45 2.94];
%point2 = [-65.16 -35.13 2.57];
point3 = [-3.03 0.16 -37.35];

centerPoint = pointTouch(1:3);
entryPoint = pointTouch(4:6);

% local STL point for the touch point




pointLocal = [point1;point2;point3];

% Define the object's points in its local coordinate system

object_points_local = pointLocal;

% Define the corresponding points in the global coordinate system

% point1_2 = [-243.17 -461.47 60.92 ];
% point2_2 = [-277.97 -523.03 61.63 ];
% point3_2 = [-129.90 -525.75 60.78 ];
% point4_2 = [-164.04 -586.37 60.84 ];
% point5_2 = [-202.74 -524.21 100.66];
% 
% global_points = [point2_2;point1_2;point5_2];

% Define the number of iterations for RANSAC
num_iterations = 100;

% Define the threshold for inlier selection
inlier_threshold = 1;

% Perform RANSAC to estimate the homogeneous transformation
best_inlier_count = 0;
for i = 1:num_iterations
    % Randomly select 3 point pairs
    point_indices = randperm(size(object_points_local, 1), 3);
    object_points_sampled = object_points_local(point_indices, :);
    global_points_sampled = global_points(point_indices, :);

    % Compute the homogeneous transformation matrix
    tform = estgeotform3d(object_points_sampled, global_points_sampled,"rigid");
    T = tform.A;

    % Transform all points in the object to the global coordinate system
    object_points_transformed = [object_points_local, ones(size(object_points_local, 1), 1)] * T';
    object_points_transformed = object_points_transformed(:, 1:3);

    % Compute the number of inliers
    inlier_count = count_inliers(object_points_transformed, global_points, inlier_threshold);

    % Keep track of the best transformation matrix so far
    if inlier_count > best_inlier_count
        best_T = T;
        best_inlier_count = inlier_count;
    end
end

% Transform all points in the object to the global coordinate system using the best transformation matrix
object_points_transformed = [object_points_local, ones(size(object_points_local, 1), 1)] * best_T';

object_points_transformed = object_points_transformed(:, 1:3);


p2 = [entryPoint, 1]*best_T';
p1 = [centerPoint, 1]*best_T';


orientationArray = orientationFind(p1,p2);
resultMatrix = [p2(1:3);orientationArray];

end




