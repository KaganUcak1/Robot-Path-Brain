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
qWaypoints = [0 0 0 0 0 0.1
              0 0 0 0 0 0.2
              0 0 0 0 0 0.3
              0 0 0 0 0 0.4];
tFinal = 10; framerate = 15;
r = rateControl(framerate);
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
%axis([-0.1, 0.8, -0.35, 0.35, -0.3, 0.8]); 
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
