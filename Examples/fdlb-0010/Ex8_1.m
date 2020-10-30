%% Script for Example 8.1 in Structural Analysis
%  Force-displacement for statically determinate truss

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
XYZ(2,:) = [ 12   0];
XYZ(3,:) = [  6   8];
% connectivity array
CON(1,:) = [  1   2];
CON(2,:) = [  1   3];
CON(3,:) = [  2   3];
% boundary conditions
BOUN(1,:) = [ 1 1];
BOUN(2,:) = [ 0 1];
% specify element type                       
[ElemName{1:3}] = deal('LinTruss');

%% Model creation
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

PlotOpt.HngSF = 1/3;
PlotOpt.HOfSF = 0.6;
Plot_Releases (Model,[],[],PlotOpt);

%% set up static matrix B of structural model
B  = B_matrix(Model);
% extract upper nf rows for free dofs
Bf = B(1:Model.nf,:);

%% specify applied forces at free dofs
Pe(3,1) = 20;
Pe(3,2) =-10;
% plot nodal forces for checking
Create_Window (WinXr,WinYr);
PlotOpt.PlNod = 'no';
PlotOpt.PlBnd = 'yes';
Plot_Model (Model,[],PlotOpt);
PlotOpt.Label='yes';
Plot_NodalForces (Model,Pe,PlotOpt);

Pf = Create_NodalForces (Model,Pe);

%% solve for basic forces Q
Q  = Bf\Pf;

%% display results and label values
ScaleN = 1/5;                        % scale factor for axial forces
Create_Window (WinXr,WinYr);         % open figure window
Plot_Model(Model);
Plot_AxialForces(Model,Q,[],ScaleN);
Label_AxialForces(Model,Q);

%% specify element properties
ne = Model.ne;   % number of elements in structural model
ElemData = cell(ne,1);
for el=1:ne
   ElemData{el}.E = 1000;   % elastic modulus
   ElemData{el}.A = 10;     % area
end
ElemData{2}.A = 20;         % correct area of element b

%% collection of element flexibility matrices
Fs = Fs_matrix(Model,ElemData);

% collection of element deformations
V  = Fs*Q;
% free dof displacements under given nodal forces (Af = Bf')
Uf = (Bf')\V;

% plot deformed shape of structural model
MAGF  = 40;                     % magnification factor for deformed shape
% display model
Create_Window (WinXr,WinYr);    % open figure window
PlotOpt.MAGF = MAGF;
Plot_Model(Model);
PlotOpt.PlRel = 'no';
PlotOpt.NodSF = NodSF;
Plot_DeformedStructure (Model,ElemData,Uf,[],PlotOpt);