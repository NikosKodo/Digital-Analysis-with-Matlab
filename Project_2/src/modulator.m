function s_m = modulator(symbols_array, encoding)
% S_M = MODULATOR(SYMBOLS_ARRAY, ENCODING)
%
% INPUT
%	SYMBOLS_ARRAY:	symbols array that are to be transmitted
%	ENCODING:		encoding <FSK> or <PSK>
% OUTPUT
%	S_M:			the modulated signal

% size of the array that has the sequence converted into symbols
sym_array_size = length(symbols_array);

T_symbol = 40;			 % period of symbol
f_symbol = 1 / T_symbol; % frequency of symbol
T_sample = 1;			 % period of sample
T_c = 4;				 % period of ferousa
f_c = 1 / T_c;			 % frequency of ferousa
E_s = 1;				 % Energy per symbol

% orthogonal pulse
pulse = sqrt(2 * E_s / T_symbol);

% initialization of the symbols that we send 
s_m = zeros(sym_array_size, T_symbol / T_sample);

% computation of the transmitted signal
if encoding == 'PSK'
    for i = 1: sym_array_size
        for t = 1: T_symbol/T_sample
            s_m(i, t) = pulse * cos( 2*pi*f_c*t - 2*pi*symbols_array(i)/4 );
        end
    end
elseif encoding == 'FSK'
    for i = 1: sym_array_size
        for t = 1: T_symbol/T_sample
            s_m(i, t) = pulse * cos(2 * pi * (f_c + symbols_array(i) * f_symbol) * t);
        end
    end
end

end
