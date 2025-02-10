% clear the screen
clc

min_value = 0;
max_value = 4;

%------------------------------SQNR PART-----------------------------------------------------------------

% initialize the SQNR theoritical and experimental for each one of the quantizers
SQNR_theor_uni_sA = zeros(1,3);
SQNR_exper_uni_sA = zeros(1,3);

SQNR_theor_non_sA = zeros(1,3);
SQNR_exper_non_sA = zeros(1,3);

% to compute the theoritical SQNR we need to use a symbolic variable
syms z
% we compute the Power of the signal first. Cause the signal follws exp distribution in
% [0, +oo] the power in [-oo, 0] is zero.
Power_signal_sA = double( int(z^2*exp(-z), 0, Inf) );

% we also have alreade compute x[] signal in createSourcescript.m

% having a for loop for each of N = 2, 4, 6
for i=1:3
    % FOR UNIFORM QUANTIZER
	% quantize signal A with uniform quantizer
	[ xq, centers, bounds ] = uniform_quantizer( x_A, 2*i, min_value, max_value );
	close
	
	% compute the experimental SQNR(dB)
	SQNR_exper_uni_sA(i) = 10*log10( mean(x_A.^2)/mean((x_A-centers(xq)).^2));
	
	% to compute the theoritical SQNR we have to compute the integrals of
	% each of bounds (x - xq)^2*fx()
	y = (z - centers).^2;
	% initialize first a vector for the noise power
	Power_noise_sA = zeros(length(y)+2, 1);
	% noise power equals to 0 in [-oo, 0] couse pdf function is 0 in this range
	% so signal power is also 0. noise power for every other range is equal to the square difference
	% multiplied by the pdf and integrated in the same range
	Power_noise_sA(1) = 0;
	Power_noise_sA(end) = int(y(end)*exp(-z), bounds(end,2), Inf);
	for k = 1:length(y)
		Power_noise_sA(k+1) = int(y(k)*exp(-z), bounds(k, 1), bounds(k, 2));
	end
	% finaly noise power equals to sum of all elements of Power_noise_sA[]
	Power_noise_sA = sum(Power_noise_sA);
	SQNR_theor_uni_sA(i) = 10*log10(Power_signal_sA/Power_noise_sA);
	
    % FOR NON-UNIFORM QUANTIZER
	% quantize signal A with non-uniform quantizer
	[ xq, centers, ~, bounds ] = non_uniform_quantizer( x_A, 2*i, min_value, max_value );
    close
	% compute the experimental SQNR(dB)
	SQNR_exper_non_sA(i) = 10*log10( mean(x_A.^2)/mean((x_A-xq).^2));
	
	% to compute the theoritical SQNR we have to compute the integrals of
	% each of bounds (x - xq)^2*fx()
	y = (z - centers).^2;
	% initialize first a vector for the noise power
	Power_noise_sA = zeros(length(y)+2, 1);
	% noise power equals to 0 in [-oo, 0] couse pdf function is 0 in this range
	% so signal power is also 0. noise power for every other range is equal to the square difference
	% multiplied by the pdf and integrated in the same range
	Power_noise_sA(1) = 0;
	Power_noise_sA(end) = int(y(end)*exp(-z), bounds(end, 2), Inf);
	for k = 1:length(y)
		Power_noise_sA(k+1) = int(y(k)*exp(-z), bounds(k, 1), bounds(k, 2));
	end
	% finaly noise power equals to sum of all elements of Power_noise_sA[]
	Power_noise_sA = sum(Power_noise_sA);
	SQNR_theor_non_sA(i) = 10*log10(Power_signal_sA/Power_noise_sA);
end
%------------------------------OVERLOAD PART-------------------------------------------------------------

% we compute quantizer's overload probability in theory and experiment
% accordingly quantizer's overload probability is the probability of a sample not lying
% in quantization range because source A's samples are generated from the the given exponential
% distribution, no sample belongs in [-Inf,0], so the probability of a sample lying in that range is 0
% and so we compute only the probability of a sample lying in [4,Inf]
p_overload_theoretical=double(int(exp(-z),4,Inf));
p_overload_experimental=numel(x_A(x_A>max_value | x_A<min_value))/numel(x_A);

%------------------------------LAYER PROBABILITY PART----------------------------------------------------

% initialize some useful vectors  for the layer probabi;ities

prob_exper_uni_sA = zeros(2^6+2,3);
prob_theor_uni_sA = zeros(2^6+2,3);

prob_exper_non_sA = zeros(2^6+2,3);
prob_theor_non_sA = zeros(2^6+2,3);

% having a for loop for each of N = 2, 4, 6
for i=1:3
   % FOR UNIFORM QUANTIZER 
   % call the layer probability function for theoritical computation
   prob_theor_uni_sA(1: 2^(2*i)+2, i) = layer_probability(x_A,2*i,min_value,max_value,'uni');
   
   % to have some experimental probabilities we want the quantization
   % bounds so we call the uniform quantization function
   [~,~,bounds] = uniform_quantizer(x_A,2*i,min_value,max_value);
   
   prob_exper_uni_sA(1, i) = numel(x_A(x_A>-Inf & x_A<bounds(1,1)))/numel(x_A);
   prob_exper_uni_sA(2^(2*i)+2,i) = numel(x_A(x_A>bounds(end,2) & x_A<Inf))/numel(x_A);
   
   % we compute the rest of the probabilities  
   for j=1:size(bounds,1)
         prob_exper_uni_sA(j+1,i)=numel(x_A(x_A>=bounds(j,1) & x_A<bounds(j,2)))/numel(x_A);
   end
   
   % FOR NON-UNIFORM QUANTIZER
   % call the layer probability function for theoritical computation
   prob_theor_non_sA(1: 2^(2*i)+2, i) = layer_probability(x_A,2*i,min_value,max_value,'non');
   
   % to have some experimental probabilities we want the quantization
   % bounds so we call the uniform quantization function
   [~,~,bounds] = non_uniform_quantizer(x_A,2*i,min_value,max_value);
   
   prob_exper_non_sA(1, i) = numel(x_A(x_A>-Inf & x_A<bounds(1,1)))/numel(x_A);
   prob_exper_non_sA(2^(2*i)+2,i) = numel(x_A(x_A>bounds(end,2) & x_A<Inf))/numel(x_A);
   
   % we compute the rest of the probabilities  
   for j=1:size(bounds,1)
         prob_exper_non_sA(j+1,i)=numel(x_A(x_A>=bounds(j,1) & x_A<bounds(j,2)))/numel(x_A);
   end
   
