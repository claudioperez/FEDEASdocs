function Model = Model_06(stat)

if nargin <1, stat='iso'; end

%% define structural model (coordinates, connectivity, boundary conditions, element types)
% specify node coordinates
XYZ(1,:) = [  0   0];  % first node
XYZ(2,:) = [  8   0];  % second node, etc
XYZ(3,:) = [  0   6];  %
XYZ(4,:) = [  8   6];  % 
   
% connectivity array
CON(1,:) = [  1   2];
CON(2,:) = [  1   3];
CON(3,:) = [  2   4];
CON(4,:) = [  3   4];
if stat=='hyp'
    CON(5,:) = [  2   3];
    CON(6,:) = [  1   4];
else
    CON(5,:) = [  1   4];
end

% boundary conditions (1 = restrained,  0 = free) (specify only restrained dof's)
BOUN(1,:) = [ 1 1];
BOUN(2,:) = [ 0 1];

% specify element type
ne = length(CON);                       % number of elements
[ElemName{1:ne}] = deal('Truss');       % truss element


%% Model creation
Model = Create_SimpleModel (XYZ,CON,BOUN,ElemName);