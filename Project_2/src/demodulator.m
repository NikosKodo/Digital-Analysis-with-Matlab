function r = demodulator(received_signal, encoding)
% R = DEMODULATOR(RECEIVED_SIGNAL, ENCODING)
%
% INPUT
%	RECEIVED_SIGNAL: signal with AWGN
%	ENCODING:		 encoding <FSK> or <PSK>
% OUTPUT
%	R:	components [r1,r2] of every transmitted signal


T_symbol = 40;				% period of symbol
f_symbol = 1 / T_symbol; 	% frequency of symbol
T_sample = 1;				% period of sample
T_c = 4;					% period of ferousa
f_c = 1 / T_c;				% frequency of ferousa
E_s = 1;					% Energy per symbol

% orthogonal pulse
pulse = sqrt(2 * E_s / T_symbol);

[L_symbol, T_symbol] = size(received_signal);

% demodulation
if encoding == 'PSK'
    for t = 1: T_symbol
        y1(t, 1) = pulse * cos(2 * pi * f_c * t);
        y2(t, 1) = pulse * sin(2 * pi * f_c * t);
    end

    % calculation of the 2 components
    r = [received_signal * y1, received_signal * y2];
elseif encoding == 'FSK'
    for i = 1: 4
        for t = 1: T_symbol
            y(i, t) = pulse * cos(2 * pi * ( f_c + i * f_symbol) * t);
        end
    end

    % calculation of the 4 components
    r = received_signal * y';
end

end
