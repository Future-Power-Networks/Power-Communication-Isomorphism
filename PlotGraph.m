% This function plots the graph for a power system

% Set the RGB of the default color in matlab
BLUE = [0, 0.4470, 0.7410];
RED = [0.8500, 0.3250, 0.0980];

% Get the graph matrix
GraphMatrix = NormMatrixElement(Ybus,'DiagFlag',0);

% Plot the graph
fig_n = fig_n + 1;
figure(fig_n)
GraphData = graph(GraphMatrix,'upper');
GraphPlot = plot(GraphData);

% Change all edges and nodes to black first
highlight(GraphPlot,GraphData,'EdgeColor','k','LineWidth',1);
highlight(GraphPlot,GraphData,'NodeColor','k');

% Highlight the node types by colors
IndexVoltageNode = find(DeviceSourceType == 1);
IndexCurrentNode = find(DeviceSourceType == 2);
IndexFloatingNode = find(DeviceSourceType == 3);

highlight(GraphPlot,IndexVoltageNode,'NodeColor',BLUE);
highlight(GraphPlot,IndexCurrentNode,'NodeColor',RED);
% highlight(GraphPlot,IndexFloatingNode,'NodeColor','k');