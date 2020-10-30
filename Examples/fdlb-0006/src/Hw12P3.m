%% CE 221 Nonlinear Structural Analysis, Homework Set 12, Problem 3

%% Incremental PushOver Analysis
%  with load factor control allowing for strength loss
%  under constant gravity loads and increasing lateral forces

%% Clear memory and close any open windows
CleanStart
% insert file of units
Units

%% define structural model geometry for 8-story frame
Model_8S3BFrame

%% specify element sizes for 8-story frame
ElemSize_8S3BFrame

%% Assign Element Properties
ColmnElemName = 'Inel2dFrm_wOneComp';     % column element type
% ColmnElemName = 'Inel2dFrm_wLHNMYS';      % column element type
GirdrElemName = 'Inel2dFrm_wOneComp';     % girder element type
SimpleElemProp_NISTFrame

% specify nonlinear geometry option for columns only
Geom = 'linear';
for el = [Frame.CIndx{:}]
  ElemData{el}.Geom = Geom;     % linear, PDelta, or corotational
end

%% Applied loading divided into vertical and horizontal load patterns

%% Loading
% 1a. specify gravity loading
GravLoad_NISTFrame

% 2. specify lateral loading
LatLoad_NISTFrame

%% Load Application Sequence

% initial solution strategy parameters
SolStrat = Initialize_SolStrat;

%% Apply gravity loads in single load step
Loading = GravLoading;
SolStrat.IncrStrat.Dlam0  = 1;
SolStrat.IncrStrat.LFCtrl = 'no';
S_InitialStep

%% Apply lateral loads in multi-step strategy
Loading = LatLoading;

%% Incremental analysis for horizontal force pattern (load control is on)
% incremental strategy parameters
% Initialize load factor
Dlam0 = 0.10;

% specify number of steps
nostep  = 150;
% specify load factor control
LFCtrl = 'yes';

%% Incremental analysis for horizontal force pattern
% (gravity forces are left on by not initializing State!)
SolStrat.IncrStrat.StifUpdt = 'yes';
SolStrat.IncrStrat.Dlam0    = Dlam0;
SolStrat.IncrStrat.LFCtrl   = LFCtrl;
SolStrat.IterStrat.LFCtrl   = LFCtrl;

tic
S_MultiStep
toc

%% POST-PROCESSING
Post_PushOverAnalysis