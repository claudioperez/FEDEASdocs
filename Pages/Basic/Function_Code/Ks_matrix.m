function Ks = Ks_matrix (Model,ElemData)
%KS_MATRIX block diagonal matrix of basic element stiffness matrices for structural model
%  KS = KS_MATRIX (MODEL,ELEMDATA)
%  the function sets up the block diagonal matrix of basic element stiffness matrices KS
%  for the structural model specified in data structure MODEL with element property
%  information in cell array ELEMDATA 

%  =========================================================================================
%  FEDEASLab - Release 3.2, July 2012
%  Matlab Finite Elements for Design, Evaluation and Analysis of Structures
%  Professor Filip C. Filippou (filippou@ce.berkeley.edu)
%  Department of Civil and Environmental Engineering, UC Berkeley
%  Copyright(c) 1998-2012. The Regents of the University of California. All Rights Reserved.
%  =========================================================================================
%  function added                                                                    05-2006
%  -----------------------------------------------------------------------------------------

%% loop over all elements in structural model
ne = Model.ne;
k  = cell(ne,1);
for el = 1:ne
   % locate element in Model and return end coordinates xyz
   xyz = Localize(Model,el);
   % determine element length from end coordinates
   L = ElmLenOr(xyz);
   % set up element stiffness matrix
   k{el} = k_matrix (Model.ElemName{el},ElemData{el},L);
end
% block-diagonal array of element stiffness matrices
Ks = blkdiag (k{:});

%%  function k_matrix ----------------------------------------------------------------------
function k = k_matrix (ElemName,ElemData,L)
% the function forms the basic element stiffness matrix k for the element of type ElemName
% with length L and element property information in data structure ElemData

% extract element properties from ElemData
E  = ElemData.E;    % elastic modulus
A  = ElemData.A;    % area
EA = E*A;           % axial stiffness

switch ElemName
  case 'LinTruss'
    % linear truss element
    k  = EA/L;
  case 'Lin2dFrm'
    % 2d linear frame element
    I  = ElemData.I;
    EI = E*I;
    f  = [L/EA   0          0       ;
           0    L/(3*EI)  -L/(6*EI) ;
           0   -L/(6*EI)   L/(3*EI)];
    % extract necessary submatrix in the presence of release(s)
    ide = 1:3;
    if isfield(ElemData,'Release')
      idr = find(ElemData.Release);
      ide = setdiff(ide,idr);
    end
    f = f(ide,ide);
    % invert element flexibility to get basic element stiffness
    k = inv(f);
  otherwise
    error ('only linear truss and 2d frame elements supported')
end