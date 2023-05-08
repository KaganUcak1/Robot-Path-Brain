%clc; clear

% local STL points for the registration
point1 = [ 64.14 -35.83 2.57];
point2 = [ 63.61  34.45 2.94];
%point2 = [-65.16 -35.13 2.57];
point3 = [-3.03 0.16 -37.35];

% local STL point for the touch point

pointTouch = [22.5000  0  -38.9711];
centerPoint = [0 0 0];

pointLocal = [point1;point2;point3];

% Define the object's points in its local coordinate system

object_points_local = pointLocal;

% Define the corresponding points in the global coordinate system

point1_2 = [-243.17 -461.47 60.92 ];
point2_2 = [-277.97 -523.03 61.63 ];
point3_2 = [-129.90 -525.75 60.78 ];
point4_2 = [-164.04 -586.37 60.84 ];
point5_2 = [-202.74 -524.21 100.66];

global_points = [point2_2;point1_2;point5_2];

figure; 

plot3(object_points_local(:,1),object_points_local(:,2),object_points_local(:,3),"b*","LineWidth",2);
hold on; grid on;
plot3(global_points(:,1),global_points(:,2),global_points(:,3),"r*","LineWidth",2);


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

% Print the best transformation matrix
disp("Best transformation matrix:");
disp(best_T);

% Transform all points in the object to the global coordinate system using the best transformation matrix
object_points_transformed = [object_points_local, ones(size(object_points_local, 1), 1)] * best_T';

object_points_transformed = object_points_transformed(:, 1:3);

% Print the transformed points
disp("Object points in global coordinate system:");
disp(object_points_transformed);

plot3(object_points_transformed(:,1),object_points_transformed(:,2),object_points_transformed(:,3),"yo","LineWidth",1.5)


p2 = [pointTouch, 1]*best_T';
p1 = [centerPoint, 1]*best_T';
%% 

orientationMatrix = orientationFind(p1,p2);
p2-p1
axis equal;
function inlier_count = count_inliers(object_points_transformed, global_points, inlier_threshold)
    % Compute the distances between the transformed object points and the global points
    distances = sqrt(sum((object_points_transformed - global_points).^2, 2));

    % Count the number of inliers within the given threshold
    inlier_count = sum(distances <= inlier_threshold);
end

function orientation = orientationFind(p1,p2)

    % Calculate the difference vector between the two points
    diff_vec = p2 - p1;
    
    % Calculate the azimuth angle
    azimuth = atan2(diff_vec(2), diff_vec(1));
    
    % Calculate the elevation angle
    elevation = atan2(diff_vec(3), norm(diff_vec(1:2)));
    
    %
    

    % Convert the angles to degrees
    azimuth_deg = rad2deg(azimuth);
    elevation_deg = rad2deg(elevation);
    
    % Assemble the orientation vector
    orientation = [azimuth_deg, elevation_deg];
end