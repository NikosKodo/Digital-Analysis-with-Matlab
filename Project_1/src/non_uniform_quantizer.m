function [ xq, centers, D, bounds ] = non_uniform_quantizer( x, N, min_value, max_value )
% [XQ, CENTERS, BOUNDS] = NON_UNIFORM_QUANTIZER(X, N, MIN_VALUE, MAX_VALUE)
% DESCRIPTION
%       FUNCTION FOR NON-UNIFORM QUANTIZER
% INPUTS
%   X:            input random signal vector
%   N:            number of using bits
%   MIN_VALUE:    minimum quantization value in bounds of quantization layers
%   MAX_VALUE:    maximum quantization value in bounds of quantization layers
% OUTPUTS
%   XQ:           vector with index elements of output centers
%   CENTERS:      centers of quantization parts
%   D:            vector with mean() distortion of every Lloyd_max algorithm iteration elements
%   BOUNDS:	  vectror with quantization areas

% check if the input signal vector is in column form
% otherwise we change this automatically
size_of_x = size(x);
if size_of_x(2)~=1 && size_of_x(1)==1
    x = x';
elseif size_of_x(2)~=1 && xsize(1)>1
    error('X must be in column form')
end

% we want to bound the dynamic range of the signal
% but when the signal is already bound in the range we give, meaning
% [min_value,max_value], then there's no need to find ranges where no
% sample exists, so the quantization range becomes [min_value,max_value]
if min_value<min(x)
	min_value=min(x);
end
if max_value>max(x)
	max_value=max(x);
end

% computing delta step of every quantization area
% for Lloyd_max algorithm
delta_step = (max_value - min_value)/2^N;


% computing ang initializing the up->bounds[:,2] and down ->bounds[:,1]
% quantization areas of fisrt part of quantization
bounds=[min_value:delta_step:max_value-delta_step;min_value+delta_step:delta_step:max_value]';

% creating a temporary copy o X[] input vector
% and initializing output XQ[] vector to X[] vector
% and CENTERS[] vector
temp_x = x;
xq     = x;
centers = zeros(size(bounds, 1), 1);

% we sure the fact that every value X[]>MIN_VALUE keeps the
% minimum value and every value X[]>MAX_VALUE keeps th meximum one
temp_x( temp_x<min_value ) = min_value;
temp_x( temp_x>max_value ) = max_value;

% computing new centers call centroids of an area using 
% distribution of X[] vector elements
for i=1:numel(centers)
    % centroid(i) are the mean() of X[] values into every couple of bounds
    centers(i) = mean( temp_x( temp_x>=bounds(i, 1) & temp_x<=bounds(i, 2) ) );
    xq( temp_x>=bounds(i, 1) & temp_x<=bounds(i, 2) ) = centers(i);
end

% first mean distortion in th algorith is equal to zero. After first
% quantization the value of distortion is MEAN( (X-XQ).^2 ).
D = [0 mean( (x-xq).^2) ];
counter = 2;

% start of Lloyd_max algorithm, iteration becomes next
while abs( D(counter) - D(counter-1) )>= eps
    % change first the quantizatiion areas into the mean of
    % centers(i) and centers(i-1) adding the min and max values 
    % in the down and up bounds
    bounds(:, 1) = [min_value; (centers(1: length(centers)-1)+centers(2: length(centers)))/2]';
    bounds(:, 2) = [(centers(1: end-1)+centers(2: end))/2; max_value]';
    
    for i=1:numel(centers)
        % centroid(i) are the mean() of X[] values into every couple of bounds
        centers(i) = mean( temp_x( temp_x>=bounds(i, 1) & temp_x<=bounds(i, 2) ) );
        xq( temp_x>=bounds(i, 1) & temp_x<=bounds(i, 2) ) = centers(i);
    end
    
    % computing new destortion of the iteration
    D = [D mean((x-xq).^2)];
    % plus 1 to counter means next iteration for algorithm
    counter = counter+1;
end

D = D(2:end);
end