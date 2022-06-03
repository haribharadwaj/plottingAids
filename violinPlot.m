function violinPlot(y, xpos, symb, msize, col, violinWidth, nbins)
% USAGE:
%   violinPlot(y, xpos, symb, msize, col, violinWidth,  nbins);
%
% INPUTS:
%   y - Data (y-axis values) from which the swarm should be created. Note
%       that only a single category is supported, so call this function
%       multiple times if more than one category is to be plotted.
%   xpos - The position along the x-axis where the swarm is to be
%       horizontally centered. [Optional: default 0]
%   symb - marker symbol to use for swarm (e.g., 'o').
%       [Optional: default 'o']
%   msize - marker size as in the scatter function. [Optional: default 100]
%   col - marker edge AND face color. [Optional: default RGB of
%       0.2,0.2,0.2]
%   violinWidth - The width of the violin along the x-axis. [Optional:
%       default 1, i.e., area under density adds to 0.5 on each side]
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

if ~exist('violinWidth', 'var')
    violinWidth = 1;
end

if ~exist('symb', 'var')
    symb = 'o';
end

%% Unexposed settings: can expose if needed
addYjitter = true; 
addmedian = true;
adderrorbar = false;
markerFaceAlpha = 0.3;
lw = 3;

%% Actual swarm plot
[counts, edges] = histcounts(y, nbins);
binwidth = mean(diff(edges));
centers = edges(1:(end-1)) + binwidth/2;
maxcount = max(counts);
[~, ~, bw] = ksdensity(y);
[f, yi] = ksdensity(y, 'Bandwidth', 2*bw);

densitymax = max(f);
for bin = 1:nbins
    count = counts(bin);
    localWidth = densitymax * violinWidth * count / maxcount;
    xvals = linspace(0, localWidth, count);
    xvals = xvals - mean(xvals) + xpos;
    yvals = repmat(centers(bin), size(xvals));
    if addYjitter
        yvals = yvals + (rand(size(yvals))*binwidth - binwidth/4);
    end
    scatterh = scatter(xvals, yvals, msize, symb,...
        'MarkerEdgeColor', col, 'MarkerFaceColor', col);
    scatterh.MarkerFaceAlpha = markerFaceAlpha;
    hold on;
end
% Plot violin
plot(xpos + f/2, yi, 'linew', 2, 'col', col);
hold on;
plot(xpos - f/2, yi, 'linew', 2, 'col', col);



if addmedian
    ymed = nanmedian(y);
    hold on;
    plot([xpos - densitymax * violinWidth/2,...
        xpos + densitymax * violinWidth/2], [ymed, ymed],...
        'linew', lw, 'col', col);
end
if adderrorbar
    hold on; %#ok<UNRCH>
    ymed = nanmedian(y);
    yerr = nanmad1(y) / sqrt(sum(~isnan(y)));
    errorbar(xpos, ymed, yerr, ...
        'linew', lw, 'col', col);
end
