function [ sinoabs ] = generatesino(fnam_fp, ftype, n, row, I0_b, I0_e)
%GENERATESINO Generate sinogram from projection data
%
%   A = generatesino(fnam_firstpart, ftype, n, row, I_0_begin, I_0_end)
%
%   fnam_fp = First part of the filenames. For example, if the
%   projection files are labeled 'tomoscan0001.tif' etc. the first part
%   is 'tomoscan'.
%
%   ftype = File type, e.g. 'tif', 'png', etc.
%
%   n = Number of projections.
%
%   row = Row number of sinogram to be generated, counted from the top row.
%
%   I0_b = First pixel of the the I_0 intensity area on the row, 
%   counted from the left.
%
%   I0_e = Last pixel of the the I_0 intensity area on the row, 
%   counted from the left.
%
%   Alexander Meaney, 2014



% Read first image of stack
filename = 'empty';
A = double(imread([fnam_fp '001.' ftype]));
[~, width] = size(A);

% Create empty matrix for detector data
sinoproj = zeros(n, width);

% Collect projection data into matrix
for i = 1:n
    if i < 10
        filename = [fnam_fp '00' num2str(i) '.' ftype];
    elseif i < 100
        filename = [fnam_fp '0' num2str(i) '.' ftype];
    else 
        filename = [fnam_fp num2str(i) '.' ftype];
    end
    disp(['Processing file ' filename]); 
    
    A = double(imread(filename));
    sinoproj(i, :) = A(row, :);
end
 
% Create empty matrix for absorption sinogram
sinoabs = zeros(n, width);
    
% Compute absorption sinogram
for i = 1:n
    I_0 = mean(sinoproj(i, I0_b:I0_e));
    sinoabs(i, :) = - log(sinoproj(i, :) ./ I_0);
end
    
end

