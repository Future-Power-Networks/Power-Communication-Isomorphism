% Scope plot
close all

clear('Time');
clear('theta','theta_','theta__');

Time = out.Data_App1{6}.Values.Time;
TimeShift = 2;
% TimeShift = 0;
Time = Time - TimeShift;

Fbus = [19,22,30,31,32,34,35,37,38,43,54,57,58,62,63,65,66];

% NumRef = 17;
% NumBus = 68;

NumRef = 1;
NumBus = 16;

Enable_17InfBus = 0;


for i = 1:NumBus
    if isempty(find(Fbus == i,1))
        theta{i} = eval(['out.Data_App' num2str(i) '{6}.Values.Data']);
        vdq{i} = eval(['out.Data_App' num2str(i) '{1}.Values.Data']);
        vm{i} = ArrayNorm(vdq{i});
    end
end

for i = 1:NumBus
    if isempty(find(Fbus == i,1))
        len = length(theta{i});
        theta_ = theta{i};
        for j = 1:len
            if Enable_17InfBus
                if i == 17
                    theta__(j) = theta_(j);     % For inf bus case only
                else
                    theta__(j) = theta_(:,:,j);
                end
            else
                theta__(j) = theta_(:,:,j);
            end
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

figure(999)
FigSize = [0.1 0.1 0.35 0.5];
set(gcf,'units','normalized','outerposition',FigSize);
for i = 1:NumBus
    if isempty(find(Fbus == i,1))
        subplot(2,1,1)
        plot(Time,dtheta{i}); hold on; grid on;
        xlim([0,1.5]);
        ylim([-0.6,0.3]);
        ylabel('Angle (rad)');
        % xlabel('Time (s)');
        subplot(2,1,2)
        plot(Time,vm{i}); hold on; grid on;
        ylim([0,1.5]);
        xlim([0,1.5]);
        ylabel('Voltage (pu)')
        xlabel('Time (s)')
    end
end

if 0
    print(gcf,['K_Sim_SG_Load_StabilityLimit_8s.png'],'-dpng','-r600');
end