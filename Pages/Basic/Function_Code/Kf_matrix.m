function Kf = Kf_matrix (Model,ElemData)
%KF_MATRIX stiffness matrix at free dofs of structural model
%  KF = KF_MATRIX (MODEL,ELEMDATA)
%  the function forms the stiffness matrix KF at the free dofs of the structural model
%  specified in data structure MODEL with element property information in cell array ELEMDATA

%  =========================================================================================
%  FEDEASLab - Release 3.0, July 2009
%  Matlab Finite Elements for Design, Evaluation and Analysis of Structures
%  Professor Filip C. Filippou (filippou@ce.berkeley.edu)
%  Department of Civil and Environmental Engineering, UC Berkeley
%  Copyright(c) 1998-2009. The Regents of the University of California. All Rights Reserved.
%  =========================================================================================
%  function added                                                                    11-2002
%  3d truss option and releases for frame element                                    10-2003
%  -----------------------------------------------------------------------------------------

%%
ne = Model.ne;                         
nf = Model.nf;                         
nt = Model.nt;                         

K  = zeros(nt,nt);                     
for el=1:ne
   % locate element in Model and return end coordinates and id array
   [xyz,id] = Localize(Model,el);
   % form element stiffness matrix ke in global reference system
   ke = ke_matrix(Model.ElemName{el},ElemData{el},xyz);
   % assemble element stiffness matrix ke into structure matrix K 
   K (id,id) = K (id,id) + ke;
end
Kf = K(1:nf,1:nf); % extract stiffness matrix of free dof's

%% - function ke_matrix --------------------------------------------------------------------
function ke = ke_matrix(ElemName,ElemData,xyz)
% the function forms the element stiffness matrix ke in the global reference system
% for the element of type ElemName with end node coordinates xyz
% and element property information in data structure ElemData

% determine element length and orientation (direction cosines of x-axis)
[L,dcx] = ElmLenOr(xyz);

% extract element properties from ElemData
E  = ElemData.E;
A  = ElemData.A;
EA = E * A;

switch ElemName
   case 'LinTruss'
      % linear truss element
      % transformation matrix from basic to global
      ag = [-dcx' dcx'];
      k  = EA/L;
      ke = ag'*k*ag;
   case 'Lin2dFrm'
      % 2d linear frame element with or w/o release
      % transformation matrix from basic to global
      dXL = dcx(1);  dYL = dcx(2);
      ag  = [-dXL     -dYL     0   dXL      dYL      0;
             -dYL/L    dXL/L   1   dYL/L   -dXL/L    0;
             -dYL/L    dXL/L   0   dYL/L   -dXL/L    1];
      I  = ElemData.I;
      EI = E * I;
      k  = [ EA/L       0       0;
               0    4*EI/L  2*EI/L;
               0    2*EI/L  4*EI/L];
      % introduce release indices MR
      MR = zeros(3,1);
      if isfield(ElemData,'Release'), MR(ElemData.Release==1) = 1; end
      % compatibility matrix in the presence of moment release(s)
      ah = [ 1-MR(1)       0                    0;
              0            1-MR(2)        -0.5*(1-MR(3))*MR(2);
              0      -0.5*(1-MR(2))*MR(3)       1-MR(3)        ];
      % transform basic stiffness matrix for release(s)
      k  = ah'*k*ah;
      % transform basic stiffness to global reference
      ke = ag'*k*ag;
   otherwise
      error ('only linear truss and 2d frame elements supported')
end