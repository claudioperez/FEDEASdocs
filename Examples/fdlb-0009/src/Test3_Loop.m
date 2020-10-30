%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%TEST 3 - CreateMesh: Model with loop, uniform offset.
% CreateMesh implemented in lines 41-42
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

CleanStart

% Node Definitions
XYZ(1,:) = [0.0   0.0];
XYZ(2,:) = [0.0   6.0];
XYZ(3,:) = [8.0   6.0];
XYZ(4,:) = [16.   6.0];
XYZ(5,:) = [8.0   12.];
XYZ(6,:) = [0.0   12.];
XYZ(7,:) = [8.0   0.0];

% Connections
CON(1,:) = [1   2];
CON(2,:) = [2   3];
CON(3,:) = [3   4];
CON(4,:) = [3   5];
CON(5,:) = [5   6];
CON(6,:) = [7   3]; % high-to-low node num test
CON(7,:) = [2   6];

       
% Boundary Conditions
BOUN(1,:) = [1 1 1];
BOUN(4,:) = [0 1 1];
BOUN(7,:) = [1 1 1];

% Specify element type
ElemName{1} = 'Lin2dFrm';
ElemName{2} = 'Lin2dFrm';
ElemName{3} = 'Lin2dFrm';
ElemName{4} = 'Lin2dFrm';
ElemName{5} = 'Lin2dFrm';
ElemName{6} = 'Lin2dFrm';
ElemName{7} = 'Lin2dFrm';

% Create model
OFF = 1.5;
[XYZ,CON,ElemName] = CreateMesh(XYZ,CON,ElemName,OFF);
Model = Create_SimpleModel (XYZ,CON,BOUN,ElemName);

% Element properties

 ElemData = cell(Model.ne,1);

% Element: a
ElemData{1}.A = 1.0;
ElemData{1}.E = 1.0;
ElemData{1}.I = 1.0;
ElemData{1}.Release = [0;0;0];

% Element: b
ElemData{2}.A = 1.0;
ElemData{2}.E = 1.0;
ElemData{2}.I = 1.0;
ElemData{2}.Release = [0;0;0];

% Element: c
ElemData{3}.A = 1.0;
ElemData{3}.E = 1.0;
ElemData{3}.I = 1.0;
ElemData{3}.Release = [0;0;1];

% Element: d
ElemData{4}.A = 1.0;
ElemData{4}.E = 1.0;
ElemData{4}.I = 1.0;
ElemData{4}.Release = [0;0;0];

% Element: e
ElemData{5}.A = 1.0;
ElemData{5}.E = 1.0;
ElemData{5}.I = 1.0;
ElemData{5}.Release = [0;0;0];


%% Plot
% display model
% plot parameters
% -------------------------------------------------------------------------
WinXr = 0.40;   % X-ratio of plot window to screen size 
WinYr = 0.80;   % Y-ratio of plot window to screen size
% -------------------------------------------------------------------------
NodSF = 3/4;    % relative size for node symbol
AxsSF = 3/4;    % relative size of arrows
HngSF = 3/4;    % relative size of releases
HOfSF = 1;      % relative size of hinge offset from end
% -------------------------------------------------------------------------
Create_Window (WinXr,WinYr);       % open figure window
PlotOpt.PlNod = 'yes';
PlotOpt.PlBnd = 'yes';
PlotOpt.NodSF = NodSF;
Plot_Model (Model,[],PlotOpt);
PlotOpt.AxsSF = AxsSF;
PlotOpt.LOfSF = 1.6.*NodSF;
Label_Model (Model,PlotOpt);

