%% CE 221 Nonlinear Structural Analysis, Homework Set 12, Problem 1

%% analysis of 2d section under axial force and bending moment (single reference load)

%% Clear memory and close any open windows
CleanStart
% insert file of units
Units

%% create custom "Model" data structure for element "SectionWrapper"
% geometry consists of a single node
XYZ (1,:) = [ 0 0 ];  
% geometry consists of a single element
CON (1)     = 1 ;
ElemName{1} = 'SectionWrapper';
% create Model without any boundary conditions; both dofs are free
Model = Create_Model(XYZ,CON,[],ElemName);

%% insert section and material properties
Data_RectSection

% copy SecData to ElemData
ElemData{1}.SecName = SecName;
ElemData{1}.SecData = SecData;
% check for missing section properties, insert default values
ElemData{1} = feval(Model.ElemName{1},'chec',1,2,ElemData{1});

%% Loading consists of axial force N and bending moment M with load factor control

%% single reference force vector !!
N = 0.40*Np;
Pe(1,1) = N;
Pe(1,2) = N*d/2;
Loading = Create_Loading (Model,Pe);

%% Nonlinear Analysis
% initialize solution strategy parameters
SolStrat = Initialize_SolStrat;
%% specify incrementation parameters
% specify number of load steps
nostep = 40;

% specify initial load increment and turn load control on (default value is 'no')
SolStrat.IncrStrat.Dlam0  = 4/nostep;
SolStrat.IncrStrat.LFCtrl = 'yes';
SolStrat.IterStrat.LFCtrl = 'yes';

% perform multi-step incremental analysis with supplied solution script
tic
S_MultiStep
toc

% post-processing of results
Post_2dSectionAnalysis