% Plot the results of routine SCurveMethod
%
% Santeri Horttanainen and Sauli Lindberg 2015

% Plot parameters
fsize     = 12;
thinline  = .5;
thickline = 2;

% Load reconstruction
load SCurveMethod fbp interpolation interpolationAlpha recn obj alpha nzcoefs

% Load the reconstruction of walnut from 180 degrees
load reconstructslice nut180

% Compute relative errors
err_squ = norm(nut180(:)-recn(:))/norm(nut180(:));

% Normalize the images to be plotted
max180  = max(nut180(:));
maxrecn = max(recn(:));
MAX     = max(max180,maxrecn);
recn    = recn-min(recn(:));
nut180  = nut180-min(nut180(:));
recn    = recn/MAX;
nut180  = nut180/MAX;

% Plot reconstruction image
figure(1)
clf
imagesc([nut180,recn])
colormap gray
axis equal
axis off
title(['Fbp with 180 angles and approximate TV: error ', num2str(round(err_squ*100)), '%'])

figure(2)
clf
imagesc(fbp)
colormap gray
axis equal
axis off
title(['Filtered back projection with 20 angles'])

figure(3)
clf
imagesc(recn)
colormap gray
axis equal
axis off
title(['TV reconstruction: error: ', num2str(round(err_squ*100)), '%'])

figure(4)
clf
imagesc(nut180)
colormap gray
axis equal
axis off
title(['Filtered back projection 180 angles'])

% Plot profile of reconstruction
figure(5)
clf
plot(nut180(end/2,:),'k','linewidth',thinline)
hold on
plot(recn(end/2,:),'r','linewidth',thickline)
xlim([1 size(recn,1)])
axis square
box off
title('Profile of approximate TV reconstruction')

% Plot evolution of objective function
figure(6)
clf
semilogy(obj)
axis square
title('Values of objective function during iteration')

% Plot the S curve 
figure(7)
clf
plot(interpolationAlpha,interpolation)
line('XData', [alpha alpha 0], 'YData', [0 nzcoefs nzcoefs], 'LineStyle', '-.')
axis square
title('S-curve and the point in which the alpha was picked')