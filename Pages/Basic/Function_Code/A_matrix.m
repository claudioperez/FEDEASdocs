function A = A_matrix (Model)
%A_MATRIX kinematic matrix of structural model with 2d/3d truss and 2d frame elements
%  A = A_MATRIX (MODEL)
%  the function forms the kinematic matrix A for all degrees of freedom and
%  all element deformations of the structural model specified in data structure MODEL; 
%  the function is currently limited to 2d/3d truss and 2d frame elements

%  =========================================================================================
%  FEDEASLab - Release 3.0, July 2009
%  Matlab Finite Elements for Design, Evaluation and Analysis of Structures
%  Professor Filip C. Filippou (filippou@ce.berkeley.edu)
%  Department of Civil and Environmental Engineering, UC Berkeley
%  Copyright(c) 1998-2009. The Regents of the University of California. All Rights Reserved.
%  =========================================================================================
%  function added                                                                    10-2002
%  3d truss option                                                                   10-2003
%  -----------------------------------------------------------------------------------------

%%
% assemble structure compatibility matrix
ne = Model.ne;           % number of elements in structural model                  
k  = 0;                  % initialize row index into matrix A
for el=1:ne              % loop over all elements                   
   % locate element in Model and return end coordinates and id array
   [xyz,id] = Localize(Model,el);
   % form element compatibility matrix ag
   ag = ag_matrix(Model.ElemName{el},xyz);
   % assemble element compatibility matrix ag into structure matrix A
   nc = size(ag,1);      % number of rows of matrix ag
   A(k+1:k+nc,id) = ag;  % insert ag into location of matrix A
   k  = k+nc;            % augment row index by number of rows in ag
end

%% - function ag_matrix --------------------------------------------------------------------
function ag = ag_matrix(ElemName,xyz)
% the function forms the kinematic matrix ag of the element of type ElemName
% from its end node coordinates in array xyz

% determine element length and orientation
[L,dcx] = ElmLenOr(xyz);
if contains(ElemName,'Truss')
   % truss element
   ag = [-dcx' dcx'];
elseif contains(ElemName,'2dFrm')
   % 2d frame element
   dXL = dcx(1);
   dYL = dcx(2);
   ag  = [-dXL     -dYL     0   dXL      dYL      0;
          -dYL/L    dXL/L   1   dYL/L   -dXL/L    0;
          -dYL/L    dXL/L   0   dYL/L   -dXL/L    1];
else
   error ('only truss and 2d frame elements supported')
end