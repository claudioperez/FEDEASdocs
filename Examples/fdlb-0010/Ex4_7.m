%% Script for Example 4.7 in Structural Analysis
%  Static solution for parabolic arch

%  =========================================================================================
%  FEDEASLab - Release 5.0, July 2018
%  Matlab Finite Elements for Design, Evaluation and Analysis of Structures
%  Professor Filip C. Filippou (filippou@berkeley.edu)
%  Department of Civil and Environmental Engineering, UC Berkeley
%  Copyright(c) 1998-2018. The Regents of the University of California. All Rights Reserved.
%  =========================================================================================

%% Clear workspace memory and initialize global variables
CleanStart

%% Create model
% specify node coordinates by generation
ne = 4;        % number of elements

Model = Model_PlaneArch(ne);

% plot parameters
% -------------------------------------------------------------------------
WinXr = 0.40;  % X-ratio of plot window to screen size 
WinYr = 0.80;  % Y-ratio of plot window to screen size
% -------------------------------------------------------------------------
NodSF = 0.60;  % relative size for node symbol
% -------------------------------------------------------------------------
% plot and label model for checking (optional)
Create_Window (WinXr,WinYr);       % open figure window
PlotOpt.PlNod = 'yes';
PlotOpt.PlBnd = 'yes';
PlotOpt.NodSF = NodSF;
Plot_Model  (Model,[],PlotOpt);    % plot model
PlotOpt.HngSF = 1.5;
PlotOpt.HOfSF = 1.5;
Plot_Releases (Model,[],[],PlotOpt);
PlotOpt.LOfSF = 2.5.*NodSF;
Label_Model (Model,PlotOpt);    % label model

B  = B_matrix (Model);
Bf = B(1:Model.nf,:);
% 
disp(['the size of Bf is ' num2str(size(Bf,1)) ' x ' num2str(size(Bf,2))])
disp(['the rank of Bf is ' num2str(rank(Bf))])

%% uniformly distributed load per unit of horizontal projection
w = 2;
% nodal forces for w
Pe(2:nn-1,2) = -w*L/ne*ones(nn-2,1);
% plot nodal forces for checking
Create_Window (WinXr,WinYr);
PlotOpt.PlNod = 'no';
PlotOpt.PlBnd = 'yes';
Plot_Model (Model,[],PlotOpt);
PlotOpt.HngSF = 1.5;
PlotOpt.HOfSF = 1.5;
Plot_Releases (Model,[],[],PlotOpt);
PlotOpt.Label ='yes';
PlotOpt.FrcSF = 5;
PlotOpt.TipSF = 1.25;
Plot_NodalForces (Model,Pe,PlotOpt);

% assign nodal forces to nodal force vector
Pf = Create_NodalForces(Model,Pe);
% solve for basic element forces
Q = Bf\Pf;

disp('The basic forces are')
disp(Q')
Pu = Pf-Bf*Q; 
disp('The norm of the equilibrium error is')
disp(Pu'*Pu)

%% plotting results
% -------------------------------------------------------------------------
ScaleN = 1/3;    % scale factor for axial forces
NDigt  = 2;      % number of significant digits for axial forces
% -------------------------------------------------------------------------

% plot axial force distribution
Create_Window (WinXr,WinYr);       % open figure window
Plot_Model(Model);
Plot_AxialForces(Model,Q,[],ScaleN);
AxialForcDg = 1;
Label_AxialForces(Model,Q,[],NDigt);