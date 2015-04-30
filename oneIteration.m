% Paramaters
MAXITER     = 12000;
beta        = .000001;
alpha       = 0.2127;

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
measang = -90+[0:9:171];

% Compute the Total Variation regularization of mncn with current alpha
[ recn alpha obj smallestObjValue ] = TotalVariationFunction(alpha, MAXITER, beta, mncn, measang, target);

save oneIteration recn alpha obj fbp target mncn
exit
