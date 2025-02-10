function binary_sequence = demapper(symbols, encoding, gray)
% BINARY_SEQUENCE = DEMMAPER( SYMBOLS, ENCODING, GRAY )
%
% INPUT
%	SYMBOLS:	received symbols from detector
%	ENCODING:	encoding <FSK> or <PSK>
%	GRAY:		denotes if is to be used gray (1) encoding or not (0)
% OUTPUT
%	BINARY_SEQUENCE: 	convertion of the received symbols into bits

% if there has been used Gray encoding in the transmitted signal
if gray == 1
    symbols = gray2bin(symbols, encoding, 4);
end

binary_sequence = dec2bin(symbols);

% m: number of lines of the received bits matrix
% n: number of columns of the received bits matrix
[lines, columns] = size(binary_sequence);

% reshape the matrix with the received bits to an array
binary_sequence = reshape(binary_sequence', lines*columns, 1);

% convert to double every character
% in orde to recover the value that this character represents in ASCII code
% we substruct 30(hex) = 48(dec)
% we have assumed that we deal only with character wich represents digits
% that is a valid hypothesis because we deal only with zero and one
binary_sequence = double(binary_sequence) - 48;

end