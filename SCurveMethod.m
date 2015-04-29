% Paramaters
<<<<<<< HEAD
N           = 780;
MAXITER     = 20;
=======
N           = 778;
MAXITER     = 1000;
>>>>>>> b4551607899e00d46418ac287671d6a2f7911610
beta        = .000001;
epsilon     = 0.001;
alphas      = 20;
alphavec    = 14.^linspace(-6,4,alphas);
loop        = length(alphavec(:));

% Compute the simulated tomographic measurement data
%[mncn measang target ] = A_NoCrimeData_comp(noiselevel, N, Nang);

% load the tomographic measurement data and images of sawn walnuts
load measurement sino im
nut1 = imread('pahkina_1.tif');
nut1 = nut1(:,:,1);
nut2 = imread('pahkina_2.tif');
nut2 = nut2(:,:,1);

% fbp is the filtered back projection of the original nut provided by
% Alexander Meaney.
fbp = im;

target = nut1(2:end-1,2:end-1);
mncn = sino;
mncn = mncn.';
measang = -90+[0:9:171]; % Maybe this should be modified to 0:9:170 or 0:9:179 ??

<<<<<<< HEAD
% Compute the average of nonzero coefficients in sawn walnuts
nzcoefs1 = NonZeroCoefficients(nut1,epsilon);
nzcoefs2 = NonZeroCoefficients(nut2,epsilon);
nzcoefs  = (nzcoefs1+nzcoefs2)/2;
=======
% Compute the amount of nonzero coefficients in target
%nzcoefs = NonZeroCoefficients(target,epsilon);
nzcoefs = 2.1930e+05;
>>>>>>> b4551607899e00d46418ac287671d6a2f7911610

% Matrix to store data from loop
data = linspace(1,loop,loop);

for iii = 1:loop

% Compute the Total Variation regularization of mncn with current alpha
[ recn alpha obj smallestObjValue ] = TotalVariationFunction(alphavec(iii), MAXITER, beta, mncn, measang, target);

<<<<<<< HEAD
% Compute the average number of nonzero coefficients from the sawn walnuts. 
=======
% Compute the number of nonzero coefficients
>>>>>>> b4551607899e00d46418ac287671d6a2f7911610
nzrecn = NonZeroCoefficients(recn,epsilon);

% Store the data
data(iii) = nzrecn;

end

% Interpolate the data
querypoints         = 14.^linspace(-6,4,400);
interpolation       = interp1(alphavec,data,querypoints,'spline');
interpolationAlpha  = interp1(alphavec, alphavec,querypoints,'spline');

% Optimal alpha
tmp = abs(interpolation-nzcoefs);
[value index] = min(tmp);
alpha = interpolationAlpha(index);

% Last reconstruction
[ recn alpha obj smallestObjValue ] = TotalVariationFunction(alpha, MAXITER, beta, mncn, measang, target);

save SCurveMethod fbp interpolation interpolationAlpha recn target obj alpha nzcoefs smallestObjValue
exit
