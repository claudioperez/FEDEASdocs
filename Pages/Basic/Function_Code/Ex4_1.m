%% Script for Example 4.1 in First Course on Matrix Structural Analysis
%  static solution for determinate plane truss

%  =========================================================================================
%  FEDEASLab - Release 3.2, July 2012
%  Matlab Finite Elements for Design, Evaluation and Analysis of Structures
%  Professor Filip C. Filippou (filippou@ce.berkeley.edu)
%  Department of Civil and Environmental Engineering, UC Berkeley
%  Copyright(c) 1998-2012. The Regents of the University of California. All Rights Reserved.
%  =========================================================================================

%% the following example shows the determination of the truss response first without and then
%  with the use of FEDEASLab functions

%% perform each step with Matlab functions
% clear memory
clearvars

% specify static (equilibrium) matrix Bf
Bf = [1  -1    0    0     0;
      0   0    0   -1     0;
      0   1    0    0    0.8;
      0   0   0.8   0   -0.8;
      0   0   0.6   1    0.6];
   
% specify applied force vector
Pf = [ 0; -5; 0; 10; 0];

% solve for basic forces Q
Q  = Bf\Pf;

% display result
format short
disp('the basic forces are');
disp(Q);

%% use FEDEASLab functions
% clear memory; close open windows
CleanStart
% define model geometry
XYZ(1,:) = [  0   0];
XYZ(2,:) = [  8   0];
XYZ(3,:) = [ 16   0];
XYZ(4,:) = [  8   6];  
% element connectivity array
CON(1,:) = [  1   2];
CON(2,:) = [  2   3];
CON(3,:) = [  1   4];
CON(4,:) = [  2   4];
CON(5,:) = [  3   4];
% boundary conditions
BOUN(1,:) = [ 1 1];
BOUN(3,:) = [ 0 1];
% specify element type
ne = size(CON,1);                      
[ElemName{1:ne}] = deal('Truss');

%% create Model
Model = Create_SimpleModel (XYZ,CON,BOUN,ElemName);

% plot and label model for checking (optional)
Create_Window (0.50,0.80);
Plot_Model  (Model);               
Label_Model (Model);               
set(gca,'LooseInset',get(gca,'TightInset')) 
print -painters -dpdf -r600 Ex4_1F2a

Create_Window (0.50,0.80);                
PlotOpt.PlNod = 'yes';
PlotOpt.PlBnd = 'yes';
PlotOpt.NodSF = 0.6;
Plot_Model  (Model,[],PlotOpt);           
LblOpt.AxsSF = 0.5;
LblOpt.FntSF = 2;
LblOpt.LOfSF = 1.3;
Label_Model (Model,LblOpt);               
set(gca,'LooseInset',get(gca,'TightInset')) 
print -painters -dpdf -r600 Ex4_1F2b

%% form static (equilibrium) matrix B
B  = B_matrix(Model);
% extract submatrix for free dofs
Bf = B(1:Model.nf,:);

%% specify loading
Pe(2,2) = -5; % node 2, direction Y
Pe(4,1) = 10; % node 4, direction X

% generate applied force vector Pf
Pf = Create_NodalForces (Model,Pe);

%% solution for basic forces and support reactions
% solve for basic forces and display the result
Q  = Bf\Pf;
disp('the basic forces are');
disp(Q);

% determine support reactions: the product B*Q delivers all forces at the global dofs
% the upper 5 should be equal to the applied forces, the lower 3 are the support reactions
disp('B*Q gives');
disp(B*Q);

%% post-processing of results
% plot axial force distribution
ScaleN = 1/3;    
NDigt  = 2;
Create_Window (WinXr,WinYr);       
Plot_Model(Model);
Plot_AxialForces(Model,Q,[],ScaleN);
Label_AxialForces(Model,Q,[],NDigt);
set(gca,'LooseInset',get(gca,'TightInset')) 
print -painters -dpdf -r600 Ex4_1F1