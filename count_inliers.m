function inlier_count = count_inliers(object_points_transformed, global_points, inlier_threshold)
    % Compute the distances between the transformed object points and the global points
    distances = sqrt(sum((object_points_transformed - global_points).^2, 2));

    % Count the number of inliers within the given threshold
    inlier_count = sum(distances <= inlier_threshold);
end