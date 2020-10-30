function Model = Model_05
% Determinate three hinge portal frame under distributed loading

%% define structural model (coordinates, connectivity, boundary conditions, element types)
XYZ(1,:) = [  0   0];  % first node
XYZ(2,:) = [  0  10];  % second node, etc
XYZ(3,:) = [  8  10];  %
XYZ(4,:) = [ 16  10];  % 
XYZ(5,:) = [ 16 2.5];  % 
  
% element connectivity array
CON(1,:) = [  1   2];
CON(2,:) = [  2   3];
CON(3,:) = [  3   4];
CON(4,:) = [  4   5];

% boundary conditions (1 = restrained,  0 = free) (specify only restrained dof's)
BOUN(1,:) = [ 1 1 0];
BOUN(5,:) = [ 1 1 0];

% specify element type
ne = length(CON);                       % number of elements
[ElemName{1:ne}] = deal('2dFrm');       % 2d frame element

%% Model creation
Model = Create_SimpleModel (XYZ,CON,BOUN,ElemName);
