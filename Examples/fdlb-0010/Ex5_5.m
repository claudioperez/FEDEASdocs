%% Script for Example 5.5 in Structural Analysis
%  Kinematic solution for indeterminate braced frame with `NOS=2`.

%  =========================================================================================
%  FEDEASLab - Release 5.0, July 2018
%  Matlab Finite Elements for Design, Evaluation and Analysis of Structures
%  Professor Filip C. Filippou (filippou@berkeley.edu)
%  Department of Civil and Environmental Engineering, UC Berkeley
%  Copyright(c) 1998-2018. The Regents of the University of California. All Rights Reserved.
%  =========================================================================================

%% clear memory and define global variables
CleanStart

%% define structural model (coordinates, connectivity, boundary conditions, element types)
% specify node coordinates (could only specify non-zero terms)
XYZ(1,:) = [  0    0];  % first node
XYZ(2,:) = [  0    6];  % second node, etc
XYZ(3,:) = [  4    6];  %
XYZ(4,:) = [  8    6];

% connectivity array
CON(1,:) = [  1   2];
CON(2,:) = [  2   3];
CON(3,:) = [  3   4];
CON(4,:) = [  1   4];

% boundary conditions (1 = restrained,  0 = free) (specify only restrained dof's)
BOUN(1,:) = [1 1 1];
BOUN(4,:) = [0 1 0];

% specify element type
[ElemName{1:3}] = deal('2dFrm');    % 2d linear beam element
ElemName{4}     = 'Truss';          % linear truss element

%% create Model
Model = Create_SimpleModel (XYZ,CON,BOUN,ElemName);

%% form kinematic matrix A
A  = A_matrix (Model);
% extract submatrix for free dofs Af
Af = A(:,1:Model.nf);

%% specify element deformations
Veps = zeros(sum(Model.nq),1);
L    = zeros(Model.ne,1);
for el=1:Model.ne
   [xyz] = Localize (Model,el);
   L(el) = ElmLenOr (xyz);
end
Veps(2:3) =  0.002 .*[-1;1].*L(1)/2;
Veps(5:6) =  0.002 .*[-1;1].*L(2)/2;
Veps(8:9) =  0     .*[-1;1].*L(3)/2;
Veps(10)  =  0.01;

%% determine free dof displacements based on continuous deformations
% select fictitious release locations (index ih) including axial deformations
ih = [2 6];
% continuous deformation locations ic
ic = setdiff(1:sum(Model.nq),ih);
Uf = Af(ic,:)\Veps(ic);

%% determine fictitious release deformations Vh
Vh = Af*Uf-Veps;
disp('the fictitious release deformations are')
format short e
disp(Vh(ih))

%% plotting
% plot parameters
% -------------------------------------------------------------------------
WinXr = 0.40;   % X-ratio of plot window to screen size 
WinYr = 0.80;   % Y-ratio of plot window to screen size
% -------------------------------------------------------------------------
MAGF  = 40;                        % magnification factor for deformed shape
% -------------------------------------------------------------------------
% display model
Create_Window (WinXr,WinYr);       % open figure window
PlotOpt.MAGF = MAGF;
% plot original geometry
Plot_Model (Model,[],PlotOpt); 
% % plot element chord in deformed geometry
PlotOpt.PlBnd = 'yes';
PlotOpt.NodSF = 1/3;
Plot_Model (Model,Uf,PlotOpt);
% plot deformed shape with fictitious release deformations
ElemData{1}.Release = [0;1;0];
ElemData{2}.Release = [0;0;1];
PlotOpt.HngSF = 1/3;
PlotOpt.HOfSF = 0.6;
PlotOpt.NodSF = 1/3;
Plot_DeformedStructure (Model,ElemData,Uf,Veps,PlotOpt);