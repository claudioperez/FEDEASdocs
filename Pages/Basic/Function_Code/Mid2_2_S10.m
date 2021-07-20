%% Solution script for Problem #2 of CE121 Midterm Examination #2, Fall Semester 2010

% Department of Civil and Environmental Engineering
% University of California, Berkeley
%
%% clear memory and define global variable MAGF
CleanStart

%% Create model
% specify node coordinates
XYZ(1,:) = [   0     0];  % first node
XYZ(2,:) = [   8     0];  % second node, etc
XYZ(3,:) = [  16     0];  %
XYZ(4,:) = [   0     6];  %

% connectivity array
CON {1} = [  1   2];
CON {2} = [  2   3];
CON {3} = [  1   4];
CON {4} = [  2   4];

% boundary conditions (1 = restrained,  0 = free)
BOUN(1,1:3) = [0 1 0];
BOUN(3,1:3) = [1 1 1];

% specify element type
[ElemName{1:3}] = deal('Lin2dFrm');      % 2d linear frame element
ElemName{4} = 'LinTruss';                %    linear truss element

% create model
Model = Create_SimpleModel(XYZ,CON,BOUN,ElemName);

%% Post-processing functions on Model (optional)
Create_Window (0.80,0.80);    % open figure window
Plot_Model  (Model);          % plot model
Label_Model (Model);          % label model

%%  element properties
% modulus, area, moment of inertia
for el=1:3;
   ElemData{el}.E = 1e3;
   ElemData{el}.A = 1e6;
   ElemData{el}.I = 50;
   ElemData{el}.w = [0;0];
   ElemData{el}.Release = [0;0;0];
end
ElemData{4}.E = 1e3;
ElemData{4}.A = 20;

%% define nodal forces
Pe(2,2) = -10;
Pf  = Create_SimpleLoading (Model,Pe);
Pfw = zeros(Model.nf,1);

%% displacement method analysis
S_DisplMethod

%% post-processing
% plot deformed shape of structural model
MAGF = 150;       % magnification factor for deformed configuration
Create_Window(0.80,0.80);
Plot_Model(Model);
Plot_DeformedStructure (Model,ElemData,Uf);

% plot moment diagram
Create_Window(0.80,0.80);
Plot_Model(Model)
Plot_2dMomntDistr (Model,ElemData,Q,1.5)
Label_2dMoments (Model,Q)