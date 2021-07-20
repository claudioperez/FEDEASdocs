%% Script for Example 4.3 in First Course on Matrix Structural Analysis
%  kinematic solution for statically determinate three hinge portal frame

%  =========================================================================================
%  FEDEASLab - Release 3.2, July 2012
%  Matlab Finite Elements for Design, Evaluation and Analysis of Structures
%  Professor Filip C. Filippou (filippou@ce.berkeley.edu)
%  Department of Civil and Environmental Engineering, UC Berkeley
%  Copyright(c) 1998-2012. The Regents of the University of California. All Rights Reserved.
%  =========================================================================================

%% clear memory and define global variables
CleanStart

%% define structural model (coordinates, connectivity, boundary conditions, element types)
% specify node coordinates
XYZ(1,:) = [  0   0  ];  % first node
XYZ(2,:) = [  0  10  ];  % second node, etc
XYZ(3,:) = [  8  10  ];  %
XYZ(4,:) = [ 16  10  ];  % 
XYZ(5,:) = [ 16   2.5];  % 
   
% connectivity array
CON(1,:) = [  1   2];
CON(2,:) = [  2   3];
CON(3,:) = [  3   4];
CON(4,:) = [  4   5];

% boundary conditions (1 = restrained,  0 = free) (specify only restrained dof's)
BOUN(1,:) = [ 1 1 1];
BOUN(5,:) = [ 1 1 1];

% specify element type
ne = length(CON);                       % number of elements
[ElemName{1:ne}] = deal('Lin2dFrm');    % linear frame element

%% Model creation
Model = Create_SimpleModel (XYZ,CON,BOUN,ElemName);
% plot and label model for checking (optional)
Create_Window (0.50,0.80);         % open figure window
Plot_Model  (Model);               % plot model (optional)
Label_Model (Model);               % label model (optional)

%% specify element deformations
Veps = zeros(sum(Model.nq),1);
for el=1:Model.ne
   [xyz] = Localize (Model,el);
   L(el) = ElmLenOr (xyz);
end
Veps(2:3) = -0.00072.*[-1;1].*L(1)/2;
Veps(5:6) = -0.0006 .*[-1;1].*L(2)/2;
Veps(8:9) = -0.0006 .*[-1;1].*L(3)/2;
% ih=release index, ic=continuous deformation index
ih = [2 8 12];  
ic = setdiff(1:sum(Model.nq),ih);

format short e
% form kinematic matrix A
A  = A_matrix(Model);
% submatrix for free dofs and continuous deformations
Af = A(ic,1:Model.nf);
% solve for free dof displacements
Uf = Af\Veps(ic);
% determine release deformation(s)
Vh = A(:,1:Model.nf)*Uf-Veps;
disp('the release deformations are')
disp(Vh(ih))

%% plot deformed shape of structural model
Create_Window(0.50,0.80);
Plot_Model(Model);
% plot element chords in deformed configuration
PlotOpt.MAGF = 60; 
Plot_Model(Model,Uf,PlotOpt);
Plot_DeformedStructure (Model,[],Uf,Veps,PlotOpt);
print -painters -dpdf -r600 Ex5_3F1

Create_Window(0.50,0.80);
PlotOpt.NodSF = 0.60;
Plot_Model(Model);
% plot element chords in deformed configuration
PlotOpt.MAGF = 60; 
Plot_Model(Model,Uf,PlotOpt);
PlotOpt.HngSF = 0.60;
ElemData{1}.Release = [0;1;0];
ElemData{3}.Release = [0;1;0];
ElemData{4}.Release = [0;0;1];
Plot_DeformedStructure (Model,ElemData,Uf,Veps,PlotOpt);
print -painters -dpdf -r600 Ex5_3F2