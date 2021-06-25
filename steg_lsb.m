clear all;
clc;
input = imread('examples/untitled.png');
input=rgb2gray(input);
message='NIAM';
msg=length(message);
% Ubah jadi ASCII
ascii_value = uint8(message);
% Ubah value decimal ke binary
bin_message = transpose(dec2bin(ascii_value, 8));
% Memisahkan value di baris yang berbeda
bin_message = bin_message(:);
% Panjang dari message dalam binary
len = length(bin_message);
% Merubah character array menjadi numeric array
bin_num_message=str2num(bin_message);
output = input;
height = size(input, 1);
width = size(input, 2);
counter = 1;
% Mengunjungi pixel
for i = 1 : height
	for j = 1 : width
		% Jika masih ada bits yang belum disisipkan
		if(counter <= len)
			%Mencari LSB di pixel
			LSB = mod(double(input(i, j)), 2);
			%Menentukan apakah LSB sama dengan bit pesan atau tidak
			temp = double(xor(LSB, bin_num_message(counter)));
			%Memperbarui bit
			output(i, j) = input(i, j)+temp;
			counter = counter+1;
        else
            i=height;
            j=width;
        end
	end
end
%decoding
% Counter for number of embedded bits
counter = 1;
% Mengunjungi tiap pixel
for i = 1 : height
	for j = 1 : width
		% If more bits are remaining to embed
		if(counter <= len)
			%Mencari LSB di pixel
			LSB = mod(double(output(i, j)), 2);
			ret(counter)=LSB;
			counter = counter+1;
        else
            i=height;
            j=width;
        end
	end
end
String = ret(:);
String = num2str(String);
String = bin2dec(reshape(String,8,[]).');
String = char(String);
%kembalikan ke string
String = reshape(String,[1,msg]);
imwrite(input, 'examples\originalImage.png');
imwrite(output, 'examples\stegoImage.png'); %stegoimage
figure,imshow(output);
figure,imshow(input);