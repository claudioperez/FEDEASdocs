%% Solution script for Problem #2 of CE121 Midterm #2, Spring Semester 2011

% Department of Civil and Environmental Engineering
% University of California, Berkeley
%
%% CLEAR MEMORY AND DEFINE GLOBAL VARIABLES
CleanStart

%% Create model
% specify node coordinates
XYZ(1,:) = [   0     0];  % first node
XYZ(2,:) = [   0     6];  % second node, etc
XYZ(3,:) = [   4     6];  %
XYZ(4,:) = [   8     6];  %

% connectivity array
CON {1} = [  1   2];
CON {2} = [  2   3];
CON {3} = [  3   4];
CON {4} = [  1   4];

% boundary conditions (1 = restrained,  0 = free)
BOUN(1,1:3) = [1 1 1];
BOUN(4,1:3) = [0 1 0];

% specify element type
[ElemName{1:3}] = deal('Lin2dFrm'); % 2d linear frame element
ElemName{4} = 'LinTruss';           %    linear truss element

% create model
Model = Create_SimpleModel(XYZ,CON,BOUN,ElemName);

%% Post-processing functions on Model (optional)
Create_Window (0.80,0.80);         % open figure window
Plot_Model  (Model);               % plot model (optional)
Label_Model (Model);               % label model (optional)

%%  Define element properties
for el=1:3;
   ElemData{el}.E = 1e3;
   ElemData{el}.A = 1e6;
   ElemData{el}.I = 20;
end
ElemData{4}.E = 1e3;
ElemData{4}.A = 10;

ElemData{3}.w  = [0;-10];
ElemData{4}.q0 = 20;

%% define loading
Pe(2,1) =  50;
Pf  = Create_NodalForces (Model,Pe);
clear Pe;
Pe(3,2) = 20;
Pfw = Create_NodalForces (Model,Pe);

%% use displacement method of analysis
S_DisplMethod

% determine support reactions R
% add the effect of distributed element loading
Pwd = zeros(Model.nt,1);
Pwd (Model.DOF(4,2)) = 20;
% complete force vector P
P   = A'*Q + Pwd;
R   = P(Model.nf+1:end);

%% post-processing
% plot deformed shape of structural model
MAGF = 50;       % magnification factor for deformed configuration
Create_Window(0.80,0.80);
Plot_Model(Model);
Plot_DeformedStructure (Model,ElemData,Uf);

% plot moment diagram
Create_Window(0.80,0.80);
Plot_Model(Model);
Plot_2dMomntDistr (Model,ElemData,Q,2);
Label_2dMoments (Model,Q);