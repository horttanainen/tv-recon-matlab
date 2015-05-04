% Main file. No other files needed to run before this. Computes TV
% reconstruction with chosen parameters. S-curve method is used to find the
% most suitable value for alpha based on the amount of nonzero coefficients in
% the Fourier transformation. Most of the algorithms are based on work done
% by Samuli Siltanen and Jennifer Mueller.
%
% Santeri Horttanainen and Sauli Lindberg

% Paramaters
MAXITER     = 200;
beta        = .000001;
epsilon     = 0.0002;
alphas      = 20;
alphavec    = 10.^linspace(-6,1,alphas);
loop        = length(alphavec(:));

% load the tomographic measurement data and images of sawn walnuts
load measurement sino im
nut1 = imread('pahkina_1.tif');
nut1 = nut1(:,:,1);
nut2 = imread('pahkina_2.tif');
nut2 = nut2(:,:,1);

% fbp is the filtered back projection of the original nut with 20 angles provided by
% Alexander Meaney.
fbp = im;

target = nut1(2:end-1,2:end-1);
mncn = sino;
mncn = mncn.';
measang = -90+[0:9:171];

% Compute the average of nonzero coefficients in sawn walnuts
nzcoefs1 = NonZeroCoefficients(nut1,epsilon);
nzcoefs2 = NonZeroCoefficients(nut2,epsilon);
nzcoefs  = (nzcoefs1+nzcoefs2)/2;

% Matrix to store data from loop
data = linspace(1,loop,loop);

for iii = 1:loop

% Compute the Total Variation regularization of mncn with current alpha
[ recn alpha obj smallestObjValue ] = TotalVariationFunction(alphavec(iii), MAXITER, beta, mncn, measang, target);

% Compute the average number of nonzero coefficients from the sawn walnuts.
nzrecn = NonZeroCoefficients(recn,epsilon);

% Store the data
data(iii) = nzrecn;

end

% Interpolate the data
querypoints         = 10.^linspace(-6,1,400);
interpolation       = interp1(alphavec,data,querypoints,'spline');
interpolationAlpha  = interp1(alphavec, alphavec,querypoints,'spline');

% Optimal alpha
tmp = abs(interpolation-nzcoefs);
[value index] = min(tmp);
alpha = interpolationAlpha(index);

% Last reconstruction. Note that there is 300 extra iterations added to this
% one
[ recn alpha obj smallestObjValue ] = TotalVariationFunction(alpha, (MAXITER+300), beta, mncn, measang, target);

save SCurveMethod fbp interpolation interpolationAlpha recn target obj alpha nzcoefs smallestObjValue

SCurveMethod_plot