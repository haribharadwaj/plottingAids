function swarmPlot(y, xpos, symb, msize, col, swarmWidth,  nbins)
% USAGE:
%   swarmPlot(y, xpos, symb, msize, col, swarmWidth,  nbins);
%
% INPUTS:
%   y - Data (y-axis values) from which the swarm should be created. Note
%       that only a single category is supported, so call this function
%       multiple times if more than one category is to be plotted.
%   xpos - The position along the x-axis where the swarm is to be
%       horizontally centered. [Optional: default 0]
%   symb - marker symbol to use (e.g., 'o'). [Optional: default 'o']
%   msize - marker size as in the scatter function. [Optional: default 100]
%   col - marker edge AND face color. [Optional: default RGB of
%       0.2,0.2,0.2]
%   swarmWidth - The width of the swarm along the x-axis. [Optional:
%       default 1];
%   nbins - The number of bins to group the swarm into a "violin".
%       [Optional: default 20].
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
col = [0.2, 0.2, 0.2];
end

if ~exist('nbins', 'var')
nbins = 20;
end

if ~exist('swarmWidth', 'var')
swarmWidth = 1;
end

if ~exist('symb', 'var')
    symb = 'o';
end

addYjitter = true; % can expose this setting if needed
markerFaceAlpha = 0.3;

%% Actual swarmp plot
[counts, edges] = histcounts(y, nbins);
binwidth = mean(diff(edges));
centers = edges(1:(end-1)) + binwidth/2;
maxcount = max(counts);
for bin = 1:nbins
    count = counts(bin);
    localWidth = swarmWidth * count / maxcount;
    xvals = linspace(0, localWidth, count);
    xvals = xvals - mean(xvals) + xpos;
    yvals = repmat(centers(bin), size(xvals));
    if addYjitter
        yvals = yvals + (rand(size(yvals))*binwidth - binwidth/2);
    end
    scatterh = scatter(xvals, yvals, msize, symb,...
        'MarkerEdgeColor', col, 'MarkerFaceColor', col);
    scatterh.MarkerFaceAlpha = markerFaceAlpha;
    hold on;
end