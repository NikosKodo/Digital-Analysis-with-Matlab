function SER = ser(input, output)
% SER = ser(input, output)
% calculate the symbol error rate

% find the length of input array
length_of_input = length(input);

% see if it can be divided by 3
modular = mod(length_of_input, 3);

% if not, that means that we send more bits than the length of input
if modular ~= 0
    % calculate the reduntant bits of the output 
    further_elements_to_add = 3 - modular;
    
    % we concatenate at the end of the transmitted string the reduntant
    % bits in order to compare the same ammount of bits at both ends
    input(length_of_input + further_elements_to_add) = input(length_of_input);
    input(length_of_input) = 0;
    if further_elements_to_add == 2
        input(length_of_input + further_elements_to_add - 1) = 0;
    end
end

% grouping of that sequence
reshaped_input = reshape(input, 3, length(input)/3);
reshaped_output = reshape(output, 3, length(output)/3);
% tranform the sequences into binary code for every group of 3 bits
for i = 1: length(input) / 3
    symbols_input(i) = bin2dec(num2str(reshaped_input(:, i)'));
    symbols_output(i) = bin2dec(num2str(reshaped_output(:, i)'));
end 

% calculate the symbol error rate
SER = sum(symbols_input ~= symbols_output)/length(input);
    
