function received_signal = noise(s_m, SNR)
% received_signal = noise(s_m)
% The noise function takes as argument the s_m signal that is to be
% transmitted and the SNR and adds AWGN

% we solve the equation
% 10 * log_10(E_b / N_0) = SNR
% and try to find N_0
% given that
E_s = 1; % and
E_b = E_s / 3;
% we have as a result
N_0 = E_b / (10^(SNR/10));

% We create a gaussian distribution with mean value:
m = 0;
% and standard deviation
sigma = sqrt(N_0 / 2);

% the noise is added to every sample taken by the modulator
% for that reason, the derived array has to have the same dimensions as the
% array of the samples
[L_symbol, T_symbol] = size(s_m);

% produce AWGN
noise = m + sigma * randn(L_symbol, T_symbol);

% adds it to the signal
received_signal = s_m + noise;



