function symbols_array = mapper(bin_seq, encoding, gray)
% SYMBOLS_ARRAY = MAPPER(BIN_SEQ, ENCODING, GRAY):
%
% INPUT
%	BIN_SEQ: 	argument a binary sequence
%	ENCODING: 	encoding <FSK> or <PSK>
%	GRAY: 		denotes if is to be used gray (1) encoding or not (0)
% OUTPUT
%	SYMBOLS_ARRAY:  the elements of the transformation into symbols

% the length of input
seq_size = length(bin_seq);

% we group the bits into 2 groups
% the remainder of the sequence is separately converted into one symbol at
% the end
temp = mod(seq_size, 2);

% the sequence which is dividable by 2
new_START = bin_seq(1 : (seq_size - temp), :);

% grouping of that sequence
reshaped_sequence = reshape(new_START, 2, (seq_size - temp) / 2);

% tranform the sequence into binary code for every group of 2 bits
for i = 1: (seq_size - temp) / 2
    symbols_array(i) = bin2dec(num2str(reshaped_sequence(:, i)'));
end 

% the rest of the bits are separately tranformed into a symbol in binary
% code
if temp ~= 0
    symbols_array(i + 1) = bin2dec(num2str(bin_seq(seq_size - temp + 1 :seq_size, 1)'));
end

% if we use gray encoding in order to achieve smaller distance among two
% symbols which are adjacent, we encode the symbols into Gray by using the
% following function bin2gray
if gray == 1
    symbols_array = bin2gray(symbols_array, encoding, 8);
end
