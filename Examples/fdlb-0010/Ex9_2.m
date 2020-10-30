%% Script for Example 9.2 in Structural Analysis
%  Force method of analysis for braced frame with `NOS=2`

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
HngSF = 1/4;    % relative size for releases
HOfSF = 1/2;    % relative size for release offset
% -------------------------------------------------------------------------
Create_Window (WinXr,WinYr);       % open figure window
PlotOpt.PlNod = 'yes';
PlotOpt.PlBnd = 'yes';
PlotOpt.NodSF = NodSF;
Plot_Model (Model,[],PlotOpt);
PlotOpt.AxsSF = AxsSF;
PlotOpt.LOfSF = 1.8.*NodSF;
Label_Model (Model,PlotOpt);

%% specify element properties
ne = Model.ne;                  % number of elements in Model
ElemData = cell(ne,1);
for el=1:ne
   ElemData{el}.E = 1000;       % elastic modulus
   ElemData{el}.A = 1e6;        % large area for "inextensible" elements a-c
   ElemData{el}.I = 50;         % moment of inertia
end
ElemData{4}.A = 10;             % correct area for brace element

%% First load case: applied nodal forces
% specify nodal forces
Pe(2,1) =  20;
Pe(3,2) = -30;
% plot nodal forces for checking
Create_Window (WinXr,WinYr);
Plot_Model (Model,[],PlotOpt);
PlotOpt.Label='yes';
PlotOpt.FrcSF = 0.75;
PlotOpt.TipSF = 1.25;
Plot_NodalForces (Model,Pe,PlotOpt);

Pf = Create_NodalForces (Model,Pe);

%% force method of analysis
% specify index ind_r for redundant basic forces (optional)
ind_r = [2 6];
S_ForceMethod
% display value for redundant basic forces
disp(['the redundant basic forces Qx are ' num2str(Qx')])

% display displacements
disp('free dof displacements Uf under applied nodal forces')
disp(Uf)

%% plotting
% display and label bending moment distribution
% -------------------------------------------------------------------------
ScaleM = 1/4;    % scale factor for bending moments
MDigt  = 2;      % number of significant digits for bending moments
% -------------------------------------------------------------------------
Create_Window (WinXr,WinYr);    % open figure window
Plot_Model(Model);
Plot_2dMomntDistr(Model,[],Q,[],ScaleM);
Label_2dMoments(Model,Q,[],MDigt);

% plot deformed shape of structural model
MAGF = 100;                     % magnification factor for deformed shape
% display model
Create_Window (WinXr,WinYr);    % open figure window
Plot_Model(Model);
PlotOpt.MAGF  = MAGF;
PlotOpt.PlNod = 'no';
Plot_Model(Model,Uf,PlotOpt)
PlotOpt.HngSF = HngSF;
PlotOpt.HOfSF = HOfSF;
PlotOpt.NodSF = NodSF;
Plot_DeformedStructure (Model,ElemData,Uf,[],PlotOpt);

% store value for horizontal translation dof for later use
U1_1 = Uf(Model.DOF(2,1));

%% Second load case: unit prestressing force
clear Pf
% define initial deformation vector for second load case (unit prestress)
ElemData{4}.q0 = 1;

%% force method of analysis
S_ForceMethod
% display value for redundant basic forces
disp(['the redundant basic forces Qx are ' num2str(Qx')])

% display displacements
disp('free dof displacements Uf under applied nodal forces')
disp(Uf)

%% plotting
% display and label bending moment distribution
Create_Window (WinXr,WinYr);       % open figure window
Plot_Model(Model);
Plot_2dMomntDistr(Model,[],Q,[],ScaleM);
Label_2dMoments(Model,Q,[],MDigt);

MAGF = 2000;                    % magnification factor for deformed shape
% display model
Create_Window (WinXr,WinYr);    % open figure window
Plot_Model(Model);
PlotOpt.MAGF  = MAGF;
PlotOpt.PlNod = 'no';
Plot_Model(Model,Uf,PlotOpt)
PlotOpt.NodSF = NodSF;
Plot_DeformedStructure (Model,ElemData,Uf,[],PlotOpt);

% store value for horizontal translation dof for later use
U1_2 = Uf(1);

%% Third load case: applied nodal forces and prestressing for optimum moment distribution
ElemData{4}.q0 = 43.729;
Pf = Create_NodalForces (Model,Pe);

%% force method of analysis
S_ForceMethod
% display value for redundant basic forces
disp(['the redundant basic forces Qx are ' num2str(Qx')])

% display displacements
disp('free dof displacements Uf under applied nodal forces')
disp(Uf)

%% plotting
% display and label bending moment distribution
Create_Window (WinXr,WinYr);       % open figure window
Plot_Model(Model);
Plot_2dMomntDistr(Model,[],Q,[],ScaleM);
Label_2dMoments(Model,Q,[],MDigt);

% deformed shape
MAGF = 100;                     % magnification factor for deformed shape
% display model
Create_Window (WinXr,WinYr);    % open figure window
Plot_Model(Model);
PlotOpt.MAGF  = MAGF;
PlotOpt.PlNod = 'no';
Plot_Model(Model,Uf,PlotOpt)
PlotOpt.NodSF = NodSF;
Plot_DeformedStructure (Model,ElemData,Uf,[],PlotOpt);

%% Fourth load case: applied nodal forces and prestressing
% determine prestressing force so as to cancel horizontal translation under applied nodal forces
ElemData{4}.q0 = -U1_1/U1_2;

%% force method of analysis
S_ForceMethod
% display value for redundant basic forces
disp(['the redundant basic forces Qx are ' num2str(Qx')])

% display displacements
disp('free dof displacements Uf under applied nodal forces')
disp(Uf)

%% plotting
% display and label bending moment distribution
Create_Window (WinXr,WinYr);       % open figure window
Plot_Model(Model);
Plot_2dMomntDistr(Model,[],Q,[],ScaleM);
Label_2dMoments(Model,Q,[],MDigt);

% deformed shape
Create_Window (WinXr,WinYr);       % open figure window
MAGF = 100;                     % magnification factor for deformed shape
Plot_Model(Model);
PlotOpt.MAGF  = MAGF;
PlotOpt.PlNod = 'no';
Plot_Model(Model,Uf,PlotOpt)
PlotOpt.NodSF = NodSF;
Plot_DeformedStructure (Model,ElemData,Uf,[],PlotOpt);