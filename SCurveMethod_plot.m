% Plot the results of routine SCurveMethod
%
% Santeri Horttanainen and Sauli Lindberg 2015

% Plot parameters
fsize     = 12;
thinline  = .5;
thickline = 2;

% Load reconstruction
load SCurveMethod fbp interpolation interpolationAlpha recn obj alpha nzcoefs

% Load the reconstruction of walnut from 180 degrees and the sawn walnuts
load reconstructslice nut180
sawnut1 = imread('pahkina_1.tif');
sawnut2 = imread('pahkina_2.tif');
sawnut1 = sawnut1(:,:,1);
sawnut2 = sawnut2(:,:,1);

recn = rot90(recn);

% Compute relative errors

% Error in TV reconstruction
err_squ = norm(nut180(:)-recn(:))/norm(nut180(:));

% Error in fbp reconstruction with 20 angles
fbp = fbp(2:end-1,2:end-1);
err_squ_fbp = norm(nut180(:)-fbp(:))/norm(nut180(:));

% Normalize the images to be plotted
recn    = recn-min(recn(:));
nut180  = nut180-min(nut180(:));
fbp     = fbp-min(fbp(:));
max180  = max(nut180(:));
maxrecn = max(recn(:));
maxfbp  = max(fbp(:));

recn    = recn/maxrecn;
nut180  = nut180/max180;
fbp     = fbp/maxfbp;

% Little gamma to fbp recosntructions 
nut180  = nut180.^1.8;
fbp     = fbp.^1.8;

% Plot reconstruction image with fbp 180 angles
fig1 = figure(1);
clf
imagesc([nut180,recn])
colormap gray
axis equal
axis off
saveas(fig1, 'fbp180andTV.pdf', 'pdf')
title(['Fbp with 180 angles and approximate TV: error ', num2str(round(err_squ*100)), '%'])


% fbp 20 and 180 angles with TV reconstruction 
fig2 = figure(2);
clf
imagesc([nut180,recn,fbp])
colormap gray
axis equal
axis off
saveas(fig2, 'fbp180and20plusTV.pdf', 'pdf')
title(['Fbp with 180 angles and approximate TV: error ', num2str(round(err_squ*100)), '%'])

% TV reconstruction alone
fig3 = figure(3);
clf
imagesc(recn)
colormap gray
axis equal
axis off
saveas(fig3, 'TV.pdf', 'pdf')
title(['TV reconstruction: error: ', num2str(round(err_squ*100)), '%'])

% fbp with 180 angles "ground truth"
figure(4)
clf
imagesc(nut180)
colormap gray
axis equal
axis off
title(['Filtered back projection 180 angles'])

% Profile of reconstruction
fig5 = figure(5);
clf
plot(nut180(end/2,:),'k','linewidth',thinline)
hold on
plot(recn(end/2,:),'r','linewidth',thickline)
xlim([1 size(recn,1)])
axis square
box off
saveas(fig5, 'profile.pdf', 'pdf')
title('Profile of approximate TV reconstruction')

% Evolution of objective function
fig6 = figure(6);
clf
semilogy(obj)
axis square
saveas(fig6, 'objective.pdf', 'pdf')
title('Values of objective function during iteration')

% S curve
fig7 = figure(7);
clf
semilogx(interpolationAlpha,interpolation)
hold on
line('XData', [alpha alpha], 'YData', [0 nzcoefs], 'LineStyle', '-.')
axis square
saveas(fig7, 'scurve.pdf', 'pdf')
title('S-curve and the point in which the alpha was picked')

% Nuts used to evaluate suitable value for zero coefficients
fig8 = figure(8);
clf
imagesc([sawnut1,sawnut2])
colormap gray
axis equal
axis off
saveas(fig8, 'sawnuts.pdf', 'pdf') 