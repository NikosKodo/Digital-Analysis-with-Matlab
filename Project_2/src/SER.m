function symbol_error_rate = SER(input, output)
% SYMBOL_ERROR_RATE = SER( INPUT, OUTPUT )
% calculate the Symbol Error Rate

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
    if further_elements_to_add == 2
        input(input_length + further_elements_to_add - 1) = 0;
    end
end

% grouping of that sequence
reshaped_input = reshape(input, 2, length(input)/2);
reshaped_output = reshape(output, 2, length(output)/2);
% tranform the sequences into binary code for every group of 2 bits
for i = 1: length(input) / 2
    symbols_input(i) = bin2dec(num2str(reshaped_input(:, i)'));
    symbols_output(i) = bin2dec(num2str(reshaped_output(:, i)'));
end 

% calculate the symbol error rate
symbol_error_rate = sum(symbols_input ~= symbols_output)/length(input);

end
    
