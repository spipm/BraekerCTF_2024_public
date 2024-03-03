# Solve by GingerArmy174 in the writeups chat

image = rgb2gray(imread("./approach.png"));
PSF = fspecial('motion',30,15);
[J P] = deconvblind(image,PSF,20);

imshow(J)
