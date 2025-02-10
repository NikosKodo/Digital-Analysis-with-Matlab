function [xq, centers, D]=Lloyd_Max(x, N, min_value, max_value)
%xq : xq: το διάνυσμα του σήματος εξόδου 
%centers: τα κέντρα των περιοχών κβάντισης
%D : Διάνυσμα που περιέχει τις τιμές [D1:Dkmax] όπου 𝐷𝑖 αντιστοιχεί στην μέση παραμόρφωση στην επανάληψη i του αλγορίθμου. 
%periorismos eisodou
% x: το σήμα εισόδου υπό μορφή διανύσματος
% Ν: ο αριθμός των bits που θα χρησιμοποιηθούν
% max_value: η μέγιστη αποδεκτή τιμή του σήματος εισόδου
% min_value: η ελάχιστη αποδεκτή τιμή του σήματος εισόδου

if min_value< min(x)
 min_value = min(x);
end
if max_value > max(x)
 max_value = max(x);
end
xq = zeros(length(x), 1);
%arxikopoihsh kentrwn kai 8orubou
[xq, centers,d] = my_quantizer(x, N, min_value, max_value);
D(1) = d;
%Lloyd-Max 100 epanalipseis
for k = 2:100
 for j = 1:2^N-1
 T(j)=(centers(j)+centers(j+1))/2;
 end
 simeia=[min_value T max_value];
 for i = 1:length(x)
 for j = 1:2^N
 if (x(i)>=simeia(j) && x(i)<=simeia(j+1))
 xq(i) = j;
 break;
 end
 end
 end
 %mesi isxus 8orubou
 D(k)=mean((x-centers(xq)).^2);
 %nea epipeda kbantismou
 for i = 1:2^N
 temp = find(xq == i);
 if ~isempty(temp)
 centers(i)=mean(x(temp));
 end
 %elegxos an i isxus 8oribou ginei polu mikri
 if (abs(D(k)-D(k-1))<1e-30)
 break
 end
 end
end