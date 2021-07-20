%% Script for plastic analysis of one story portal frame in Lecture 14 of CE220 notes  

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

%% define plastic flexural capacity in column vector
Qpl = [ 1e5 150 150 1e5 120 120 1e5 120 120 1e5 150 150]';
%% form kinematic matrix Af
A  = A_matrix(Model);
Af = A(:,1:Model.nf);
%% define loading
Pe(2,1) =  30;
Pe(3,2) = -50;
Pref    = Create_NodalForces (Model,Pe);
%% call function for upper bound plastic analysis in FEDEASLab
[lambdac,DUf,DVhp] = PlasticAnalysis_wUBT (Af,Qpl,Pref);
%% plot the collapse mode
Create_Window (0.80,0.80);
Plot_Model (Model)
PlotOpt.MAGF = 50;
Plot_Model (Model,DUf,PlotOpt)
Plot_PlasticHinges (Model,[],DUf,DVhp,PlotOpt)
