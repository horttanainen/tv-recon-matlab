function [ recn alpha obj smallestObjValue ] = TotalVariationFunction( alpha, MAXITER, beta, mncn, measang, target )
% Here we use the Barzilai and Borwain optimization method
% to find the minimum of the regularized penalty functional
%
%		1/2 (Af - m)^T (Af - m) + alpha*sum(sqrt((f_i-f_j)^2+beta))
%
% with the sum ranging over i and j indexing all horizontally
% and vertically neighboring pixel pairs.
%
% The approximation results from the positive constant beta rounding the
% non-differentiable corner of the absolute value function. This way the
% penalty functional becomes differentiable and thus efficiently optimizable.
%
% The following routine must be precomputed: XRsparseA_NoCrimeData_comp.m.
%
% Jennifer Mueller and Samuli Siltanen, March 2014

% linesearch ja iteraatiossa korjaus jotta ei pysähdyttäisi piikkiin!

[N,tmp] = size(target);

% Incomprehensible correction factor. It is related to the way Matlab
% normalizes the output of iradon.m. The value is empirically found and
% tested to work to reasonable accuracy.
corxn = 40.7467*N/64;

% Optimization routine
obj    = zeros(MAXITER+1,1);     % We will monitor the value of the objective function
fold   = zeros(size(target));    % Initial guess
gold   = XR_aTV_fgrad(fold,mncn,measang,corxn,alpha,beta);
obj(1) = XR_aTV_feval(fold,mncn,measang,alpha,beta);

% Make the first iteration step. Theoretically, this step should satisfy
% the Wolfe condition, see [J.Nocedal, Acta Numerica 1992].
% We use a simple line search method to compute a steplength so the new
% value is smaller than the initial guess.
t = .0001;
tvec = (10).^linspace(-1,-6);

for zzz = 1:length(tvec)
    fnew  = max(fold - tvec(zzz)*gold,0);
    firstValue = obj(1);
    newValue   = XR_aTV_feval(fnew,mncn,measang,alpha,beta);
    if firstValue>newValue
        t = tvec(zzz);
        break;
    end
    
end

% Compute new iterate point fnew and gradient gnew at fnew
fnew = max(fold - t*gold,0);
gnew = XR_aTV_fgrad(fnew,mncn,measang,corxn,alpha,beta);

% Iteration counter
its = 1;

% Record value of objective function at the new point
OFf        = XR_aTV_feval(fnew,mncn,measang,alpha,beta);
obj(its+1) = OFf;

% Keep record of the smallest obj value so the iteration doestn stop at a
% spike
smallestObjValue    = obj(1);
recnAtTheSmall      = fnew;

% Barzilai and Borwein iterative minimization routine
while (its  < MAXITER)
    its = its + 1;
    
    % Compute steplength alpha
    fdiff   = fnew - fold;
    gdiff   = gnew - gold;
    steplen = (fdiff(:).'*fdiff(:))/(fdiff(:).'*gdiff(:));
    
    % Update points, gradients and objective function value
    fold = fnew;
    gold = gnew;
    fnew = max(fnew - steplen*gnew,0);
    gnew = XR_aTV_fgrad(fnew,mncn,measang,corxn,alpha,beta);
    OFf  = XR_aTV_feval(fnew,mncn,measang,alpha,beta);
    obj(its+1) = OFf;
    format short e
    % Monitor the run
    disp(['Iteration ', num2str(its,'%4d'),', objective function value ',num2str(obj(its),'%.3e')])
    smallestObjValue    = min(smallestObjValue,OFf);
    if smallestObjValue == OFf
        recnAtTheSmall      = fnew;
    end
end   % Iteration while-loop
recn = recnAtTheSmall;

end

