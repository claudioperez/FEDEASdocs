function Model = Model_01
% Determinate plane truss

% define model geometry
XYZ(1,:) = [  0   0];  % first node
XYZ(2,:) = [  8   0];  % second node, etc
XYZ(3,:) = [ 16   0];  %
XYZ(4,:) = [  8   6];  % 
   
% element connectivity array
CON(1,:) = [  1   2];
CON(2,:) = [  2   3];
CON(3,:) = [  1   4];
CON(4,:) = [  2   4];
CON(5,:) = [  3   4];

% boundary conditions (1 = restrained,  0 = free) (specify only restrained dof's)
BOUN(1,:) = [ 1 1];
BOUN(3,:) = [ 0 1];

% specify element type
ne = length(CON);                       % number of elements
[ElemName{1:ne}] = deal('Truss');       % linear truss element

%% create Model
Model = Create_SimpleModel (XYZ,CON,BOUN,ElemName);
