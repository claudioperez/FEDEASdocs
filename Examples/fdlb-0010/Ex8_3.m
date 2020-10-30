%% Script for Example 8.3 in Structural Analysis
%  Force-displacement for simply supported girder with overhang under distributed load

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
% specify node coordinates
XYZ(1,:) = [  0   0];
XYZ(2,:) = [ 15   0];
XYZ(3,:) = [ 20   0];
% connectivity array
CON(1,:) = [  1   2];
CON(2,:) = [  2   3];
% boundary conditions
BOUN(1,:) = [ 1 1];
BOUN(2,:) = [ 0 1];
% specify element type                       
[ElemName{1:2}] = deal('Lin2dFrm');

%% Model creation
Model = Create_SimpleModel (XYZ,CON,BOUN,ElemName);

% display model
% plot parameters
% -------------------------------------------------------------------------
WinXr = 0.40;   % X-ratio of plot window to screen size 
WinYr = 0.80;   % Y-ratio of plot window to screen size
% -------------------------------------------------------------------------
NodSF = 1/2;    % relative size for node symbol
AxsSF = 1/2;    % relative size of arrows
% -------------------------------------------------------------------------
Create_Window (WinXr,WinYr);       % open figure window
PlotOpt.PlNod = 'yes';
PlotOpt.PlBnd = 'yes';
PlotOpt.NodSF = NodSF;
Plot_Model (Model,[],PlotOpt);
Plotopt.AxsSF = AxsSF;
PlotOpt.LOfSF = 1.8.*NodSF;
Label_Model (Model,Plotopt);

%% set up static matrix B of structural model
B  = B_matrix(Model);
% extract upper nf rows for free dofs
Bf = B(1:Model.nf,:);

%% specify element properties
ne = Model.ne;   % number of elements in structural model
ElemData = cell(ne,1);
for el=1:ne
   ElemData{el}.E = 1000;       % elastic modulus
   ElemData{el}.A = 100;        % area does not matter for this problem
   ElemData{el}.I = 20;         % moment of inertia
   ElemData{el}.w = [0;-10];    % uniform element load w
end
% plot and label distributed element load
Create_Window (WinXr,WinYr);     % open figure window
PlotOpt.FrcSF = 3;
PlotOpt.TipSF = 1.25;
Plot_ElemLoading (Model,ElemData,PlotOpt);
Plot_Model (Model,[],PlotOpt);    % plot model

% generate applied force vector Pw
Pw  = Create_PwForces (Model,ElemData);
Pwf = Pw(1:Model.nf);

%% solve for basic forces Q (homogeneous static solution)
Q  = Bf\(-Pwf);

%% display and label bending moment distribution
% -------------------------------------------------------------------------
ScaleM = 1/3;    % scale factor for bending moments
MDigt  = 2;      % number of significant digits for bending moments
% -------------------------------------------------------------------------
Create_Window (WinXr,WinYr);    % open figure window
Plot_Model(Model);
Plot_2dMomntDistr(Model,[],Q,[],ScaleM);
Label_2dMoments(Model,Q,[],MDigt);

%% collection of element flexibility matrices
Fs = Fs_matrix(Model,ElemData);

%% determination of free dof displacements
% initial deformation vector due to element load
V0 = V0_vector(Model,ElemData);
% collection of element deformations
V  = Fs*Q + V0;
% free dof displacements under given nodal forces (Af = Bf')
Uf = (Bf')\V;

% plot deformed shape of structural model
MAGF = 15;                      % magnification factor for deformed shape
% display model
Create_Window (WinXr,WinYr);    % open figure window
Plot_Model(Model);
PlotOpt.MAGF = MAGF;
PlotOpt.PlNod = 'no';
Plot_Model(Model,Uf,PlotOpt)
PlotOpt.NodSF = NodSF;
Plot_DeformedStructure (Model,ElemData,Uf,[],PlotOpt);