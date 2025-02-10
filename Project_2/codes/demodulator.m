function r = demodulator(received_signal, encoding)
% [r1, r2] = demodulator(received_signal)
% The demodulator function takes as argument the received signal and finds
% the components (r1, ...) of every transmitted signal
% The encoding could be either 'psk' or 'fsk'

% period of symbol
T_symbol = 40;
% frequency of symbol
f_symbol = 1 / T_symbol; 
% period of sample
T_sample = 1;
% period of ferousa
T_c = 4;
% frequency of ferousa
f_c = 1 / T_c;
% Energy per symbol
E_s = 1;

% orthogonal pulse
g = sqrt(2 * E_s / T_symbol);

[L_symbol, T_symbol] = size(received_signal);

% demodulation
if encoding == 'psk'
    for t = 1: T_symbol
        y1(t, 1) = g * cos(2 * pi * f_c * t);
        y2(t, 1) = g * sin(2 * pi * f_c * t);
    end

    % calculation of the 2 components
    r = [received_signal * y1, received_signal * y2];
elseif encoding == 'fsk'
    for i = 1: 8
        for t = 1: T_symbol
            y(i, t) = g * cos(2 * pi * ( f_c + i * f_symbol) * t);
        end
    end

    % calculation of the 8 components
    r = received_signal * y';
end