end

% %keep only the non zero values and presentate much better the results
% FOR UNIFORM QUANTIZER
prob_exper_uni_sA_1 = prob_exper_uni_sA(:,1)';
prob_exper_uni_sA_2 = prob_exper_uni_sA(:,2)';
prob_exper_uni_sA_3 = prob_exper_uni_sA(:,3)';
prob_exper_uni_sA_1 = prob_exper_uni_sA_1(2:2^(2*1)+2);
prob_exper_uni_sA_2 = prob_exper_uni_sA_2(2:2^(2*2)+2);
prob_exper_uni_sA_3 = prob_exper_uni_sA_3(2:2^(2*3)+2);
% FOR NON-UNIFORM QUANTIZER
prob_exper_non_sA_1 = prob_exper_non_sA(:,1)';
prob_exper_non_sA_2 = prob_exper_non_sA(:,2)';
prob_exper_non_sA_3 = prob_exper_non_sA(:,3)';
prob_exper_non_sA_1 = prob_exper_non_sA_1(2:2^(2*1)+2);
prob_exper_non_sA_2 = prob_exper_non_sA_2(2:2^(2*2)+2);
prob_exper_non_sA_3 = prob_exper_non_sA_3(2:2^(2*3)+2);
% 
%------------------------------PCM CODING EFFICIENCY PART-----------------------------------------------
% % FOR UNIFORM QUANTIZER
% PCM_uni_N2 = -sum(prob_exper_uni_sA_1.*log2(prob_exper_uni_sA_1))/(2*1);
% PCM_uni_N4 = -sum(prob_exper_uni_sA_2.*log2(prob_exper_uni_sA_2))/(2*2);
% PCM_uni_N6 = -sum(prob_exper_uni_sA_3.*log2(prob_exper_uni_sA_3))/(2*3);

% we call after Huffman function to find the bits huffman's coding user for
% % PCM uniform quantization
% [~,bits_1] = huffman(prob_exper_uni_sA_1);
% [~,bits_2] = huffman(prob_exper_uni_sA_2);
% [~,bits_3] = huffman(prob_exper_uni_sA_3);
% 
% % then we compute Huffman Coding's efficiency using source A's entropy
% Huff_uni_N2 = -sum(prob_exper_uni_sA_1.*log2(prob_exper_uni_sA_1))/sum(prob_exper_uni_sA_1.*bits_1);
% Huff_uni_N4 = -sum(prob_exper_uni_sA_2.*log2(prob_exper_uni_sA_2))/sum(prob_exper_uni_sA_2.*bits_2);
% Huff_uni_N6 = -sum(prob_exper_uni_sA_3.*log2(prob_exper_uni_sA_3))/sum(prob_exper_uni_sA_3.*bits_3);
% % 
% FOR NON-UNIFORM QUANTIZER
% PCM_non_uni_N2 = -sum(prob_exper_non_sA_1.*log2(prob_exper_non_sA_1))/(2*1);
% PCM_non_uni_N4 = -sum(prob_exper_non_sA_2.*log2(prob_exper_non_sA_2))/(2*2);
% PCM_non_uni_N6 = -sum(prob_exper_non_sA_3.*log2(prob_exper_non_sA_3))/(2*3);
% % 
% % we call after Huffman function to find the bits huffman's coding user for
% % PCM non-unoform quantization
% [~,bits_1] = huffman(prob_exper_non_sA_1);
% [~,bits_2] = huffman(prob_exper_non_sA_2);
% [~,bits_3] = huffman(prob_exper_non_sA_3);
% 
% % then we compute Huffman Coding's efficiency using source A's entropy
% Huff_non_uni_N2 = -sum(prob_exper_non_sA_1.*log2(prob_exper_non_sA_1))/sum(prob_exper_non_sA_1.*bits_1);
% Huff_non_uni_N4 = -sum(prob_exper_non_sA_2.*log2(prob_exper_non_sA_2))/sum(prob_exper_non_sA_2.*bits_2);
% Huff_non_uni_N6 = -sum(prob_exper_non_sA_3.*log2(prob_exper_non_sA_3))/sum(prob_exper_non_sA_3.*bits_3);
% 
% %------------------------------PCM -VS- HUFFMAN EFFICIENCY PART-----------------------------------------
% 
% % presentate the results into two columns
% PCM_vs_Huff_uni     = [PCM_uni_N2 PCM_uni_N4 PCM_uni_N6; Huff_uni_N2 Huff_uni_N4 Huff_uni_N6]' ;
% 
% PCM_vs_Huff_non_uni = [PCM_non_uni_N2 PCM_non_uni_N4 PCM_non_uni_N6; Huff_non_uni_N2 Huff_non_uni_N4 Huff_non_uni_N6]' ;