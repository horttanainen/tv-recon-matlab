% Plot the results of routine SCurveMethod
%
% Santeri Horttanainen and Sauli Lindberg 2015

% Plot parameters
fsize     = 12;
thinline  = .5;
thickline = 2;

% Load reconstruction
load SCurveMethod interpolation recn target obj alpha nzcoefs

% Plot reconstruction image
figure(1)
clf
imagesc(recn)
colormap gray
axis equal
axis off
title(['Approximate TV'])

% Plot profile of reconstruction
figure(2)
clf
plot(target(end/2,:),'k','linewidth',thinline)
hold on
plot(recn(end/2,:),'k','linewidth',thickline)
xlim([1 size(recn,1)])
axis square
box off
title('Profile of approximate TV reconstruction')

% Plot evolution of objective function
figure(3)
clf
semilogy(obj,'*-')
axis square
title('Values of objective function during iteration')

% Plot the S curve 
figure(4)
clf
semilogx(interpolation)
line('XData', [alpha alpha 0], 'YData', [0 nzcoefs nzcoefs], 'LineStyle', '-.')
axis square
title('Number of nonzero wavelet coefficients')



