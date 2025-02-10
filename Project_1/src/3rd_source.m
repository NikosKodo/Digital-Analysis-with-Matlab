% clear the screen
clc

min_value = -1;
max_value = 1;

%------------------------------FIGURE PART---------------------------------------------------------------
% initialize the SQNR theoritical and experimental for each one of the quantizers
SQNR_exper_uni_sC = zeros(1,3);
SQNR_exper_non_sC = zeros(1,3);

% in this part we process the visualising and the initial of the image and the
% effects of the quantizations, along with the quantization layers

% WITH 2 BITS
figure()
[xq,centers, ~]=uniform_quantizer(x_C,2,min_value,max_value);
close

y=reshape((centers(xq)*f+f)+min(x_C),sqrt(length(xq)),sqrt(length(xq)));

figure()
subplot(2,2,1),imshow(uint8(xr)),title('Uniform Quantization with 4 quantized areas','fontweight','bold'),xlabel('Initial Image')
subplot(2,2,3),imshow(uint8(y)),xlabel('Quantized Image')
subplot(2,2,[2 4]),plot(x_C,centers(xq),'b.'),grid on,axis([min_value max_value min_value max_value]),title('Quantization Layers'),xlabel('X'),ylabel('XQ')

figure()
[xq,~,~]=non_uniform_quantizer(x_C,2,min_value,max_value);
close
%
y=reshape((xq*f+f)+min(x_C),sqrt(length(xq)),sqrt(length(xq)));
%
figure()
subplot(2,2,1),imshow(uint8(xr)),title('Non-Uniform Quantization with 4 quantized areas','fontweight','bold'),xlabel('Initial Image')
subplot(2,2,3),imshow(uint8(y)),xlabel('Quantized Image')
subplot(2,2,[2 4]),plot(x_C,xq,'b.'),grid on,axis([min_value max_value min_value max_value]),title('Quantization Layers'),xlabel('X'),ylabel('XQ')
% WITH 4 BITS
figure()
[xq,centers, ~]=uniform_quantizer(x_C,4,min_value,max_value);
close

y=reshape((centers(xq)*f+f)+min(x_C),sqrt(length(xq)),sqrt(length(xq)));

figure()
subplot(2,2,1),imshow(uint8(xr)),title('Uniform Quantization with 16 quantized areas','fontweight','bold'),xlabel('Initial Image')
subplot(2,2,3),imshow(uint8(y)),xlabel('Quantized Image')
subplot(2,2,[2 4]),plot(x_C,centers(xq),'b.'),grid on,axis([min_value max_value min_value max_value]),title('Quantization Layers'),xlabel('X'),ylabel('XQ')

figure()
[xq,~,~]=non_uniform_quantizer(x_C,4,min_value,max_value);
close
%
y=reshape((xq*f+f)+min(x_C),sqrt(length(xq)),sqrt(length(xq)));
%
figure()
subplot(2,2,1),imshow(uint8(xr)),title('Non-Uniform Quantization with 16 quantized areas','fontweight','bold'),xlabel('Initial Image')
subplot(2,2,3),imshow(uint8(y)),xlabel('Quantized Image')
subplot(2,2,[2 4]),plot(x_C,xq,'b.'),grid on,axis([min_value max_value min_value max_value]),title('Quantization Layers'),xlabel('X'),ylabel('XQ')
% WITH 6 BITS
figure()
[xq,centers, ~]=uniform_quantizer(x_C,6,min_value,max_value);
close

y=reshape((centers(xq)*f+f)+min(x_C),sqrt(length(xq)),sqrt(length(xq)));

figure()
subplot(2,2,1),imshow(uint8(xr)),title('Uniform Quantization with 64 quantized areas','fontweight','bold'),xlabel('Initial Image')
subplot(2,2,3),imshow(uint8(y)),xlabel('Quantized Image')
subplot(2,2,[2 4]),plot(x_C,centers(xq),'b.'),grid on,axis([min_value max_value min_value max_value]),title('Quantization Layers'),xlabel('X'),ylabel('XQ')

figure()
[xq,~,~]=non_uniform_quantizer(x_C,6,min_value,max_value);
close
%
y=reshape((xq*f+f)+min(x_C),sqrt(length(xq)),sqrt(length(xq)));
%
figure()
subplot(2,2,1),imshow(uint8(xr)),title('Non-Uniform Quantization with 64 quantized areas','fontweight','bold'),xlabel('Initial Image')
subplot(2,2,3),imshow(uint8(y)),xlabel('Quantized Image')
subplot(2,2,[2 4]),plot(x_C,xq,'b.'),grid on,axis([min_value max_value min_value max_value]),title('Quantization Layers'),xlabel('X'),ylabel('XQ')

%------------------------------SQNR PART-----------------------------------------------------------------

