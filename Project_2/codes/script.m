bits = 10^5;

i = 1;
x = [0: 2: 8];

for SNR = 0: 2: 8
    A = binary_input(bits);
    B = mapper(A, 'psk', 1);
    C = modulator(B, 'psk');
    D = noise(C,SNR);
    r = demodulator(D, 'psk');
    E = foratis(r, 'psk');
    F = demapper(E', 'psk', 1);
    BER_psk_gray(i, 1) = ber(A,F);
    SER_psk_gray(i, 1) = ser(A,F);
    
    A = binary_input(bits);
    B = mapper(A, 'fsk', 0);
    C = modulator(B, 'fsk');
    D = noise(C,SNR);
    r = demodulator(D, 'fsk');
    E = foratis(r, 'fsk');
    F = demapper(E', 'fsk', 0);
    BER_fsk(i, 1) = ber(A,F);
    SER_fsk(i, 1) = ser(A,F);
 
    A = binary_input(bits);
    B = mapper(A, 'psk', 0);
    C = modulator(B, 'psk');
    D = noise(C,SNR);
    r = demodulator(D, 'psk');
    E = foratis(r, 'psk');
    F = demapper(E', 'psk', 0);
    BER_psk_without_gray(i, 1) = ber(A,F);
    SER_psk_without_gray(i, 1) = ser(A,F);

     
    i = i + 1;
end

semilogy(x', BER_psk_gray, '.-');
hold on;
semilogy(x', BER_fsk, 'g.-');
semilogy(x', BER_psk_without_gray, 'r.-');
legend('8-psk with Gray','8-fsk','8-psk without Gray');
title('Bit Rate Error');
xlabel('SNR');
ylabel('BER');
hold;

figure;

semilogy(x', SER_psk_gray, '.-');
hold on;
semilogy(x', SER_fsk, 'g.-');
semilogy(x', SER_psk_without_gray, 'r.-');
legend('8-psk with Gray','8-fsk','8-psk without Gray');
title('Symbol Rate Error');
xlabel('SNR');
ylabel('SER');
hold;