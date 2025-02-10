function symbols = decision_device(r, encoding)
% SYMBOLS = DECISION_DEVICE(R, ENCODING)
%
% INPUT
%	R: 				 components [r1,r2,..] of every transmitted signal
%	ENCODING:		 encoding <FSK> or <PSK>
% OUTPUT
%	SYMBOLS:		the binary (or gray) symbols that was to be send

[line_size, ~] = size(r);
    
if encoding == 'PSK'
    % calculates each possible received symbol
    for i = 1: 4
        s(i, 1) = cos( 2 * pi * i / 4 );
        s(i, 2) = sin( 2 * pi * i / 4 );
    end
  
    % calculates the symbol which presents the greatest propability to
    % be the sent symbol
    for j =1: line_size
        for i = 1: 4
            temp(i, 1) = norm([r(j,1), r(j,2)] - s(i,:));
        end
        [min_diff, symbols(j, 1)] = min(temp);
		
    end

	% the 4th symbol is actually the 0th symbol
	symbols = mod(symbols,4);    
elseif encoding == 'FSK'
    
    T_symbol = 40;			 % period of symbol
    f_symbol = 1 / T_symbol; % frequency of symbol
	
	tmp_symbol = zeros(1, line_size);
    % calculates the symbol which presents the greatest probability to
    % be the sent symbol
    tmp_symbol = [0: 3];
	for j =1: line_size
		index = logical(round(abs(r(j, :))));
        if isempty(tmp_symbol(index))
			symbols(j) = 0;
		else
			symbols(j) = max( tmp_symbol(index) );
    end
end

% the 4th symbol is actually the 0th symbol
symbols = mod(symbols,4);

end