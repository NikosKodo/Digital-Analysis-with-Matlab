function [ binary_sequence ] = binary_input( number_of_elements )
% binary_sequence = binary_input(number_of_elements):
%
% The binary_input is a function that takes as argument the number of
% elements (0, 1) that will be exported in the binary_sequence array

% initialize the binary_sequence with 0 or 1 as elements, that will have the
% same propability
binary_sequence = randsrc(number_of_elements, 1, [0,1]);
end 