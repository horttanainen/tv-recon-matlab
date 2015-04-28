function [ slice centeredsino2 ] = reconstructslice2(fnam_fp, ftype, n, cor, range, row, I0_b, I0_e)
%RECONSTRUCTSLICE2 Reconstruct CT slice from projection data, images shown
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

%'Pahkina','tif',180,1189,512,1200,20,700


% Pre-determined geometric properties of scanner
%M = 1.916;
%effectivePixelSize = 0.050 / M;
%Dss = 331;
%DssInPixels = Dss / effectivePixelSize;

% Parameters in ginger measurement 19.2.2015
Dsd = 634; % Source-detector distance, unit: mm
Dss = 634 - 53; % Source-sample distance, unit: mm
M = Dsd / Dss; % Geometric magnification, unit: no dimension
effectivePixelSize = 0.050 / M; % Unit: mm
DssInPixels = Dss / effectivePixelSize; % Unit: pixels

% Generate sinogram
sino = generatesino2(fnam_fp, ftype, n, row, I0_b, I0_e);

% Center and truncate sinogram
centeredsino = sino(:, (cor-range):(cor+range));

% -Transpoosi
% -Harvat rivit / projektiot sämpläys sinogrammista
% -Vektorimuotoon

figure('Name', 'Truncated and centered sinogram');
imshow(centeredsino, []);

centeredsino2 = centeredsino;

% Compute CT reconstruction of slice
%slice = ifanbeam(centeredsino', DssInPixels, 'FanSensorGeometry', 'line');
slice = iradon(centeredsino', 0:9:179);

% Adjust CT slice for better visualization
slicevis = slice - min(slice(:));
slicevis = slicevis / max(slicevis(:));
slicevis = slicevis.^0.7;
figure('Name', 'Recontructed CT slice');
imshow(slicevis, []);

end