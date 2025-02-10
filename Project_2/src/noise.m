function received_signal = noise(s_m, SNR)
% RECEIVED_SIGNAL = NOISE(S_M, SNR)
% 
% INPUT
%	S_M:  the modulated signal
%	SNR:  the SNR
% OUTPUT
%	RECEIVED_SIGNAL: signal with AWGN

% given that
E_s = 1; 
E_b = E_s / 3;

% we solve the equation
% 10 * log_10(E_b / N_0) = SNR
% and we have as a result
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

end