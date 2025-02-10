function symbols = foratis(r, encoding)
% symbols = foratis(r1, r2)
% The foratis function takes the r argument and calculates the
% binary (or gray) symbols that was to be send
% The encoding could be either 'psk' or 'fsk'

[r_lines, r_columns] = size(r);
    
if encoding == 'psk'
    % calculates each possible received symbol
    for i = 1: 8
        s(i, 1) = cos( 2 * pi * i / 8 );
        s(i, 2) = sin( 2 * pi * i / 8 );
    end
  
    % calculates the symbol which presents the greatest propability to
    % be the sent symbol
    for j =1: r_lines
        for i = 1: 8
            temp(i, 1) = norm([r(j,1), r(j,2)] - s(i,:));
        end
        [min_diff, symbols(j, 1)] = min(temp); 
    end
    
elseif encoding == 'fsk'
    % period of symbol
    T_symbol = 40;
    % frequency of symbol
    f_symbol = 1 / T_symbol;

    % calculates the symbol which presents the greatest probability to
    % be the sent symbol
    for j =1: r_lines
        [max_diff, symbols(j,1)] = max( r(j, :) );
    end
end

% the 8th symbol is actually the 0th symbol
symbols = mod(symbols,8);