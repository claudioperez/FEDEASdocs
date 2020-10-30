%% Script for Example 5.1 in Structural Analysis
%  Kinematic solution for statically determinate truss.

%  =========================================================================================
%  FEDEASLab - Release 5.0, July 2018
%  Matlab Finite Elements for Design, Evaluation and Analysis of Structures
%  Professor Filip C. Filippou (filippou@berkeley.edu)
%  Department of Civil and Environmental Engineering, UC Berkeley
%  Copyright(c) 1998-2018. The Regents of the University of California. All Rights Reserved.
%  =========================================================================================

Model = Model_06('iso');

% plot parameters
% -------------------------------------------------------------------------
WinXr = 0.40;  % X-ratio of plot window to screen size 
WinYr = 0.80;  % Y-ratio of plot window to screen size
% -------------------------------------------------------------------------
NodSF = 1/4;   % relative size for node symbol
AxsSF = 1/4;   % relative size of arrows
HngSF = 1/4;   % relative size of releases
HOfSF = 0.5;   % relative offset of releases from element end
% -------------------------------------------------------------------------
Create_Window (WinXr,WinYr);       % open figure window
PlotOpt.PlNod = 'yes';
PlotOpt.PlBnd = 'yes';
PlotOpt.NodSF = NodSF;
Plot_Model (Model,[],PlotOpt);     % plot model (optional)
PlotOpt.LOfSF = 1.8.*NodSF;
PlotOpt.AxsSF = AxsSF;
Label_Model (Model,PlotOpt);        % label model (optional)
PlotOpt.HngSF = HngSF;
PlotOpt.HOfSF = HOfSF;
Plot_Releases(Model,[],[],PlotOpt)

%% specify initial deformations
V0 = zeros(sum(Model.nq),1);
V0(1) = -0.03;
V0(2) =  0.01;
V0(3) =  0.02;
V0(4) = -0.03;
V0(5) =  0.02;

%% form kinematic matrix A
A  = A_matrix(Model);
% extract submatrix for free dofs
Af = A(:,1:Model.nf);

%% solve for free dof displacements
Uf = Af\V0;

%% plot deformed shape of structural model
PlotOpt.MAGF = 30;                % magnification factor for deformed configuration
Create_Window (WinXr,WinYr);      % open figure window
Plot_Model(Model);
PlotOpt.PlRel = 'no';
PlotOpt.NodSF = NodSF;
Plot_DeformedStructure (Model,[],Uf,[],PlotOpt);