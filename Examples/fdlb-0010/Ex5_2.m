%% Script for Example 5.2 in Structural Analysis
%  Kinematic solution for statically determinate beam with overhang.

%  =========================================================================================
%  FEDEASLab - Release 5.0, July 2018
%  Matlab Finite Elements for Design, Evaluation and Analysis of Structures
%  Professor Filip C. Filippou (filippou@berkeley.edu)
%  Department of Civil and Environmental Engineering, UC Berkeley
%  Copyright(c) 1998-2018. The Regents of the University of California. All Rights Reserved.
%  =========================================================================================

Model = Model_03;

% plot parameters
% -------------------------------------------------------------------------
WinXr = 0.40;  % X-ratio of plot window to screen size 
WinYr = 0.80;  % Y-ratio of plot window to screen size
% -------------------------------------------------------------------------
NodSF = 1/2;   % relative size for node symbol
% -------------------------------------------------------------------------
% display model
Create_Window (WinXr,WinYr);       % open figure window
PlotOpt.PlNod = 'yes';
PlotOpt.PlBnd = 'yes';
PlotOpt.NodSF = NodSF;
Plot_Model (Model,[],PlotOpt);     % plot model (optional)
PlotOpt.LOfSF = 2.5.*NodSF;
Label_Model (Model,PlotOpt);       % label model (optional)

%% specify initial deformations
Veps = zeros(sum(Model.nq),1);
La = 10;
Lb = 10;
Lc = 5;
% flexural deformations for element a
Veps(2) = -0.0012*La/2;
Veps(3) =  0.0012*La/2;
% flexural deformations for element b
Veps(5) =  0.0006*Lb/2;
Veps(6) = -0.0006*Lb/2;
% flexural deformations for element c
Veps(8) =  0.0008*Lc/2;
Veps(9) = -0.0008*Lc/2;

%% form kinematic matrix A
A  = A_matrix(Model);
% extract submatrix for free dofs
Af = A(:,1:Model.nf);

%% solve for free dof displacements
Uf = Af\Veps;

%% plot deformed shape of structural model
MAGF  = 100;                       % magnification factor for deformed shape
Create_Window (WinXr,WinYr);       % open figure window
PlotOpt.PlNod = 'no';
PlotOpt.PlBnd = 'yes';
Plot_Model(Model,[],PlotOpt);
% to plot element chords use Plot_Model with free dof displacements Uf
PlotOpt.MAGF  = MAGF;
PlotOpt.PlNod = 'no';
Plot_Model(Model,Uf,PlotOpt);
Plot_DeformedStructure (Model,[],Uf,Veps,PlotOpt);