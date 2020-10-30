%% CE 221 Nonlinear Structural Analysis, Homework Set 12, Problem 4

%% Nonlinear Time History Analysis
%  under constant gravity loads

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

%% specify lumped mass for 4, 8, 12 or 20-story frames (uniform distribution)
Mass_NISTFrame

%% Applied loading divided into vertical and horizontal load patterns

%% Loading
% 1a. specify gravity loading
GravLoad_NISTFrame

%% Load Application Sequence

% initial solution strategy parameters
SolStrat = Initialize_SolStrat;

%% 1. Apply gravity loads in single load step
Loading = GravLoading;
SolStrat.IncrStrat.Dlam0  = 1;
SolStrat.IncrStrat.LFCtrl = 'no';
S_InitialStep

%% 2. Set up damping matrix 
% form linear stiffness matrix (it is assumed that gravity loading does not cause yielding!)
State = Structure ('stif',Model,ElemData,State);
% free dof stifness matrix
Kf = State.Kf;
Ml = Model.M;

% solve dynamic eigenvalue problem with FEDEASLab function EigenMode
[omega,Ueig] = EigenMode (Kf,Ml,3);
% echo eigenmode periods
disp('The three lowest eigenmode periods are');
T = 2*pi./omega;
disp(T(1:3));

% set up Rayleigh damping matrix by specify damping ratios zeta for specific modes
zeta = [0.02 0.02];  % damping ratios
mode  = [1 3];       % modes for damping ratio
State = Add_Damping2State ('Caughey',Model,State,zeta,mode);

%% 3. Read base acceleration history and asssign it to field AccHst in Loading 
Loading = Create_Loading(Model);
BaseAcceleration

tic
% Tmax = Loading.AccHst.Time(end);
Tmax = 30;
% change Tmax to run only the first Tmax of the very long record
maxiter = 10;
SolStrat.TimeStrat.Deltat = 0.02;
% multi-step transient analysis
S_Transient_MultiStep
toc

%% post-processing
Post_TimeHistAnalysis