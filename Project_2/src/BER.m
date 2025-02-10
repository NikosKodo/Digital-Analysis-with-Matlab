function bit_error_rate = BER(input, output)
% BIT_ERROR_RATE = BER( INPUT, OUTPUT )
% calculate the Bit Error Rate

% find the length of input array
input_length = length(input);

% see if it can be divided by 2
modular = mod(input_length, 2);

% if not, that means that we send more bits than the length of input
if modular ~= 0
    % calculate the reduntant bits of the output 
    further_elements_to_add = 2 - modular;
    
    % we concatenate at the end of the transmitted string the reduntant
    % bits in order to compare the same ammount of bits at both ends
    input(input_length + further_elements_to_add) = input(input_length);
    input(input_length) = 0;
    %if further_elements_to_add == 2
     %   input(input_length + further_elements_to_add - 1) = 0;
    %end
end

% calculate the bit error rate
bit_error_rate = sum(input ~= output)/length(output);

end
    
