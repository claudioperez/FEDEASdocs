%% Script for Example 12.2 in First Course on Matrix Structural Analysis
%  plastic analysis of column-girder assembly

%% clear memory and define global variables
CleanStart

%% define structural model (coordinates, connectivity, boundary conditions, element types)
XYZ(1,:) = [  0   0];  % first node
XYZ(2,:) = [  0   6];  % second node, etc
XYZ(3,:) = [  4   6];  %
XYZ(4,:) = [  8   6];  % 
  
% element connectivity array
CON(1,:) = [  1   2];
CON(2,:) = [  2   3];
CON(3,:) = [  3   4];

% boundary conditions (1 = restrained,  0 = free) (specify only restrained dof's)
BOUN(1,:) = [ 1 1 1];
BOUN(4,:) = [ 0 1 0];

% specify element type
ne = length(CON);                       % number of elements
[ElemName{1:ne}] = deal('2dFrm');       % 2d frame element

% create Model
Model = Create_SimpleModel (XYZ,CON,BOUN,ElemName);
% plot and label model for checking (optional)
Create_Window (0.50,0.80);         % open figure window
Plot_Model  (Model);               % plot model
Label_Model (Model);               % label model

% static matrix Bf for column-girder (Ex 12.2)
Bf = [1/6  1/6    0     0     0 ;
      0     1     1     0     0 ;
      0     0   -1/4  -1/4   1/4;
      0     0     0     1     1 ];  
% specify plastic capacities in vector Qpl
Qpl  = [160 160 120 120 120]';
% specify reference load in vector Pref
Pref = [20 0 -20 0]';

[lambdac,Qc]  = PlasticAnalysis_wLBT (Bf,Qpl,Pref);
disp('the basic forces Qc at collapse are')
disp(Qc')

Model.Qmis{1} = 1;
Model.Qmis{2} = 1;
Model.Qmis{3} = [1 3];

% open new window
Create_Window(0.50,0.80);
Plot_Model (Model);
Plot_2dMomntDistr (Model,[],Qc,[],0.4);
PlotOpt.HngSF = 0.6;
Plot_PlasticHinges (Model,Qpl,[],Qc,PlotOpt)
Label_2dMoments (Model,Qc)
print -painters -dpdf -r600 Ex12_2F1

return

%% braced frame

CON(4,:)   = [  1   4];
ElemName{4} = 'Truss';                  % 2d truss element
% create Model
Model = Create_SimpleModel (XYZ,CON,BOUN,ElemName);
% plot and label model for checking (optional)
Create_Window (0.80,0.80);         % open figure window
Plot_Model  (Model);               % plot model
Label_Model (Model);               % label model

% structure equilibrium matrix without trivial and w/o axial forces in a-c 
Bf=[1/6  1/6   0     0    0   0.8 ;
     0    1    1     0    0    0  ;
     0    0  -1/4  -1/4  1/4   0  ;
     0    0    0     1    1    0  ];
  
% specify plastic capacities in vector Qpl
Qpl = [160 160 120 120 120 50]';

Pref = [20 0 -20 0]';

[lambdac Qc]  = PlasticAnalysis_wLBT (Bf,Qpl,Pref);

Model.Qmis{1} = 1;
Model.Qmis{2} = 1;
Model.Qmis{3} = [1 3];
% open new window and plot moment diagram and plastic hinge locations; label moment values
Create_Window(0.80,0.80);
Plot_Model (Model);
Plot_2dMomntDistr (Model,[],Qc,[],5);
Plot_PlasticHinges (Model,Qpl,Qc)
Label_2dMoments (Model,Qc)