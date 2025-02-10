clear; clc;
bits = 10^5;

count = 1;
x = [0: 2: 12];

for SNR = 0: 2: 12
	
	Pb(count, 1) = 5*erfc(sqrt( (10^SNR)/10 ));
        
    input_binary_sequence 	= binary_input(bits);
    symbols_array 			= mapper(input_binary_sequence, 'FSK', 0);
    s_m 					= modulator(symbols_array , 'FSK');
    received_signal 		= noise(s_m ,SNR);
    r 						= demodulator(received_signal, 'FSK');
    symbols 				= decision_device(r, 'FSK');
    output_binary_sequence 	= demapper(symbols', 'FSK', 0);
    BER_fsk(count, 1) 		= BER(input_binary_sequence, output_binary_sequence);
     
    input_binary_sequence 	= binary_input(bits);
    symbols_array 			= mapper(input_binary_sequence, 'PSK', 0);
    s_m 					= modulator(symbols_array, 'PSK');
    received_signal			= noise(s_m ,SNR);
    r 						= demodulator(received_signal, 'PSK');
    symbols 				= decision_device(r, 'PSK');
    output_binary_sequence 	= demapper(symbols', 'PSK', 0);
    BER_psk(count, 1)	 	= BER(input_binary_sequence, output_binary_sequence);
         
    count = count + 1;
end

semilogy(x', Pb, '.-');
hold on;
semilogy(x', BER_fsk, 'g.-');
semilogy(x', BER_psk_exp, 'r.-');
legend('theoritical BER 4-PSK','experimental BER 4-PSK','BER 4-FSK');
title('Bit Rate Error');
xlabel('SNR');
ylabel('BER');
hold;

figure;

% semilogy(x', SER_psk_gray, '.-');
% hold on;
% semilogy(x', SER_fsk, 'g.-');
% semilogy(x', SER_psk_, 'r.-');
% legend('4-PSK with Gray','4-FSK','4-PSK without Gray');
% title('Symbol Rate Error');
% xlabel('SNR');
% ylabel('SER');
% hold;