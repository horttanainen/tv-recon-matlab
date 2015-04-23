function [ nonzeroCoefficients ] = NonZeroCoefficients( target, epsilon )
%NONZEROCOEFFICIENTS Computes the number of nonzero coefficients of a
%fourier transform of the target.

% Fast fourier transform
fftTarget = fft2(target);

% Normalize the fourier transform
fftTarget = abs(fftTarget);
fftTarget = fftTarget-min(fftTarget(:));
fftTarget = fftTarget/max(fftTarget(:));

% Put coefficients below a small threshold to zero
fftTarget(fftTarget<epsilon)=0;

% Calculate the amount of zero coefficients
nonzeroCoefficients = nonzeros(fftTarget);
nonzeroCoefficients = length(nonzeroCoefficients(:));

end

