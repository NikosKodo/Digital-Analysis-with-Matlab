function probability=layer_probability(x,N,min_value,max_value,type)
% PROPBABILITY = LAYER_PROBABILITY(X,N,MIN_VALUE,MAX_VALUE,TYPE)
% DESRIPTION
%       FUNCTION FOR LAYER_PROBABILITY FINDING
% INPUTS
%   X:            input random signal vector
%   N:            number of using bits
%   MIN_VALUE:    minimum quantization value in bounds of quantization layers
%   MAX_VALUE:    maximum quantization value in bounds of quantization layers
%   TYPE:         is an input string depentinding of type of using quantization
% OUTPUTS
%   PROPBABILITY: is a vector containing the probability of each layer

% initialize a symbolic variable to compute the integral of each one of
% elements of the vector
syms z;
% initialize the probability vector
probability = zeros(2^N+2,1);

% check the type of quantization
if strcmp(type,'uni')
    % we need the bounds of quantization areas so we use the
    % uniform_quantization function
    [~, ~, bounds] = uniform_quantizer(x, N, min_value, max_value);
    % probability for bound [-oo, 0] is zero
    probability(1) = 0;
    % probability for bound [4, +oo] is integral fz() z=4 to +oo
    probability(end) = double(int(exp(-z),4,Inf));
    % we compute the rest of the probabilities  
    for i=1:size(bounds,1)
        probability(i+1) = double(int(exp(-z),bounds(i,1),bounds(i,2)));
    end
elseif strcmp(type,'non')
    % uniform_quantization function
    [~, ~, ~, bounds] = non_uniform_quantizer(x, N, min_value, max_value);
    % probability for bound [-oo, 0] is zero
    probability(1) = 0;
    % probability for bound [4, +oo] is integral fz() z=4 to +oo
    probability(end) = double(int(exp(-z),4,Inf));
    % we compute the rest of the probabilities  
    for i=1:size(bounds,1)
        probability(i+1) = double(int(exp(-z),bounds(i,1),bounds(i,2)));
    end
else
    % display an error message
    error('ERROR: PROPBABILITY = LAYER_PROBABILITY(X,N,MIN_VALUE,MAX_VALUE,TYPE) TYPE must belong in {UNI, NON}');
end