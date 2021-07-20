function B = B_matrix (Model)
%B_MATRIX static matrix of structural model with 2d/3d truss and 2d frame elements
%  B = B_MATRIX (MODEL)
%  the function forms the static matrix B for all degrees of freedom and
%  all basic forces of the structural model specified in data structure MODEL;
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
% assemble structure equilibrium matrix
ne = Model.ne;          % number of elements in structural model
k  = 0;                 % initialize column index into matrix B
for el=1:ne             % loop over all elements
   % locate element in Model and return end coordinates and id array
   [xyz,id] = Localize(Model,el);
   % form element equilibrium matrix bg
   bg = bg_matrix(Model.ElemName{el},xyz);
   % assemble element equilibrium matrix bg into static matrix B
   nc = size(bg,2);     % determine number of columns of matrix bg
   B(id,k+1:k+nc) = bg; % insert bg into id locations of matrix B
   k  = k+nc;           % augment column index by number of columns
end

%% - function bg_matrix --------------------------------------------------------------------
function bg = bg_matrix(ElemName,xyz)
% the function forms the static matrix bg of the element of type ElemName
% from its end node coordinates in array xyz

% determine element length and orientation
[L,dcx] = ElmLenOr(xyz);
if contains(ElemName,'Truss')
   % truss element
   bg = [-dcx; dcx];
elseif contains(ElemName,'2dFrm')
   % 2d frame element
   dXL = dcx(1);
   dYL = dcx(2);
   bg  = [-dXL  -dYL/L  -dYL/L;
          -dYL   dXL/L   dXL/L;
             0     1       0  ;
           dXL   dYL/L   dYL/L;
           dYL  -dXL/L  -dXL/L;
             0     0       1  ];
else
   error ('only truss and 2d frame elements supported; check syntax')
end