% having a for loop for each of N = 2, 4, 6
for i=1:3
    
    % FOR UNIFORM QUANTIZER
	% quantize signal A with uniform quantizer
	[ xq, centers, ~ ] = uniform_quantizer( x_C, 2*i, min_value, max_value );
	close
    % compute the experimental SQNR(dB)
	SQNR_exper_uni_sC(i) = 10*log10( mean(x_C.^2)/mean((x_C-centers(xq)).^2));
    
    % FOR NON-UNIFORM QUANTIZER
	% quantize signal A with non-uniform quantizer
	[ xq, centers, ~, bounds ] = non_uniform_quantizer( x_C, 2*i, min_value, max_value );
    close
    % compute the experimental SQNR(dB)
	SQNR_exper_non_sC(i) = 10*log10( mean(x_C.^2)/mean((x_C-xq).^2));
	
end
% 
% FOR UNIFORM QUANTIZER
prob_exper_uni_sC_1 = symbol_probability(x_C,2,min_value,max_value,'uni');
prob_exper_uni_sC_2 = symbol_probability(x_C,4,min_value,max_value,'uni');
prob_exper_uni_sC_3 = symbol_probability(x_C,6,min_value,max_value,'uni');
% FOR NON-UNIFORM QUANTIZER
prob_exper_non_sC_1 = symbol_probability(x_C,2,min_value,max_value,'non');
prob_exper_non_sC_2 = symbol_probability(x_C,4,min_value,max_value,'non');
prob_exper_non_sC_3 = symbol_probability(x_C,6,min_value,max_value,'non');
% 
%------------------------------PCM CODING EFFICIENCY PART-----------------------------------------------
% FOR UNIFORM QUANTIZER
PCM_uni_N2 = -sum(prob_exper_uni_sC_1.*log2(prob_exper_uni_sC_1))/(2*1);
PCM_uni_N4 = -sum(prob_exper_uni_sC_2.*log2(prob_exper_uni_sC_2))/(2*2);
PCM_uni_N6 = -sum(prob_exper_uni_sC_3.*log2(prob_exper_uni_sC_3))/(2*3);
% 
% % we call after Huffman function to find the bits huffman's coding user for
% % PCM uniform quantization
% [~,bits_1] = huffman(prob_exper_uni_sC_1);
% [~,bits_2] = huffman(prob_exper_uni_sC_2);
% [~,bits_3] = huffman(prob_exper_uni_sC_3);
% % 
% % then we compute Huffman Coding's efficiency using source C's entropy
% Huff_uni_N2 = -sum(prob_exper_uni_sC_1.*log2(prob_exper_uni_sC_1))/sum(prob_exper_uni_sC_1.*bits_1);
% Huff_uni_N4 = -sum(prob_exper_uni_sC_2.*log2(prob_exper_uni_sC_2))/sum(prob_exper_uni_sC_2.*bits_2);
% Huff_uni_N6 = -sum(prob_exper_uni_sC_3.*log2(prob_exper_uni_sC_3))/sum(prob_exper_uni_sC_3.*bits_3);
% % 
% FOR NON-UNIFORM QUANTIZER
PCM_non_uni_N2 = -sum(prob_exper_non_sC_1.*log2(prob_exper_non_sC_1))/(2*1);
PCM_non_uni_N4 = -sum(prob_exper_non_sC_2.*log2(prob_exper_non_sC_2))/(2*2);
PCM_non_uni_N6 = -sum(prob_exper_non_sC_3.*log2(prob_exper_non_sC_3))/(2*3);
% 
% % we call after Huffman function to find the bits huffman's coding user for
% % PCM non-unoform quantization
% [~,bits_1] = huffman(prob_exper_non_sC_1);
% [~,bits_2] = huffman(prob_exper_non_sC_2);
% [~,bits_3] = huffman(prob_exper_non_sC_3);
% % 
% % then we compute Huffman Coding's efficiency using source C's entropy
% Huff_non_uni_N2 = -sum(prob_exper_non_sC_1.*log2(prob_exper_non_sC_1))/sum(prob_exper_non_sC_1.*bits_1);
% Huff_non_uni_N4 = -sum(prob_exper_non_sC_2.*log2(prob_exper_non_sC_2))/sum(prob_exper_non_sC_2.*bits_2);
% Huff_non_uni_N6 = -sum(prob_exper_non_sC_3.*log2(prob_exper_non_sC_3))/sum(prob_exper_non_sC_3.*bits_3);
% % 
% %------------------------------PCM -VS- HUFFMAN EFFICIENCY PART-----------------------------------------
% % 
% % presentate the results into two columns
% PCM_vs_Huff_uni     = [PCM_uni_N2 PCM_uni_N4 PCM_uni_N6; Huff_uni_N2 Huff_uni_N4 Huff_uni_N6]' ;
% % 
% PCM_vs_Huff_non_uni = [PCM_non_uni_N2 PCM_non_uni_N4 PCM_non_uni_N6;Huff_non_uni_N2 Huff_non_uni_N4 Huff_non_uni_N6]' ;