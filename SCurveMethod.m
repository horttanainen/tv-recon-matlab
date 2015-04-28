% Paramaters
N           = 778;
MAXITER     = 2000;
beta        = .000001;
epsilon     = 0.001;
alphavec    = 10.^linspace(-6,4,20);
loop        = length(alphavec(:));

% Compute the simulated tomographic measurement data
%[mncn measang target ] = A_NoCrimeData_comp(noiselevel, N, Nang);

% load the tomographic measurement data
load measurement sino im

mncn = sino;
mncn = mncn.';
%mncn = mncn(:);
target = phantom('Modified Shepp-Logan',N);
measang = -90+[0:9:171];

% Compute the amount of nonzero coefficients in target
nzcoefs = NonZeroCoefficients(target,epsilon);

% Matrix to store data from loop
data = [loop,1];

parfor iii = 1:loop

% Compute the Total Variation regularization of mncn with current alpha
[ recn alpha obj smallestObjValue ] = TotalVariationFunction(alphavec(iii), MAXITER, beta, mncn, measang, target);

% Compute the number of nonzero coefficients
%nzrecn = NonZeroCoefficients(recn,epsilon);
nzrecn = 2.1930e+05;

% Store the data
data(iii,1) = nzrecn;

end

% Interpolate the data
querypoints = 10.^linspace(-6,4,400);
interpolation = interp1(alphavec,data(:,1),querypoints,'spline');

% Optimal alpha
tmp = abs(interpolation-nzcoefs);
[index index] = min(tmp);
alpha = interpolation(index);

% Last reconstruction
[ recn alpha obj smallestObjValue ] = TotalVariationFunction(alpha, MAXITER, beta, mncn, measang, target);

save SCurveMethod interpolation recn target obj alpha nzcoefs smallestObjValue
exit
