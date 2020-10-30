%% Cyclic Load Analysis of Cantilever Column with Fiber Beam-Column Element

%% Clear memory, close any open windows and insert units
CleanStart
Units

%% Specify length of cantilever column
L = 6*ft;
% specify node coordinates
XYZ(1,:) = [ 0   0];  % first node
XYZ(2,:) = [ 0   L];  % second node

% connectivity array
CON(1,:) = [ 1  2];

% boundary conditions
BOUN(1,:) = [1 1 1];
BOUN(2,:) = [1 0 0];

%% Element name: 2d nonlinear frame element with concentrated inelasticity
ElemName{1} = 'Dinel2dFrm_EBwFF';

% generate Model data structure
Model = Create_Model (XYZ,CON,BOUN,ElemName);

%% Element properties
E  = 29000*ksi;
fy = 60*ksi;
SecProp = AISC_Section('W14x426');
A  = SecProp.A *in^2;
I  = SecProp.Ix*in^4;
Z  = SecProp.Zx*in^3;

d  = SecProp.d *in;
bf = SecProp.bf*in;
tf = SecProp.tf*in;
tw = SecProp.tw*in;

Np = A*fy;
Mp = Z*fy;

% specify fiber section properties
ElemData{1}.SecName = 'HomoWFSecw1dMat';     % homogeneous WF section
nft = 4;                 % no of layers in flange
nwl = 8;                 % no of layers in web
SIntTyp = 'Midpoint';    % section integration rule

% specify fiber material properties
MatName = 'InelLPwLH1dMat';
MatData.E  = E;         
MatData.fy = fy;
MatData.Hk = E/1e8;
% MatData.Hk = E/50;

% number of sections (IPs) along element
nIP = 4;
for sec = 1:nIP
  SecData{sec}.ndm = 2;
  SecData{sec}.d   = d;    % depth
  SecData{sec}.dw  = d;    % web depth
  SecData{sec}.bf  = bf;   % flange width
  SecData{sec}.tf  = tf;   % flange thickness
  SecData{sec}.tw  = tw;   % web thickness
  SecData{sec}.nft = nft;  % no of layers in flange
  SecData{sec}.nwl = nwl;  % no of layers in web
  SecData{sec}.IntTyp = SIntTyp;
  % material data
  SecData{sec}.MatName = MatName;
  SecData{sec}.MatData = MatData;
end
% specify distributed element properties
ElemData{1}.nIP = nIP;
ElemData{1}.IntTyp  = 'Lobatto';      % element integration rule
ElemData{1}.SecData = SecData;

%% Default values for missing element properties
ElemData = Structure ('chec',Model,ElemData);

WinXr = 0.40;
WinYr = 0.80;
Create_Window(WinXr,WinYr);
Plot_SectionGeometry (ElemData{1}.SecData{1},[]);

%% 1. vertical force (constant)
% specify nodal forces
Pe(2,2) = -0.20*Np;   
Loading = Create_Loading (Model,Pe);

% initial solution strategy parameters
SolStrat = Initialize_SolStrat;
% single load step for the application of gravity load with Dlam0 = 1
SolStrat.IncrStrat.Dlam0  = 1;
SolStrat.IncrStrat.LFCtrl = 'no';
S_InitialStep

clear Pe

%% 2. Cyclic axial force and horizontal displacement
% specify nodal forces and displacements
Pe(2,2) = -0.30*Np;
Ue(2,1) = 0.005*L;   
Loading = Create_Loading (Model,Pe,Ue);

% specify time step and time at each reversal (no_step per reversal = T_Rev/Dt)
Deltat = 0.01;
T_Rev  = 1; 
% specify force/displacement reversal values 
RevVal = [ 1 -1 1 -1 ];
no_Rev = length(RevVal);          % no of load reversals
Loading.FrcHst.Value = [0 RevVal];
Loading.FrcHst.Time  = [0 (1:no_Rev)*T_Rev];
RevVal = [ 1 -2 3 -4 ];
Loading.DspHst.Value = [0 RevVal];
Loading.DspHst.Time = [0 (1:no_Rev)*T_Rev];
% time at end of analysis
Tmax = no_Rev*T_Rev;

%% Cyclic analysis for imposed force/displacement with time history
tic
SolStrat.IncrStrat.Deltat = Deltat;
S_MultiStep_wLoadHist
toc

%% post-processing
Post_Hw12P2