%% Script for Example 5.4 in Structural Analysis
%  Kinematic solution for indeterminate plane truss with `NOS=1`

%  =========================================================================================
%  FEDEASLab - Release 5.0, July 2018
%  Matlab Finite Elements for Design, Evaluation and Analysis of Structures
%  Professor Filip C. Filippou (filippou@berkeley.edu)
%  Department of Civil and Environmental Engineering, UC Berkeley
%  Copyright(c) 1998-2018. The Regents of the University of California. All Rights Reserved.
%  =========================================================================================

%% clear memory and define global variables
CleanStart

Model = Model_06('hyp');

% plot parameters
% -------------------------------------------------------------------------
WinXr = 0.40;   % X-ratio of plot window to screen size 
WinYr = 0.80;   % Y-ratio of plot window to screen size
% -------------------------------------------------------------------------
NodSF = 1/3;   % relative size for node symbol
AxsSF = 0.30;  % relative size of arrows
% -------------------------------------------------------------------------
% plot and label model for checking (optional)
Create_Window (WinXr,WinYr);       % open figure window
PlotOpt.PlNod = 'yes';
PlotOpt.PlBnd = 'yes';
PlotOpt.NodSF = NodSF;
Plot_Model  (Model,[],PlotOpt);    % plot model
PlotOpt.AxsSF = AxsSF;
PlotOpt.LOfSF = 1.8.*NodSF;
Label_Model (Model,PlotOpt);       % label model

clearvars PlotOpt

%% form kinematic matrix A
A  = A_matrix (Model);
% extract submatrix for free dofs Af
Af = A(:,1:Model.nf);

% specify the element deformations V
V  = [0.02;0.05;-0.02;0.05;0.02;0.02];

% extract nf rows of kinematic matrix
Ai = Af(1:5,:);
% extract corresponding deformations
Vi = V(1:5);

%% solution for free global dof displacements
Uf = Ai\Vi;
% display result
format compact
disp('the free global dof displacements are');
disp(Uf);

%% determine fictitious release deformation at redundant basic force
Vh = Af*Uf - V;
disp(['the fictitious release deformation is ' num2str(Vh(6))]);

%% plot deformed shape of structural model
MAGF  = 15;                        % magnification factor for deformed shape
Create_Window (WinXr,WinYr);       % open figure window
% plot original geometry
Plot_Model (Model);
PlotOpt.MAGF  = MAGF;
PlotOpt.LnStl = '-';
PlotOpt.LnClr = 'r';
PlotOpt.NodSF = NodSF;
PlotOpt.PlBnd = 'yes';
Plot_Model (Model,Uf,PlotOpt);