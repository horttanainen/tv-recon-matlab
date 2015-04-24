function [ slice ] = reconstructslice(fnam_fp, ftype, n, cor, range, row, I0_b, I0_e)
%RECONSTRUCTSLICE Reconstruct CT slice from projection data
%
%   A = reconstructslice(fnam_firstpart, ftype, n, cor, range, row, I_0_begin, I_0_end)
%
%   fnam_fp = First part of the filenames. For example, if the
%   projection files are labeled 'tomoscan0001.tif' etc. the first part
%   is 'tomoscan'.
%
%   ftype = File type, e.g. 'tif', 'png', etc.
%
%   n = Number of projections.
%
%   cor = Center of rotation, as column number from left.
%
%   range = The width of the slice is from "cor - range" to "cor + range".
%
%   row = Row number of sinogram to be generated, counted from the top row.
%
%   I0_b = First pixel of the the I_0 intensity area on the row, 
%   counted from the left.
%
%   I0_e = Last pixel of the the I_0 intensity area on the row, 
%   counted from the left.
%
%   Alexander Meaney, 2015


% Pre-determined geometric properties of scanner
M = 1.916;
effectivePixelSize = 0.050 / M;
Dss = 331;
DssInPixels = Dss / effectivePixelSize;

% Generate sinogram
sino = generatesino(fnam_fp, ftype, n, row, I0_b, I0_e);

% Center and truncate sinogram
centeredsino = sino(:, (cor-range):(cor+range));

% Compute CT reconstruction of slice
slice = ifanbeam(centeredsino', DssInPixels, 'FanSensorGeometry', 'line');

end