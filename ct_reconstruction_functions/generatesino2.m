function [ sinoabs ] = generatesino2(fnam_fp, ftype, n, row, I0_b, I0_e)
%GENERATESINO2 Generate sinogram from projection data, sinograms shown
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
%   Alexander Meaney, 2015



% Set color scheme for plots
co = [0 0 1;
      0 0.7 0;
      1 0 0;
      0 0.75 0.75;
      0.75 0 0.75;
      1 0.7 0;
      0.25 0.25 0.25];
set(0,'defaultAxesColorOrder',co)

% Read first image of stack
filename = 'empty';
A = double(imread([fnam_fp '001.' ftype]));
[~, width] = size(A);

% Adjust image for better visualization
Avis = A - min(A(:));
Avis = Avis / max(A(:));
Avis = Avis.^0.5;

% Show first projection
figure('Name', 'Projection at angle 0');
imshow(Avis, [0.2 0.85]);
rectangle('position', [1 row 2368 1], 'EdgeColor', 'red', 'LineWidth', 2);

% Show attenuation profile of detector row to be reconstructed
figure('Name', 'Attenuation profile of projection at angle 0');
plot(1:2240, A(row, :), 'LineWidth', 2);
hold all;
plot(I0_b:I0_e, A(row, I0_b:I0_e), 'LineWidth', 2);
%axis([0 2240 300 2800]);
xlabel('Pixel number', 'FontSize', 12);
ylabel('Grayscale value', 'FontSize', 12);
h_legend = legend('Attenuation profile', 'Values used to determine I_0');
set(h_legend,'FontSize', 12);
set(h_legend,'Location', 'northeast');

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

% Show projection sinogram
figure('Name', 'Projection sinogram');
imshow(sinoproj, []);
rectangle('position', [I0_b 1 (I0_e - I0_b) n], 'EdgeColor', 'red', 'LineWidth', 2);
    
% Compute absorption sinogram
for i = 1:n
    I_0 = mean(sinoproj(i, I0_b:I0_e));
    sinoabs(i, :) = - log(sinoproj(i, :) ./ I_0);
end

% Show values of line integral at angle 0
figure('Name', 'Line integral at angle 0');
plot(1:2240, sinoabs(1, :), 'LineWidth', 2);
%axis([0 2240 -0.2 2]);
xlabel('Pixel number', 'FontSize', 12);
ylabel('-ln(I / I_0)', 'FontSize', 12);

% Show absorption sinogram
figure('Name', 'Line integral sinogram');
imshow(sinoabs, []);
    
end
