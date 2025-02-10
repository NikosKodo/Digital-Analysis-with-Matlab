%Sample to ensure that uniform and non_uniform quantizer
%works well

x = 0:.1: 3*pi;
fx = cos(x);

%uniform + non_unoform quantization of 1 bit
[xq1_1, centers1_1, ~, ~] = uniform_quantizer(fx, 1, -1, 1);
[xq1_2, centers1_2, ~, ~] = non_uniform_quantizer(fx, 1, -1, 1);
%uniform + non_unoform quantization of 2 bits
[xq2_1, centers2_1, ~, ~] = uniform_quantizer(fx, 2, -1, 1);
[xq2_2, centers2_2, ~, ~] = non_uniform_quantizer(fx, 2, -1, 1);
%uniform + non_unoform quantization of 3 bits
[xq3_1, centers3_1, ~, ~] = uniform_quantizer(fx, 3, -1, 1);
[xq3_2, centers3_2, ~, ~] = non_uniform_quantizer(fx, 3, -1, 1);

%Ploting the results
subplot(3, 2, 1), plot(x, fx, x, centers1_1(xq1_1)), title('Uniform Quantization with 1 bit(2 quantization areas)')
subplot(3, 2, 3), plot(x, fx, x, centers2_1(xq2_1)), title('Uniform Quantization with 2 bits(4 quantization areas)')
subplot(3, 2, 5), plot(x, fx, x, centers3_1(xq3_1)), title('Uniform Quantization with 3 bits(8 quantization areas)')

subplot(3, 2, 2), plot(x, fx, x, xq1_2), title('Non uniform Quantization with 1 bit(2 quantization areas)')
subplot(3, 2, 4), plot(x, fx, x, xq2_2), title('Non uniform Quantization with 2 bits(4 quantization areas)')
subplot(3, 2, 6), plot(x, fx, x, xq3_2), title('Non uniform Quantization with 3 bits(8 quantization areas)')