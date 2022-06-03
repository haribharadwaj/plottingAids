function boxPlotcustom(y, xpos, symb, msize, col, boxWidth, showOutlier)
% USAGE:
%   boxPlotcustom(y, xpos, symb, msize, col, boxWidth, showOutlier);
%
% INPUTS:
%   y - Data (y-axis values) from which the swarm should be created. Note
%       that only a single category is supported, so call this function
%       multiple times if more than one category is to be plotted.
%   xpos - The position along the x-axis where the swarm is to be
%       horizontally centered. [Optional: default 0]
%   symb - marker symbol to use for outliers (e.g., 'o').
%       [Optional: default 'o']
%   msize - marker size as in the scatter function. [Optional: default 100]
%   col - marker edge AND face color. [Optional: default RGB of
%       0.2,0.2,0.2]
%   boxWidth - The width of the box along the x-axis. [Optional:
%       default 1, i.e., 0.5 on each side]
%
%   showOutlier - Whether to plot outlier. [Optional: default true]
%
% NOTES:
%   Copyright 2022. Hari Bharadwaj. All rights reserved.

%% Settings

if ~exist('xpos', 'var')
    xpos = 0;
end

if ~exist('msize', 'var')
    msize = 100;
end

if ~exist('col', 'var')
    col = [0.5, 0.5, 0.5];
end

if ~exist('boxWidth', 'var')
    boxWidth = 1;
end

if ~exist('symb', 'var')
    symb = 'o';
end

if ~exist('showOutlier', 'var')
    showOutlier = true;
end
%% Unexposed settings: can expose if needed
markerFaceAlpha = 0.3;
lwm = 3; %Line width for median
lwb = 2; %Line width for box
lww = 1; %Line width for whisker

%% Actual box plot
% Median line
ymed = nanmedian(y);
hold on;
plot([xpos - boxWidth/2, xpos + boxWidth/2], [ymed, ymed],...
    '-', 'linew', lwm, 'col', col);

% Box
xvalsb = [xpos - boxWidth/2, xpos - boxWidth/2, xpos + boxWidth/2, ...
    xpos + boxWidth/2, xpos - boxWidth/2];
yvalsb = [prctile(y, 25), prctile(y, 75), prctile(y, 75), ...
    prctile(y, 25), prctile(y, 25)];
hold on;
plot(xvalsb, yvalsb, '-', 'linew', lwb, 'col', col);

% Upper whisker
uw1 = prctile(y, 75); % Starting value
ufence = uw1 + 1.5*iqr(y);
uw2 = max(y(y < ufence)); % Ending value
hold on;
plot([xpos, xpos], [uw1, uw2], '-', 'linew', lww, 'col', col);

% lower whisker
lw1 = prctile(y, 25); % Starting value
lfence = lw1 - 1.5*iqr(y);
lw2 = min(y(y > lfence)); % Ending value
hold on;
plot([xpos, xpos], [lw1, lw2], '-', 'linew', lww, 'col', col);

%% Outliers
if showOutlier
    hold on;
    outlierinds = (y > ufence) | (y < lfence) ;
    nouts = sum(outlierinds);
    scatterh = scatter(repmat(xpos, 1, nouts), y(outlierinds), msize,...
        symb, 'MarkerEdgeColor', col, 'MarkerFaceColor', col);
    scatterh.MarkerFaceAlpha = markerFaceAlpha;
end
