%% CE 221 Nonlinear Structural Analysis, Homework Set 12, Problem 1

%% analysis of 2d section under axial force and bending moment with different load histories

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

%% Loading consists of axial force N and bending moment M with different histories

%% two reference force vectors for two load histories !!
% first load pattern is axial load (LP ID = third column of Pe array)
Pe(1,1,1) = -0.40*Np;
% second load pattern is bending moment
% Pe(1,2,2) = 0.80*Mp;
Pe(1,2,2) =  0.75*Mp;
Loading = Create_Loading (Model,Pe);

%% specify force time history and load incrementation parameters
Deltat = 1;      % pseudo-time step
% -------------------------------------------------------------------------------------------
%% Question 2: axial load first followed by bending moment
% force history for first load pattern: axial force is applied over first Dt and remains constant
Loading.FrcHst(1).Time  = [ 0   1   2 ];
Loading.FrcHst(1).Value = [ 0   1   1 ];
% % force history for second load pattern: moment is applied over second Dt
Loading.FrcHst(2).Time  = [ 0   1   2 ];
Loading.FrcHst(2).Value = [ 0   0   1 ];
% -------------------------------------------------------------------------------------------
% Question 3: load path O-A-B-O
% Loading.FrcHst(1).Time  = [ 0   1   2   12 ];
% Loading.FrcHst(1).Value = [ 0   1   1    0 ];
% Loading.FrcHst(2).Time  = [ 0   1   2   12 ];
% Loading.FrcHst(2).Value = [ 0   0   1    0 ];
% -------------------------------------------------------------------------------------------
%% Question 4: load path O-A-B-C-O
% Loading.FrcHst(1).Time  = [ 0   1   2   17   32  ];
% Loading.FrcHst(1).Value = [ 0   1   1    0    0  ];
% Loading.FrcHst(2).Time  = [ 0   1   2   17   32  ];
% Loading.FrcHst(2).Value = [ 0   0   1    1    0  ];
% -------------------------------------------------------------------------------------------
Tmax = Loading.FrcHst(1).Time(end);

%% Nonlinear Analysis
% initialize solution strategy parameters
SolStrat = Initialize_SolStrat;
% assign pseudo-time step increment to corresponding field in SolStrat
SolStrat.IncrStrat.Deltat = Deltat;
% perform multi-step incremental analysis with supplied solution script
tic
S_MultiStep_wLoadHist
toc

% post-processing of results
Post_2dSectionAnalysis