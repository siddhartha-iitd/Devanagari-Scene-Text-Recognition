pkg load image;
im=rgb2gray(imread('./test/2.JPG'));
[m n] = size(im);
imedge=edge(im,'Canny');
imBW=imdilate(imedge,strel('square',3));
cc=bwconncomp(imBW);
numWords=cc.NumObjects;
wordCols=zeros(numWords, 2);
wordRows=zeros(numWords, 2);
for i=1:numWords
% Extract Word
  [I,J]=ind2sub(size(imedge),cc.PixelIdxList{i});
  %wordCols(i,:)= [min(J) max(J)];
  %wordRows(i,:)=[min(I) max(I)];
  word=im(min(I):max(I), min(J):max(J));
  figure, imshow(word);
%Extract Characters from a Word
  [charList{i}, upperModifierList{i}, lowerModifierList{i}]=getChars(word);
 
endfor;
