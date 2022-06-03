function y = nanmad1(x, applyscale)
% One-D median absolute deviation allowing NaNs

if ~exist('applyscale', 'var')
    applyscale = false;
end

m = nanmedian(x, 1);
y = nanmedian(abs(x - repmat(m, size(x, 1), 1)), 1);

if applyscale
    scale = 1/norminv(0.75);
else
    scale = 1;
end
y = y * scale;