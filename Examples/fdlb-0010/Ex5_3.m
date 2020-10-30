%% Script for Example 5.3 in Structural Analysis
%  Kinematic solution for statically determinate three hinge portal frame.

%  =========================================================================================
%  FEDEASLab - Release 5.0, July 2018
%  Matlab Finite Elements for Design, Evaluation and Analysis of Structures
%  Professor Filip C. Filippou (filippou@berkeley.edu)
%  Department of Civil and Environmental Engineering, UC Berkeley
%  Copyright(c) 1998-2018. The Regents of the University of California. All Rights Reserved.
%  =========================================================================================

%% clear memory and define global variables
CleanStart

Model = Model_05;

% plot parameters
% -------------------------------------------------------------------------
WinXr = 0.40;   % X-ratio of plot window to screen size 
WinYr = 0.80;   % Y-ratio of plot window to screen size
% -------------------------------------------------------------------------
NodSF = 0.60;   % relative size for node symbol
HngSF = 0.6;    % relative size of releases
HOfSF = 1;      % relative offset of releases from element end
% -------------------------------------------------------------------------
% display model
Create_Window (WinXr,WinYr);       % open figure window
PlotOpt.PlNod = 'yes';
PlotOpt.PlBnd = 'yes';
PlotOpt.NodSF = NodSF;
Plot_Model  (Model,[],PlotOpt);    % plot model
PlotOpt.AxsSF = 0.5;
Label_Model (Model,PlotOpt);       % label model (optional)

%% specify element deformations
Veps = zeros(sum(Model.nq),1);
L    = zeros(Model.ne,1);
for el=1:Model.ne
   [xyz] = Localize (Model,el);
   L(el) = ElmLenOr (xyz);
end
Veps(2:3) = -0.00072.*[-1;1].*L(1)/2;
Veps(5:6) = -0.0006 .*[-1;1].*L(2)/2;
Veps(8:9) = -0.0006 .*[-1;1].*L(3)/2;
% ih = index of release, ic = index for continuous element deformations
ih = [2 8 12];  
ic = setdiff(1:sum(Model.nq),ih);

%% form kinematic matrix A
A  = A_matrix(Model);
% extract submatrix for free dofs and continuous element deformations
Af = A(ic,1:Model.nf);

%% solve for free dof displacements
Uf = Af\Veps(ic);

% determine release deformation(s)
format short e
Vh = A(:,1:Model.nf)*Uf-Veps;
disp('the release deformations are')
disp(Vh(ih))

%% plot deformed shape of structural model
MAGF  = 100;                       % magnification factor for deformed shape
Create_Window (WinXr,WinYr);       % open figure window
PlotOpt.PlNod = 'no';
PlotOpt.PlBnd = 'yes';
Plot_Model(Model,[],PlotOpt);
% plot element chords in deformed configuration
PlotOpt.MAGF  = MAGF;
Plot_Model(Model,Uf,PlotOpt);
PlotOpt.HngSF = HngSF;
PlotOpt.HOfSF = HOfSF;
PlotOpt.NodSF = NodSF;
ElemData{1}.Release = [0;1;0];
ElemData{3}.Release = [0;1;0];
ElemData{4}.Release = [0;0;1];
Plot_DeformedStructure (Model,ElemData,Uf,Veps,PlotOpt);