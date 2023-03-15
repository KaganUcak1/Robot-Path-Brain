close all
clearvars
clc

Nachi = importrobot("mz07.urdf",'DataFormat','row');  % it is much simple to use this data format

q0 = homeConfiguration(Nachi);  % home configuration

gik = generalizedInverseKinematics('RigidBodyTree', Nachi, ...
    'ConstraintInputs', {'cartesian','position','aiming','orientation','joint'});

%% Visualize the Generated Trajectory
% Interpolate between the waypoints to generate a smooth trajectory.
% Use pchip to avoid overshoots, which might violate the joint limits of the robot.

qWaypoints = [-96.41,111.72,-16.05, 1.28,-75.03,-67.46;
-93.46,53.17,-16.98,0.75,-15.51,-65.09;
-91.94,47.3,-17.41,-22.55,-3.71,-37.57;
-92.22,46.63,-17.34,-30.55,-2.52,-29.79;
-92.19,44.99,-15.76,-23.4,-3.33,-36.94;
-92.08,40.42,-12.71,-96.24,-1.34,36.16;
-92.19,44.99,-15.76,-23.4,-3.33,-36.94;
-92.22,46.63,-17.34,-30.55,-2.52,-29.79;
-91.94,47.3,-17.41,-22.55,-3.71,-37.57;
-93.46,53.17,-16.98,0.75,-15.51,-65.09]*pi/180;
qWaypoints(:,1) = qWaypoints(:,1) + pi/2;
qWaypoints = qWaypoints(end:-1:1,:);
framerate = 15;
r = rateControl(framerate);
tFinal = 10;
tWaypoints = [0,linspace(tFinal/2,tFinal,size(qWaypoints,1)-1)];
numFrames = tFinal*framerate;
qInterp = pchip(tWaypoints,qWaypoints',linspace(0,tFinal,numFrames))';

% Compute the gripper position for each interpolated configuration.
gripperPosition = zeros(numFrames,3);
for k = 1:numFrames
    gripperPosition(k,:) = tform2trvec(getTransform(Nachi,qInterp(k,:),'tool0'));
end

figure;
%% Show the robot in its initial configuration along with the table and cup
show(Nachi, qWaypoints(1,:), 'PreservePlot', false);
hold on
p = plot3(gripperPosition(1,1), gripperPosition(1,2), gripperPosition(1,3));
% Adjust the camera and axis limits
axis([-0.1, 0.8, -0.35, 0.35, -0.3, 0.8]); 
campos([7.84, 8.17,2.05]); camva(6.9); camtarget([-0.16, 0.18, 0.55]);
view(180,0)

hold on
for k = 1:size(qInterp,1)
    show(Nachi, qInterp(k,:), 'PreservePlot', false);
    p.XData(k) = gripperPosition(k,1);
    p.YData(k) = gripperPosition(k,2);
    p.ZData(k) = gripperPosition(k,3);
    waitfor(r);
end
hold off

save('NACHI_trajectory.mat', 'tWaypoints', 'qWaypoints');


