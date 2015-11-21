## Copyright (C) 2015 SIDDHARTHA
## 
## This program is free software; you can redistribute it and/or modify it
## under the terms of the GNU General Public License as published by
## the Free Software Foundation; either version 3 of the License, or
## (at your option) any later version.
## 
## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
## 
## You should have received a copy of the GNU General Public License
## along with this program.  If not, see <http://www.gnu.org/licenses/>.

## -*- texinfo -*- 
## @deftypefn {Function File} {@var{retval} =} getChars (@var{input1}, @var{input2})
##
## @seealso{}
## @end deftypefn

## Author: SIDDHARTHA <SIDDHARTHA@SIDDHARTHA-PC>
## Created: 2015-09-26

function [charList, upperModifierList, lowerModifierList] = getChars (word)
  %Calculate Horizontal Profile to locate header bar.
  hp=sum(word,2);
  %Max of horizontal profile is the row for header bar.
  [val,barLoc]=max(hp);
  %Part of Word below and above header line
  wordBelowHeader=word(barLoc+1:end,:);
  modifierAboveHeader=word(1:barLoc-1,:);
  %Dilated EdgeMap of Word below header
  wordBelowHeaderEdgeMap=imdilate(edge(wordBelowHeader,'canny'),strel('square',3));
  %Connected Components to extract alphabets from word
  wordBelowHeaderCC=bwconncomp(wordBelowHeaderEdgeMap);
  %L=labelmatrix(wordBelowHeaderCC);
  %labeledRGB=label2rgb(L);
  %figure,imshow(labeledRGB);
  numChars=wordBelowHeaderCC.NumObjects;
  charList=cell(numChars,4);
  charWidth=zeros(numChars,1);
  charHeight=zeros(numChars,1);
  for i=1:numChars
    [I,J]=ind2sub(size(word),wordBelowHeaderCC.PixelIdxList{i});
    charList{i}=(min(I),max(I),min(J),max(J));
    charHeight(i,1)=max(I)-min(I);
    charWidth(i,1)=max(J)-min(J);
    %figure,imshow(wordBelowHeader(charList{i,1}:charList{i,2},charList{i,3}:charList{i,4}));
  endfor
  [maxCharHeight,highCharIndex]=max(charHeight);
  [maxCharWidth,wideCharIndex]=max(charWidth);
  %In postprocessing phase, after matra(above header line) has been recognized, find where exactly to look for its attachment
  %for lower modifiers, prepare an array which will store the location of these modifiers. In postprocessing phase, check which char from charList falls at middle or appropriate location of that modifier and attach.
  %for conjuncts, separate here only. Pass it to recognition phase as part of charList
  
  %Extract Lower Modifiers
  
  %No. of chars having height more than 80% of maxCharHeight
  [row,col]=find(charHeight >= 0.08 * maxCharHeight);
  num=numel(row);
  if (num > numChars - num)
    % No Lower Modifiers
    numLowerModifiers=0;
  else
    % split the characters, in indices returned by find, at the avg. height of characters whose indices are not returned
   idxCharsNoLowerMod=setdiff(1:numChars, row);
   avgHeightCharsNoLowerMod=mean(charHeight(idxNoLowerMod,:));
   %Dilated EdgeMap of lower modifiers
   lowerModifiersEdgeMap=imdilate(edge(wordBelowHeader(avgHeightCharsNoLowerMod+1:end,:);,'canny'),strel('square',3));
   %Connected Components to extract modifiers
   lowerModifiersCC=bwconncomp(lowerModifiersEdgeMap);
   numLowerModifiers=lowerModifiersCC.NumObjects;
   lowerModifierList=cell(numLowerModifiers,4);
   for i=1:numLowerModifiers
    [I,J]=ind2sub(size(word),lowerModifiersCC.PixelIdxList{i});
    lowerModifierList{i}=(min(I),max(I),min(J),max(J));
    %figure,imshow(word(lowerModifierList{i,1}:lowerModifierList{i,2},lowerModifierList{i,3}:lowerModifierList{i,4}));
   endfor
   wordWithoutLowerModifier=wordBelowHeader(1:avgHeightCharsNoLowerMod,:);
  endif
 
  %Extract Upper Modifiers
  %Dilated EdgeMap of modifiers above header line
  modifierAboveHeaderEdgeMap=imdilate(edge(modifierAboveHeader,'canny'),strel('square',3));
  %Connected Components to extract modifiers
  modifierAboveHeaderCC=bwconncomp(modifierAboveHeaderEdgeMap); 
  numUpperModifiers=wordBelowHeaderCC.NumObjects;
  upperModifierList=cell(numUpperModifiers,4);
  for i=1:numUpperModifiers
    [I,J]=ind2sub(size(word),modifierAboveHeaderCC.PixelIdxList{i});
    upperModifierList{i}=(min(I),max(I),min(J),max(J));
    %figure,imshow(word(upperModifierList{i,1}:upperModifierList{i,2},upperModifierList{i,3}:upperModifierList{i,4}));;
  endfor
  
  %Extract Conjuncts
  
  %No. of chars having width more than 80% of maxCharWidth
  [row,col]=find(charWidth >= 0.08 * maxCharWidth);
  num=numel(row);
  if (num > numChars - num)
    % No conjuncts
    numConjuncts=0;
  else
    %split wider characters in between, modify charList
    numConjuncts=num;
    for i=row
      conjWidth=charList{i,4}-charList{i,3};
      conjunctChars={charList{i,1},charList{i,2},charList{i,3} ,charList{i,3}+uint8(conjWidth/2);charList{i,1},charList{i,2},1+charList{i,3}+uint8(conjWidth/2),charList{i,4}};
      charList{i,1}=conjunctChars;
      charList{i,2:end}=-1;
    endfor
  endif  
  
endfunction
