clear all;clc;
filesList=getAllFiles(strcat(pwd,'/resize'));
m=numel(filesList);
X=zeros(m,256);
y=zeros(m);
for index=1:m
  img=imread(filesList{index});
  X(index,:)=img(:);
endfor  
y=[3;2;1;3;3;2;3;1;1;2;3;1;2];
save('data.mat','X','y');
  