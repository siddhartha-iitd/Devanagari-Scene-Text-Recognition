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
## @deftypefn {Function File} {@var{retval} =} trainOCR (@var{input1}, @var{input2})
##
## @seealso{}
## @end deftypefn

## Author: SIDDHARTHA <SIDDHARTHA@SIDDHARTHA-PC>
## Created: 2015-09-09

input_layer_size  = 256;  % 16x16 Input Images of Digits
hidden_layer_size = 25;   % 25 hidden units
num_labels = 3;           % 3 labels, from 1 to 3

load('data.mat');                          

options = optimset('MaxIter', 100);

lambda = 0.5;

initial_Theta1 = randInitializeWeights(input_layer_size+1, hidden_layer_size);%26X256
initial_Theta2 = randInitializeWeights(hidden_layer_size+1, num_labels);%1X25

% Unroll parameters
initial_nn_params = [initial_Theta1(:) ; initial_Theta2(:)];


% Create "short hand" for the cost function to be minimized
costFunction = @(p) nnCostFunction(p, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, X, y, lambda);

% Now, costFunction is a function that takes in only one argument (the neural network parameters)
[nn_params, cost] = fmincg(costFunction, initial_nn_params, options);

% Obtain Theta1 and Theta2 back from nn_params
Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                 num_labels, (hidden_layer_size + 1));
                 
%imTest1=imresize(rgb2gray(imread('../test/t1.JPG')),[16 16]);
%imTest2=imresize(rgb2gray(imread('../test/t2.JPG')),[16 16]);
%imTest3=imresize(rgb2gray(imread('../test/t3.JPG')),[16 16]);
%p3=predict(Theta1,Theta2,double(imTest3(:)'));
%p2=predict(Theta1,Theta2,double(imTest2(:)'));
%p1=predict(Theta1,Theta2,double(imTest1(:)'));
p1=predict(Theta1,Theta2,X);
fprintf('\nTraining Set Accuracy: %f\n', mean(double(p1 == y)) * 100);
