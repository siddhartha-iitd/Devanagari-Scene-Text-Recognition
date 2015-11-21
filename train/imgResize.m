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
## @deftypefn {Function File} imgResize
##
## @seealso{}
## @end deftypefn

## Author: SIDDHARTHA <SIDDHARTHA@SIDDHARTHA-PC>
## Created: 2015-09-09

function imgResize

filesList= getAllFiles(pwd);
if (exist('resize','dir') != 7)
  mkdir('resize');
endif
for index = 1: numel(filesList)
  [pst, name, ext]=fileparts(filesList{index});
  name=strcat(name,ext);
  img=imresize(rgb2gray(imread(filesList{index})),[16 16]);
  imwrite(img,strcat('./resize/',name));
endfor
endfunction
