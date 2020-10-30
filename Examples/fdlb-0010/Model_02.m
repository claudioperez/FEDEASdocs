function Model = Model_02
% Determinate space truss.
%% clear memory and define global variables
% CleanStart

%% define structural model (coordinates, connectivity, boundary conditions, element types)
% specify node coordinates (XYZ is a 6 by 3 array for this problem)
XYZ(1,:) = [-10  -5.77   0];   % X, Y and Z coordinate of node 1
XYZ(2,:) = [ 10  -5.77   0];   % X, Y and Z coordinate of node 2, etc
XYZ(3,:) = [  0  11.55   0];
XYZ(4,:) = [  0  -3.47  16];
XYZ(5,:) = [  3   1.73  16];
XYZ(6,:) = [ -3   1.73  16];
   
% connectivity array  (this is a cell array with row vectors for each cell)
% note the syntax of braces for the contents of a particular cell array element
CON(1,:) = [  1   6];      % element 1 connects nodes 1 and 6
CON(2,:) = [  1   4];      % element 2 connects nodes 1 and 4, etc
CON(3,:) = [  2   4];
CON(4,:) = [  2   5];
CON(5,:) = [  3   5];
CON(6,:) = [  3   6];
CON(7,:) = [  4   5];
CON(8,:) = [  5   6];
CON(9,:) = [  4   6];

% boundary conditions (BOUN is a 6 by 3 array, but only the restrained nodes need
% to be specified (1 = restrained,  0 = free)
BOUN(1,:) = [1 1 1];
BOUN(2,:) = [1 1 1];
BOUN(3,:) = [1 1 1];

% specify element type (ElemName is another cell array with character variables this time)
ne = length(CON);
[ElemName{1:ne}] = deal('Truss');    % linear truss element

%% Model creation
Model = Create_SimpleModel(XYZ,CON,BOUN,ElemName);
