function Fs = Fs_matrix (Model,ElemData,Roption)
%FS_MATRIX block diagonal matrix of element flexibity matrices for structural model
%  FS = FS_MATRIX (MODEL,ELEMDATA,ROPTION)
%  the function sets up the block diagonal matrix of element flexibility matrices FS
%  for the structural model specified in data structure MODEL with element property
%  information in cell array ELEMDATA;
%  if ROPTION=0, element release information is not accounted for in setting up Fs (default=1)

%  =========================================================================================
%  FEDEASLab - Release 3.2, July 2012
%  Matlab Finite Elements for Design, Evaluation and Analysis of Structures
%  Professor Filip C. Filippou (filippou@ce.berkeley.edu)
%  Department of Civil and Environmental Engineering, UC Berkeley
%  Copyright(c) 1998-2012. The Regents of the University of California. All Rights Reserved.
%  =========================================================================================
%  function added                                                                    11-2002
%  support for hinge element added                                                   11-2003
%  Roption added                                                                     07-2012
%  -----------------------------------------------------------------------------------------

if (nargin==2), Roption = 1; end
%% loop over all elements in structural model
ne = Model.ne;
f  = cell(ne,1);
% loop over all elements in structural model
for el = 1:ne
  % locate element in Model and return end coordinates xyz
  xyz = Localize(Model,el);
  % determine element length from end coordinates
  L = ElmLenOr(xyz);
  % set up element flexibility matrix
  f{el} = f_matrix (Model.ElemName{el},ElemData{el},L,Roption);
end
% block-diagonal array of element flexibility matrices
Fs = blkdiag (f{:});

%% -function f_matrix ----------------------------------------------------------------------
function f = f_matrix (ElemName,ElemData,L,Roption)
% the function forms the element flexibility matrix f for the element of type ElemName
% with length L and element property information in data structure ElemData
%  if Roption=0 element release information is not accounted for in setting up Fs (default=1)

% extract element properties from ElemData
E  = ElemData.E;    % elastic modulus
A  = ElemData.A;    % area
EA = E*A;           % axial stiffness

switch ElemName
  case 'LinTruss'
    % linear truss element
    f  = L/EA;
  case 'Lin2dFrm'
    % 2d linear frame element
    I  = ElemData.I;
    EI = E*I;
    f  = [L/EA   0          0   ;
           0    L/(3*EI)  -L/(6*EI) ;
           0   -L/(6*EI)   L/(3*EI)];
    % extract necessary submatrix in the presence of release(s)
    ide = 1:3;
    if Roption && isfield(ElemData,'Release')
      idr = find(ElemData.Release);
      ide = setdiff(ide,idr);
    end
    f = f(ide,ide);
  otherwise
    error ('only linear truss and 2d frame elements supported')
end