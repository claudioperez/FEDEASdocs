%% Script for Example 4.6 in Structural Analysis
%  Static solution for determinate three hinge portal frame under distributed loading.

%  =========================================================================================
%  FEDEASLab - Release 5.0, July 2018
%  Matlab Finite Elements for Design, Evaluation and Analysis of Structures
%  Professor Filip C. Filippou (filippou@berkeley.edu)
%  Department of Civil and Environmental Engineering, UC Berkeley
%  Copyright(c) 1998-2018. The Regents of the University of California. All Rights Reserved.
%  =========================================================================================

Model = Model_05;

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
PlotOpt.AxsSF = 0.5;
Label_Model (Model,PlotOpt);    % label model

ElemData{3}.Release = [0;1;0];
PlotOpt.HngSF = 0.6;
PlotOpt.HOfSF = 1;
Plot_Releases (Model,ElemData,[],PlotOpt);

%% form static (equilibrium) matrix B
B  = B_matrix(Model);
% extract submatrix for free dofs
Bf = B(1:Model.nf,:);

% insert hinge at the left end of element c by removing corresponding column of Bf matrix
iq = setdiff(1:sum(Model.nq),8);
Bf = Bf(:,iq);

%% specify nodal forces at free dofs
% nodal forces
Pe(2,1) = 5;        % force at node 2 in direction X
% plot nodal forces for checking
Create_Window (WinXr,WinYr);
Plot_Model (Model,[],PlotOpt);
PlotOpt.Label='yes';
PlotOpt.FrcSF = 6;
PlotOpt.TipSF = 1.25;
Plot_NodalForces (Model,Pe,PlotOpt);

% generate applied force vector Pf
Pf = Create_NodalForces(Model,Pe);

%% generate equivalent nodal forces Pwf
ElemData{3}.w = [0;-5];

% plot and label distributed element load in the window of the nodal force(s)
PlotOpt.FrcSF = 4;
PlotOpt.TipSF = 1.25;
Plot_ElemLoading (Model,ElemData,PlotOpt);
Plot_Releases (Model,ElemData,[],PlotOpt);

% generate applied force vector Pw
Pw  = Create_PwForces (Model,ElemData);
Pwf = Pw(1:Model.nf);

%% solve for basic forces
% make sure to re-insert zero at moment release
Q     = zeros(12,1);
Q(iq) = Bf\(Pf-Pwf);
% display the result for the basic forces
disp('the basic forces are');
disp(Q);

%% determine support reactions
% the product B*Q delivers all forces at the global dofs
% the upper 11 should be equal to the applied forces, the lower 4 are the support reactions
disp('B*Q gives');
disp(B*Q);

%% plotting results
ScaleM = 1/2;    % scale factor for bending moments
MDigt  = 2;      % number of significant digits for bending moments

% open window and plot moment diagram for particular solution w/o effect of element load w
Create_Window (WinXr,WinYr);       % open figure window
Plot_Model (Model);
Plot_2dMomntDistr (Model,[],Q,[],ScaleM);
Label_2dMoments (Model,Q,[],MDigt);

% include effect of element load w by including ElemData in Plot_2dMomntDistr
Create_Window (WinXr,WinYr);       % open figure window
Plot_Model (Model);
Plot_2dMomntDistr (Model,ElemData,Q,[],ScaleM);
Label_2dMoments (Model,Q,[],MDigt);