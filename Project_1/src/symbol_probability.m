function probability=symbol_probability(x,N,min_value,max_value,type)
% PROPBABILITY = SYMBOL_PROBABILITY(X,N,MIN_VALUE,MAX_VALUE,TYPE)
% DESRIPTION
%       FUNCTION FOR LAYER_PROBABILITY FINDING
% INPUTS
%   X:            input image transformed to [-1,1] in column vector form
%   N:            number of using bits
%   MIN_VALUE:    minimum quantization value in bounds of quantization layers
%   MAX_VALUE:    maximum quantization value in bounds of quantization layers
%   TYPE:         is an input string depentinding of type of using quantization
% OUTPUTS
%   PROPBABILITY: is a vector containing the probability of each symbol

% initialize a symbolic variable to compute the integral of each one of
% elements of the vector
syms z;
% initialize the probability vector
probability = zeros(2^N,1);

% check the type of quantization
if strcmp(type,'uni')
    % we need the bounds of quantization areas so we use the
    % uniform_quantization function
    [~, ~, bounds] = uniform_quantizer(x, N, min_value, max_value);
   
    % we compute the probabilities  
    for i=1:size(bounds,1)
        probability(i+1) = numel(x(x>=bounds(i,1) & x<bounds(i,2)))/numel(x);
    end
    probability(i) = probability(i)+numel(x(x==bounds(i,2)))/numel(x);
elseif strcmp(type,'non')
    % uniform_quantization function
    [~, ~, ~, bounds] = non_uniform_quantizer(x, N, min_value, max_value);
    
    % we compute the probabilities  
    for i=1:size(bounds,1)
        probability(i+1) = numel(x(x>=bounds(i,1) & x<bounds(i,2)))/numel(x);
    end
    probability(i)=probability(i)+numel(x(x==bounds(i,2)))/numel(x);
else
    % display an error message
    error('ERROR: PROPBABILITY = SYMBOL_PROBABILITY(X,N,MIN_VALUE,MAX_VALUE,TYPE) TYPE must belong in {UNI, NON}');
end