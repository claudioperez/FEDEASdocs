function Model = Model_03
% Determinate beam with overhang
%% clear memory and define global variables
CleanStart

%% define structural model (coordinates, connectivity, boundary conditions, element types)
% define model geometry
XYZ(1,:) = [  0   0];  % first node
XYZ(2,:) = [ 10   0];  % second node, etc
XYZ(3,:) = [ 20   0];  %
XYZ(4,:) = [ 25   0];  % 
   
% element connectivity array
CON(1,:) = [  1   2];
CON(2,:) = [  2   3];
CON(3,:) = [  3   4];

% boundary conditions (1 = restrained,  0 = free) (specify only restrained dof's)
BOUN(1,:) = [ 1 1];
BOUN(3,:) = [ 0 1];

% specify element type
ne = length(CON);                       % number of elements
[ElemName{1:ne}] = deal('2dFrm');       % linear 2d frame element

%% create Model
Model = Create_SimpleModel (XYZ,CON,BOUN,ElemName);
