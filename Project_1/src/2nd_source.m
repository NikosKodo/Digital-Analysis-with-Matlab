% clear the screen
clc

min_value = 0;
max_value = 4;


% initialize the SQNR theoritical and experimental for each one of the quantizers
SQNR_theor_uni_sB = zeros(1,3);
SQNR_exper_uni_sB = zeros(1,3);

SQNR_theor_non_sB = zeros(1,3);
SQNR_exper_non_sB = zeros(1,3);

% to compute the theoritical SQNR we need to use a symbolic variable
syms z
% since the signal follows the uniform distribution in [0,4], the signal
% has power only in that range, and so it's power in [-Inf,0] and [4,Inf]
% is 0
% since the samples of source B are generated from the uniform distribution
% in [0,4], uniform distribution pdf's values are all 1/(4-1) = 1/4
Power_signal_sB = double( int(z^2*(1/4), 0, 4) );

% we also have already compute x[] signal in createSourcescript.m

% having a for loop for each of N = 2, 4, 6
for i=1:3
	% quantize signal A with uniform quantizer
	[xq, centers, bounds]=uniform_quantizer(x_B,2*i,min_value,max_value);
    close
	
	% compute the experimental SQNR(dB)
	SQNR_exper_uni_sB(i) = 10*log10( mean(x_B.^2)/mean((x_B-centers(xq)).^2));
	
	% to compute the theoritical SQNR we have to compute the integrals of
	% each of ranges (x - xq)^2*fx()
	y = (z - centers).^2;
	% initialize first a vector for the noise power
	Power_noise_sB = zeros(length(y)+2, 1);
	% noise power equals to 0 in [-oo, 0] couse pdf function is 0 in this range
	% so signal power is also 0. noise power for every other range is equal to the square difference
	% multiplied by the pdf and integrated in the sBme range
	Power_noise_sB(1) = int(y(end)*(1/4),0,bounds(1,1));
	Power_noise_sB(end) = int(y(end)*(1/4),bounds(end,2), 4);
	for k = 1:length(y)
		Power_noise_sB(k+1) = int(y(k)*(1/4), bounds(k,1),bounds(k,2));
	end
	% finaly noise power equals to sum of all elements of Power_noise_sB[]
	Power_noise_sB = sum(double(Power_noise_sB));
    SQNR_theor_uni_sB(i) = 10*log10(Power_signal_sB/Power_noise_sB);
	
	% quantize signal A with non-uniform quantizer
	[ xq, centers, ~, bounds ] = non_uniform_quantizer( x_B, 2*i, min_value, max_value );
    close
	% compute the experimental SQNR(dB)
	SQNR_exper_non_sB(i) = 10*log10( mean(x_B.^2)/mean((x_B-xq).^2));
	
	% to compute the theoritical SQNR we have to compute the integrals of
	% each of ranges (x - xq)^2*fx()
	y = (z - centers).^2;
	% initialize first a vector for the noise power
	Power_noise_sB = zeros(length(y)+2, 1);
	% noise power equals to 0 in [-oo, 0] couse pdf function is 0 in this range
	% so signal power is also 0. noise power for every other range is equal to the square difference
	% multiplied by the pdf and integrated in the sBme range
	Power_noise_sB(1) = int(y(end)*(1/4),0,bounds(1,1));
	Power_noise_sB(end) = int(y(end)*(1/4),bounds(end,2), 4);
	for k = 1:length(y)
		Power_noise_sB(k+1) = int(y(k)*(1/4), bounds(k,1),bounds(k,2));
	end
	% finaly noise power equals to sum of all elements of Power_noise_sB[]
	Power_noise_sB = sum(double(Power_noise_sB));
	SQNR_theor_non_sB(i) = 10*log10(Power_signal_sB/Power_noise_sB);
	
end
%------------------------------LAYER PROBABILITY PART----------------------------------------------------

% initialize some useful vectors  for the layer probabi;ities

prob_exper_uni_sB = zeros(2^6+2,3);
prob_theor_uni_sB = zeros(2^6+2,3);

prob_exper_non_sB = zeros(2^6+2,3);
prob_theor_non_sB = zeros(2^6+2,3);

