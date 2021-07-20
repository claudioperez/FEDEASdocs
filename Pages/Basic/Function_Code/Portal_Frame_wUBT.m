%% Script for 
%  plastic analysis of one story portal frame

%  =========================================================================================
%  FEDEASLab - Release 3.2, July 2012
%  Matlab Finite Elements for Design, Evaluation and Analysis of Structures
%  Professor Filip C. Filippou (filippou@ce.berkeley.edu)
%  Department of Civil and Environmental Engineering, UC Berkeley
%  Copyright(c) 1998-2012. The Regents of the University of California. All Rights Reserved.
%  =========================================================================================

%% clear memory and define global variables
CleanStart;

%% define structural model (coordinates, connectivity, boundary conditions, element types)
XYZ(1,:) = [  0   0];  % first node
XYZ(2,:) = [  0   5];  % second node, etc
XYZ(3,:) = [  4   5];  %
XYZ(4,:) = [  8   5];  % 
XYZ(5,:) = [  8   0];  % 
  
% element connectivity array
CON(1,:) = [  1   2];
CON(2,:) = [  2   3];
CON(3,:) = [  3   4];
CON(4,:) = [  4   5];

% boundary conditions (1 = restrained,  0 = free) (specify only restrained dof's)
BOUN(1,:) = [ 1 1 1];
BOUN(5,:) = [ 1 1 1];

% specify element type
ne = length(CON);                       % number of elements
[ElemName{1:ne}] = deal('2dFrm');       % 2d frame element

%% Model creation
Model = Create_SimpleModel (XYZ,CON,BOUN,ElemName);
% plot and label model for checking (optional)
Create_Window (0.80,0.80);         % open figure window
Plot_Model  (Model);               % plot model
Label_Model (Model);               % label model

%% static matrix Af for portal frame
Af = [1/5   1/5    0     0     0     0   1/5   1/5;
       0     1     1     0     0     0    0     0 ;
       0     0   -1/4  -1/4   1/4   1/4   0     0 ;
       0     0     0     1     1     0    0     0 ;
       0     0     0     0     0     1    1     0  ]';   
% specify plastic capacities in vector Qpl
Qpl  = [150 150 120 120 120 120 150 150]';
% specify reference load in vector Pref
Pref = [30 0 -50 0  0]';
%% call function for upper bound plastic analysis in FEDEASLab
[lambdac,DUf,DVhp] = PlasticAnalysis_wUBT (Af,Qpl,Pref);
diary on
disp('the collapse mechanism displacement rates are')
disp(DUf/DUf(1))
disp('the plastic deformation rates are')
disp(DVhp/DUf(1))
diary off

% expand displacements and deformations for plotting
Model.InextEList = 1:ne;
ied    = D_index(Model);
A      = A_matrix(Model);
Af     = A(:,1:Model.nf);
ic     = setdiff(1:size(A,1),[ied{:}]);
Ac     = Ac_matrix(Af,ic,[Model.DOF(2,1),Model.DOF(3,2)]);
Aftild = Af*Ac;

%% plot the collapse mode
Create_Window (0.80,0.80);
Plot_Model (Model);
PlotOpt.MAGF = 50;
Plot_Model (Model,Ac*DUf,PlotOpt);
Plot_PlasticHinges (Model,[],Ac*DUf,DVhp,PlotOpt);
print -painters -dpdf -r600 Ex12_2F1