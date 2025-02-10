function [ binary_sequence ] = binary_input( num_el )
% BINARY_SEQUENCE = BINARY_INPUT( NUM_EL )
%
% INPUT
%   NUMEL: number of elements (0, 1) that will be exported in the binary_sequence array
% OUTPUT
%   BINARY_SEQUENCE: the binary_sequence array

% initialize the binary_sequence with 0 or 1 as elements, that will have the
% same propability
binary_sequence = randsrc(num_el, 1, [0,1]);
end