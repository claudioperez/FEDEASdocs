%% Script for Example 8.4 in Structural Analysis
%  Force-displacement for determinate braced frame

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
[ElemName{1:3}] = deal('Lin2dFrm');    % 2d linear beam element
ElemName{4}     = 'LinTruss';          % linear truss element

%% create Model
Model = Create_SimpleModel (XYZ,CON,BOUN,ElemName);

% display model
% plot parameters
% -------------------------------------------------------------------------
WinXr = 0.40;   % X-ratio of plot window to screen size 
WinYr = 0.80;   % Y-ratio of plot window to screen size
% -------------------------------------------------------------------------
NodSF = 1/3;    % relative size for node symbol
AxsSF = 1/3;    % relative size of arrows
% -------------------------------------------------------------------------
Create_Window (WinXr,WinYr);       % open figure window
PlotOpt.PlNod = 'yes';
PlotOpt.PlBnd = 'yes';
PlotOpt.NodSF = NodSF;
Plot_Model (Model,[],PlotOpt);
PlotOpt.AxsSF = AxsSF;
PlotOpt.LOfSF = 1.8.*NodSF;
Label_Model (Model,PlotOpt);

%% form static matrix B
B  = B_matrix (Model);
% extract submatrix for free dofs Bf
Bf = B(1:Model.nf,:);
% select release locations (index ih) including axial deformations
ih = [2 6];
% continuous deformation locations ic
ic = setdiff(1:sum(Model.nq),ih);

%% specify applied forces at free dofs
Pe(2,1) = 20;
Pe(3,2) =-30;
% plot nodal forces for checking
Create_Window (WinXr,WinYr);
Plot_Model (Model,[],PlotOpt);
PlotOpt.Label='yes';
PlotOpt.FrcSF = 0.75;
PlotOpt.TipSF = 1.25;
Plot_NodalForces (Model,Pe,PlotOpt);

Pf = Create_NodalForces (Model,Pe);
% solution under applied forces
Q = zeros(sum(Model.nq),1);
Q(ic) = Bf(:,ic)\Pf;

%% specify element properties
ne = Model.ne;                  % number of elements in Model
ElemData = cell(Model.ne,1);
for el=1:ne
   ElemData{el}.E = 1000;       % elastic modulus
   ElemData{el}.A = 1e6;        % large area for "inextensible" elements a-c
   ElemData{el}.I = 50;         % moment of inertia
end
ElemData{4}.A = 10;             % correct area for brace element

%% collection of element flexibility matrices
Fs = Fs_matrix(Model,ElemData);

%% determination of free dof displacements
% collection of element deformations for particular solution
Veps = Fs*Q;
% determine free dof displacements based on continuous deformations
Af = Bf';
Uf = Af(ic,:)\Veps(ic);

%% determine release deformations Vh_p
Vh = Af*Uf-Veps;
disp('the fictitious release deformations are')
format short e
disp(Vh(ih))

%% plotting
MAGF = 20;                      % magnification factor for deformed shape
% display model
Create_Window (WinXr,WinYr);    % open figure window
% plot original geometry
Plot_Model (Model); 
% plot element chords in deformed geometry
PlotOpt.MAGF  = MAGF;
PlotOpt.PlNod = 'no';
Plot_Model (Model,Uf,PlotOpt);
% plot deformed shape with fictitious release deformations
ElemData{1}.Release = [0;1;0];
ElemData{2}.Release = [0;0;1];
PlotOpt.HngSF = 1/3;
PlotOpt.HOfSF = 0.6;
PlotOpt.NodSF = NodSF;
Plot_DeformedStructure (Model,ElemData,Uf,Veps,PlotOpt);