% having a for loop for each of N = 2, 4, 6
for i=1:3
   % FOR UNIFORM QUANTIZER 
   % call the layer probability function for theoritical computation
   prob_theor_uni_sB(1: 2^(2*i)+2, i) = layer_probability(x_B,2*i,min_value,max_value,'uni');
   
   % to have some experimental probabilities we want the quantization
   % bounds so we call the uniform quantization function
   [~,~,bounds] = uniform_quantizer(x_B,2*i,min_value,max_value);
   
   prob_exper_uni_sB(1, i) = numel(x_B(x_B>-Inf & x_B<bounds(1,1)))/numel(x_B);
   prob_exper_uni_sB(2^(2*i)+2,i) = numel(x_B(x_B>bounds(end,2) & x_B<Inf))/numel(x_B);
   
   % we compute the rest of the probabilities  
   for j=1:size(bounds,1)
         prob_exper_uni_sB(j+1,i)=numel(x_B(x_B>=bounds(j,1) & x_B<bounds(j,2)))/numel(x_B);
   end
   
   % FOR NON-UNIFORM QUANTIZER
   % call the layer probability function for theoritical computation
   prob_theor_non_sB(1: 2^(2*i)+2, i) = layer_probability(x_B,2*i,min_value,max_value,'non');
   
   % to have some experimental probabilities we want the quantization
   % bounds so we call the uniform quantization function
   [~,~,bounds] = non_uniform_quantizer(x_B,2*i,min_value,max_value);
   
   prob_exper_non_sB(1, i) = numel(x_B(x_B>-Inf & x_B<bounds(1,1)))/numel(x_B);
   prob_exper_non_sB(2^(2*i)+2,i) = numel(x_B(x_B>bounds(end,2) & x_B<Inf))/numel(x_B);
   
   % we compute the rest of the probabilities  
   for j=1:size(bounds,1)
         prob_exper_non_sB(j+1,i)=numel(x_B(x_B>=bounds(j,1) & x_B<bounds(j,2)))/numel(x_B);
   end
   
end

% %keep only the non zero values and presentate much better the results
% FOR UNIFORM QUANTIZER
prob_exper_uni_sB_1 = prob_exper_uni_sB(:,1)';
prob_exper_uni_sB_2 = prob_exper_uni_sB(:,2)';
prob_exper_uni_sB_3 = prob_exper_uni_sB(:,3)';
prob_exper_uni_sB_1 = prob_exper_uni_sB_1(2:2^(2*1)+2);
prob_exper_uni_sB_2 = prob_exper_uni_sB_2(2:2^(2*2)+2);
prob_exper_uni_sB_3 = prob_exper_uni_sB_3(2:2^(2*3)+2);
% FOR NON-UNIFORM QUANTIZER
prob_exper_non_sB_1 = prob_exper_non_sB(:,1)';
prob_exper_non_sB_2 = prob_exper_non_sB(:,2)';
prob_exper_non_sB_3 = prob_exper_non_sB(:,3)';
prob_exper_non_sB_1 = prob_exper_non_sB_1(2:2^(2*1)+2);
prob_exper_non_sB_2 = prob_exper_non_sB_2(2:2^(2*2)+2);
prob_exper_non_sB_3 = prob_exper_non_sB_3(2:2^(2*3)+2);

%------------------------------PCM CODING EFFICIENCY PART-----------------------------------------------
% % FOR UNIFORM QUANTIZER
% PCM_uni_N2 = -sum(prob_exper_uni_sB_1.*log2(prob_exper_uni_sB_1))/(2*1);
% PCM_uni_N4 = -sum(prob_exper_uni_sB_2.*log2(prob_exper_uni_sB_2))/(2*2);
% PCM_uni_N6 = -sum(prob_exper_uni_sB_3.*log2(prob_exper_uni_sB_3))/(2*3);

% FOR NON-UNIFORM QUANTIZER
% PCM_non_uni_N2 = -sum(prob_exper_non_sB_1.*log2(prob_exper_non_sB_1))/(2*1);
% PCM_non_uni_N4 = -sum(prob_exper_non_sB_2.*log2(prob_exper_non_sB_2))/(2*2);
% PCM_non_uni_N6 = -sum(prob_exper_non_sB_3.*log2(prob_exper_non_sB_3))/(2*3);