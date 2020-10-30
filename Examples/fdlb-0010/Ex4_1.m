%% Script for Example 4.1 in Structural Analysis
%  Static solution for determinate plane truss

%  =========================================================================================
%  FEDEASLab - Release 5.0, July 2018
%  Matlab Finite Elements for Design, Evaluation and Analysis of Structures
%  Professor Filip C. Filippou (filippou@berkeley.edu)
%  Department of Civil and Environmental Engineering, UC Berkeley
%  Copyright(c) 1998-2018. The Regents of the University of California. All Rights Reserved.
%  =========================================================================================

%% the following example shows the determination of the truss response first without and then
%  with the use of FEDEASLab functions

%% perform each step with Matlab functions
% clear memory
CleanStart

% specify static (equilibrium) matrix Bf
Bf = [1  -1    0    0     0;
      0   0    0   -1     0;
      0   1    0    0    0.8;
      0   0   0.8   0   -0.8;
      0   0   0.6   1    0.6];
   
% specify applied force vector
Pf = [ 0; -5; 0; 10; 0];

% solve for basic forces Q
Q  = Bf\Pf;

% display result
format short
disp('the basic forces are');
disp(Q);

Model = Model_01;

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
Label_Model (Model,PlotOpt);       % label model

%% form static (equilibrium) matrix B
B  = B_matrix(Model);
% extract submatrix for free dofs
Bf = B(1:Model.nf,:);

%% specify loading
Pe(2,2) = -5;    % force at node 2 in direction Y
Pe(4,1) = 10;    % force at node 4 in direction X

% plot nodal forces for checking
Create_Window (WinXr,WinYr);
PlotOpt.PlNod = 'no';
PlotOpt.PlBnd = 'yes';
Plot_Model (Model,[],PlotOpt);
PlotOpt.Label ='yes';
PlotOpt.FrcSF = 4;
PlotOpt.TipSF = 1.25;
Plot_NodalForces (Model,Pe,PlotOpt);

% generate applied force vector Pf
Pf = Create_NodalForces (Model,Pe);

%% solution for basic forces and support reactions
% solve for basic forces and display the result
Q  = Bf\Pf;
disp('the basic forces are');
disp(Q);

% determine support reactions: the product B*Q delivers all forces at the global dofs
% the upper 5 should be equal to the applied forces, the lower 3 are the support reactions
disp('B*Q gives');
disp(B*Q);

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
