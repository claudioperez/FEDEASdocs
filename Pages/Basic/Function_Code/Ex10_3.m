%% Script for Example 10.3 in First Course on Matrix Structural Analysis
%  displacement method of portal frame

%  =========================================================================================
%  FEDEASLab - Release 3.2, July 2012
%  Matlab Finite Elements for Design, Evaluation and Analysis of Structures
%  Professor Filip C. Filippou (filippou@ce.berkeley.edu)
%  Department of Civil and Environmental Engineering, UC Berkeley
%  Copyright(c) 1998-2012. The Regents of the University of California. All Rights Reserved.
%  =========================================================================================

%% clear workspace memory and initialize global variables
CleanStart

%% define structural model (coordinates, connectivity, boundary conditions, element types)
% specify node coordinates (could only specify non-zero terms)
XYZ(1,:) = [  0    0];  % first node
XYZ(2,:) = [  0    8];  % second node, etc
XYZ(3,:) = [ 10    8];  %
XYZ(4,:) = [ 20    8];
XYZ(5,:) = [ 20   -2];

% connectivity array
CON(1,:) = [  1   2];
CON(2,:) = [  2   3];
CON(3,:) = [  3   4];
CON(4,:) = [  4   5];

% boundary conditions (1 = restrained,  0 = free)
BOUN(1,:) = [1 1 1];
BOUN(5,:) = [1 1 1];

% specify element type
[ElemName{1:4}] = deal('Lin2dFrm');    % linear 2d frame element

%% create Model
Model = Create_SimpleModel (XYZ,CON,BOUN,ElemName);
Create_Window(0.50,0.80);
Plot_Model(Model);
Label_Model(Model);

% specify element properties
for el=1:Model.ne
   ElemData{el}.E = 1000;
   ElemData{el}.A = 1e6;
   ElemData{el}.I = 60;
end
% insert release at base of element a
ElemData{1}.Release = [0;1;0];

% Load case: uniform load in elements a and b
ElemData{1}.w  = [0; -5];
ElemData{2}.w  = [0;-10];
Pw  = Create_PwForces(Model,ElemData);
Pwf = Pw(1:Model.nf);
% displacement method of analysis
S_DisplMethod
% bending moment distribution
Create_Window(0.50,0.80);
Plot_Model (Model);
Plot_2dMomntDistr (Model,ElemData,Q,[],0.5);
Label_2dMoments(Model,Q)
print -painters -dpdf -r600 Ex10_3F1

% plot deformed shape
Create_Window(0.50,0.80);
PlotOpt.MAGF = 30;       % magnification factor
Plot_Model(Model);       % original configuration
% plot element chords in deformed geometry
Plot_Model (Model,Uf,PlotOpt);
% plot deformed shape
Plot_DeformedStructure(Model,ElemData,Uf,Ve,PlotOpt);
print -painters -dpdf -r600 Ex10_3F2

%% 2. Load case: thermal deformation of elements a and b
% no nodal forces, clear earlier values
clear Pwf
% initial element deformations
ElemData{1}.e0 = [0;0.002];
ElemData{2}.e0 = [0;0.002];
% clear distributed load from ElemData
ElemData{1}.w  = [0; 0];
ElemData{2}.w  = [0; 0];

% plot and label initial deformations
Create_Window (0.50,0.80);       
PlotOpt.FrcSF = 5;
PlotOpt.TipSF = 1.25;
PlotOpt.PlBnd = 'yes';
PlotOpt.NodSF = 0.60;
PlotOpt.FntSF = 3;
Plot_ElemLoading (Model,ElemData,PlotOpt);
Plot_Model  (Model,[],PlotOpt);
Plot_Releases (Model,ElemData,[],PlotOpt);
print -painters -dpdf -r600 Ex10_3F6

% displacement method of analysis
S_DisplMethod
% bending moment distribution
Create_Window(0.50,0.80);
Plot_Model (Model);
Plot_2dMomntDistr (Model,ElemData,Q,[],0.6);
Label_2dMoments(Model,Q)
print -painters -dpdf -r600 Ex10_3F3
% plot curvature distribution
Create_Window(0.50,0.80);
Plot_Model(Model);
Plot_2dCurvDistr(Model,ElemData,Q,[],0.6);
print -painters -dpdf -r600 Ex10_3F4
% plot deformed shape
Create_Window(0.50,0.80);
PlotOpt.MAGF = 50;               
Plot_Model(Model);       
% plot element chords in deformed geometry
Plot_Model (Model,Uf,PlotOpt);
% plot deformed shape
Plot_DeformedStructure(Model,ElemData,Uf,[],PlotOpt);
print -painters -dpdf -r600 Ex10_3F5