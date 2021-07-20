function Q0 = Q0_vector (Model,ElemData)
%Q0_VECTOR initial (fixed-end) force vector for structural model
%  Q0 = Q0_VECTOR (MODEL,ELEMDATA)
%  the function sets up the initial (fixed-end) force vector Q0 for the structural model
%  specified in data structure MODEL with element property information in cell array ELEMDATA

%  =========================================================================================
%  FEDEASLab - Release 3.5, August 2014
%  Matlab Finite Elements for Design, Evaluation and Analysis of Structures
%  Professor Filip C. Filippou (filippou@ce.berkeley.edu)
%  Department of Civil and Environmental Engineering, UC Berkeley
%  Copyright(c) 1998-2014. The Regents of the University of California. All Rights Reserved.
%  =========================================================================================
%  function added                                                                    04-2012
%  -----------------------------------------------------------------------------------------

%% loop over all elements in structural model
ne = Model.ne;
q0 = cell(ne,1);
for el=1:Model.ne
   % locate element in Model and return end coordinates xyz
   xyz = Localize(Model,el);
   % determine element length from end coordinates
   L = ElmLenOr(xyz);
   % set up initial (fixed-end) force vector for element el
   q0{el} = q0_vector (Model.ElemName{el},ElemData{el},L);
end
% initial (fixed-end) force vector for structural model
Q0 = vertcat(q0{:});

%% - function v0_vector --------------------------------------------------------------------
function q0 = q0_vector (ElemName,ElemData,L)
% function forms the initial (fixed-end) force vector q0 for the element with name ElemName
% from element length L and element property information in data structure ElemData

E  = ElemData.E;    % elastic modulus
A  = ElemData.A;    % area
EA = E*A;           % axial stiffness

switch ElemName
  case 'LinTruss'
    % linear truss element
    if ~isfield(ElemData,'e0'), ElemData.e0 = 0; end
    if ~isfield(ElemData,'q0'), ElemData.q0 = 0; end
    e0 = ElemData.e0;   % initial axial strain
    q0 = ElemData.q0;   % initial prestressing force
    q0 = q0 - EA*e0;    % fixed-end force vector
  case 'Lin2dFrm'
    % 2d linear frame element
    I  = ElemData.I;
    EI = E*I;
    if ~isfield(ElemData,'e0'), ElemData.e0 = [0;0]; end
    if ~isfield(ElemData,'w'),  ElemData.w  = [0;0]; end
    e0 = ElemData.e0;   % initial section deformations
    w  = ElemData.w;    % uniformly element load in x and y
    % 2d linear frame element
    v0 = [e0(1)*L; -e0(2)*L/2 ; e0(2)*L/2];
    v0 = v0 + [w(1)*L*L/(2*EA) ; w(2)*L^3/(24*EI) ; -w(2)*L^3/(24*EI)];
    % flexibility matrix
    f  = [L/EA   0          0       ;
           0    L/(3*EI)  -L/(6*EI) ;
           0   -L/(6*EI)   L/(3*EI)];
    % index of continuous element deformations
    ide = 1:3;
    if isfield(ElemData,'Release')
      idr = find(ElemData.Release);
      ide = setdiff(ide,idr);
    end
    v0 = v0(ide);
    f  = f(ide,ide);
    q0 = -f\v0;
  otherwise
    error ('only linear truss and 2d frame elements supported')
end