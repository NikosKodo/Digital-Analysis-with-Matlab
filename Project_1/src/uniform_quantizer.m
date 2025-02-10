function [ xq, centers, bounds ] = uniform_quantizer( x, N, min_value, max_value )
% [XQ, CENTERS, BOUNDS] = UNIFORM_QUANTIZER(X, N, MIN_VALUE, MAX_VALUE)
% DESCRIPTION
%       FUNCTION FOR MY_UNIFORM QUANTIZER
% INPUTS
%   X:            input random signal vector
%   N:            number of using bits
%   MIN_VALUE:    minimum quantization value in bounds of quantization layers
%   MAX_VALUE:    maximum quantization value in bounds of quantization layers
% OUTPUTS
%   XQ:           vector with index elements of output centers
%   CENTERS:      centers of quantization parts
%   BOUNDS:	     vectror with quantization areas

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

%initializing output XQ[ to X[] vector 
xq = x;

% computing ang initializing the up->bounds[:,2] and down ->bounds[:,1]
% quantization areas of fisrt part of quantization
bounds=[min_value:delta_step:max_value-delta_step;min_value+delta_step:delta_step:max_value]';

%computing centers
centers = mean( bounds' )';
% we want the highest quantization layer to correspond to index 1, so we
% flip the vector upside down
centers=flipud(centers);
% quantizing every X[] element >MAX_VALUE to 1st
% area and <MIN_VALUE tolast area. Every else element
% locates to its area it belongs
xq( x>max_value ) = size(bounds, 1);  % locates to first area
xq( x<min_value ) = 1;                  % locates to last area
for i= 1:size(bounds,1)
    % quantizing every element of X[] vector to this
    % area it belong ang XQ[] output vector has values
    % of 'number' of this specific area
    xq(x>=bounds(i,1) & x<=bounds(i,2))=size(bounds,1)-i+1;
end

end