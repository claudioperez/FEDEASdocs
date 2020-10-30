%% Script for Example 4.2 in Structural Analysis
%  Static solution for determinate space truss.

%  =========================================================================================
%  FEDEASLab - Release 5.0, July 2018
%  Matlab Finite Elements for Design, Evaluation and Analysis of Structures
%  Professor Filip C. Filippou (filippou@berkeley.edu)
%  Department of Civil and Environmental Engineering, UC Berkeley
%  Copyright(c) 1998-2018. The Regents of the University of California. All Rights Reserved.
%  =========================================================================================

Model = Model_02;

% plot parameters
% -------------------------------------------------------------------------
WinXr = 0.40;  % X-ratio of plot window to screen size 
WinYr = 0.80;  % Y-ratio of plot window to screen size
% -------------------------------------------------------------------------
% plot and label model for checking (optional)
Create_Window (WinXr,WinYr);       % open figure window
PlotOpt.PlNod = 'yes';
PlotOpt.PlBnd = 'yes';
Plot_Model  (Model,[],PlotOpt);    % plot model
Label_Model (Model);               % label model with default properties

%% form static (equilibrium) matrix B
B  = B_matrix(Model);
% extract submatrix for free dofs
Bf = B(1:Model.nf,:);

disp(['the size of Bf is ' num2str(size(Bf,1)) ' x ' num2str(size(Bf,2))])
disp(['the rank of Bf is ' num2str(rank(Bf))])

%% define loading
% specify nodal forces
Pe(4,:) = [5 0 -20];
Pe(5,:) = [5 0 -20];
Pe(6,:) = [5 0 -20];

% plot nodal forces for checking
Create_Window (WinXr,WinYr);
PlotOpt.PlNod = 'no';
Plot_Model (Model,[],PlotOpt);
PlotOpt.Label ='yes';
PlotOpt.FrcSF = 3;
Plot_NodalForces (Model,Pe,PlotOpt);

% generate applied force vector Pf
Pf = Create_NodalForces (Model,Pe);

% solve for basic forces and display the result
Q  = Bf\Pf;
disp('the basic forces are');
disp(Q);

% determine support reactions: the product B*Q delivers all forces at the global dofs
% the upper nf should be equal to the applied forces, the lower nt-nf are the support reactions
disp('B*Q gives');
disp(B*Q);

%% plotting results
% -------------------------------------------------------------------------
ScaleN = 0.6;    % scale factor for axial forces
NDigt  = 2;      % number of significant digits for axial forces
% -------------------------------------------------------------------------

% plot axial force distribution
Create_Window (WinXr,WinYr);       % open figure window
Plot_Model(Model);
Plot_AxialForces(Model,Q,[],ScaleN);
AxialForcDg = 1;
Label_AxialForces(Model,Q,[],NDigt);