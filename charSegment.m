pkg load image;
im=rgb2gray(imread('./test/2.JPG'));
%imBW=edge(im,'Canny');
verticalProjection=sum(im,1);
d=diff(verticalProjection);
n=numel(d);
i=1;
while i<=n
  if d(i)>0
    startCol=i+1;
  else
    i=i+1;
    continue
  endif
  for j=i+1 : n
    dVal= abs(d(i)+d(j));
%    fprintf("\nd(i)\t%d\n", d(i));
%    fprintf("\nd(j)\t%d\n", d(j));
%    fprintf("\ndVal\t%d\n", dVal);
    if d(j)<0 && dVal<d(i) && dVal<abs(d(j))
      endCol=j+1;
      i=j+2;
      break
    endif
  endfor
  if i==startCol
    i=i+1;
  endif
  figure;
  imshow(im(:,startCol:endCol));
  pause
endwhile
%% 0 where there is background, 1 where there are letters
%letterLocations = verticalProjection;
%% Find Rising and falling edges
%d = diff(letterLocations);
%startingColumns = find(d>0);
%endingColumns = find(d<0);
%% Extract each region
%for k = 1 : length(startingColumns)
%  % Get sub image of just one character...
%  subImage = im(:, startingColumns(k):endingColumns(k));
%  figure;
%  imshow(subImage);
%  % Now process this subimage of a single character....
%end