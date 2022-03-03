% Plot the simulation results
clear all
clc
close all

% DataName = 'SingleIbrMode';
DataName = 'InterAreaMode';

TimeShift = 2;
Enable_SaveFigure = 1;
FigSize = [0.1 0.1 0.35 0.7];

load(['out_' DataName]);

Time = out.Data_App1{6}.Values.Time;
Time = Time - TimeShift;

Fbus = [19,22,30,31,32,34,35,37,38,43,54,57,58,62,63,65,66];

NumRef = 1;
NumBus = 16;

for i = 1:NumBus
    if isempty(find(Fbus == i,1))
        w_{i} = eval(['out.Data_App' num2str(i) '{5}.Values.Data']);
        theta{i} = eval(['out.Data_App' num2str(i) '{6}.Values.Data']);
        vdq{i} = eval(['out.Data_App' num2str(i) '{1}.Values.Data']);
        vm{i} = ArrayNorm(vdq{i});
    end
end
for i = 1:NumBus
    for k = 1:length(w_{i})
        w{i}(k) = w_{i}(:,:,k);
    end
end

for i = 1:NumBus
    if isempty(find(Fbus == i,1))
        len = length(theta{i});
        theta_ = theta{i};
        for j = 1:len
         	theta__(j) = theta_(:,:,j);
        end
        theta{i} = theta__;
    end
end


for i = 1:NumBus
    if isempty(find(Fbus == i,1))
        dtheta{i} = theta{i} - theta{NumRef};
        dtheta{i} = dtheta{i} + pi;
        dtheta{i} = mod(dtheta{i},2*pi);
        dtheta{i} = dtheta{i} - pi;
        dtheta{i} = DisableMod(dtheta{i});
    end
end

figure(1)
LineWidth = 1;
set(gcf,'units','normalized','outerposition',FigSize);
for i = 1:NumBus
    if isempty(find(Fbus == i,1))
        subplot(3,1,1)
        plot(Time,w{i}(:,:,1),'LineWidth',LineWidth); hold on; grid on;
        xlim([0,10]);
        ylabel('Frequency (pu)')
        % xlabel('Time (s)')
        subplot(3,1,2)
        plot(Time,dtheta{i}*180/pi,'LineWidth',LineWidth); hold on; grid on;
        % xlabel('Time (s)')
        xlim([0,10]);
%         ylim([0,1]);        % 0SG, 3SG, 0SG_Load
%         ylim([-5,30]);     % 2SG
        ylabel('Angle (Degree)');
        subplot(3,1,3)
        plot(Time,vm{i},'LineWidth',LineWidth); hold on; grid on;
        xlim([0,10]);
        ylim([0,1.5]);        % 3SG, 0SG_Load
        ylabel('Voltage (pu)')
        xlabel('Time (s)')
    end
end

if Enable_SaveFigure
    print(gcf,['IbrCase_' DataName '.png'],'-dpng','-r600');
end