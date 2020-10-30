%% Script for Example 4.9 in Structural Analysis
%  Static solution for indeterminate plane truss with `NOS=1`.

%  =========================================================================================
%  FEDEASLab - Release 5.0, July 2018
%  Matlab Finite Elements for Design, Evaluation and Analysis of Structures
%  Professor Filip C. Filippou (filippou@berkeley.edu)
%  Department of Civil and Environmental Engineering, UC Berkeley
%  Copyright(c) 1998-2018. The Regents of the University of California. All Rights Reserved.
%  =========================================================================================
%
%% specify each step of the process with Matlab functions
% clear memory
clearvars

% structure equilibrium matrix for free dofs (consult equation 2.52) 
Bf=[ 1    0    0    0    0.8   0 ;
     0    0    0   -1   -0.8   0 ;
     0    1    0    0    0.6   0 ;
     0    0    0    1    0    0.8;
     0    0    1    0    0    0.6];

% select the redundant basic force Qx (index ix)
ix=6;

% define basic forces of primary structure Qi (index ip)
ip=1:5;

% extract matrix Bi (static matrix of primary structure)
Bi=Bf(:,ip);

% check if primary structure is stable
disp(['the rank of the equilibrium matrix of the primary structure is ' num2str(rank(Bi))])

% define loading
Pf=[0 ; 0 ; 0 ; 15 ; 0];

% determine basic element forces of primary structure under the applied loading
Qp(ip,1) = Bi\Pf;
Qp(ix,1) = 0;

% extract matrix Bx
Bx=Bf(:,ix);

% determine force influence matrix for redundant basic forces
% set up only column 
Bbarx(ip,1) = -Bi\Bx(:,1);
Bbarx(ix,1) = 1;

format compact
% display Qp, Bxbar
Qp
Bbarx

%% use FEDEASLab functions

% after defining equilibrium matrix Bf use it as first argument to the function BiBxbar_matrix
% to obtain the force influence matrices of the primary structure for the applied forces and redundants
[Bibar,Bbarx] = BbariBbarx_matrix (Bf);
Qp = Bibar*Pf
Bbarx

%% use FEDEASLab functions to also set up Bf matrix and Pf vector

%% clear workspace memory and initialize global variables
CleanStart

%% define structural model (coordinates, connectivity, boundary conditions, element types)
% specify node coordinates
XYZ(1,:) = [  0   0];  % first node
XYZ(2,:) = [  8   0];  % second node, etc
XYZ(3,:) = [  0   6];  %
XYZ(4,:) = [  8   6];  % 
   
% connectivity array
CON(1,:) = [  1   2];
CON(2,:) = [  1   3];
CON(3,:) = [  2   4];
CON(4,:) = [  3   4];
CON(5,:) = [  2   3];
CON(6,:) = [  1   4];

% boundary conditions (1 = restrained,  0 = free) (specify only restrained dof's)
BOUN(1,:) = [ 1 1];
BOUN(2,:) = [ 0 1];

% specify element type
ne = length(CON);                       % number of elements
[ElemName{1:ne}] = deal('Truss');       % truss element

Model = Create_SimpleModel (XYZ,CON,BOUN,ElemName);

% plot parameters
% -------------------------------------------------------------------------
WinXr = 0.40;  % X-ratio of plot window to screen size 
WinYr = 0.80;  % Y-ratio of plot window to screen size
% -------------------------------------------------------------------------
NodSF = 0.30;  % relative size for node symbol
AxsSF = 0.30;  % relative size of arrows
% -------------------------------------------------------------------------
% plot and label model for checking (optional)
Create_Window (WinXr,WinYr);          % open figure window
PlotOpt.PlNod = 'yes';
PlotOpt.PlBnd = 'yes';
PlotOpt.NodSF = NodSF;
Plot_Model  (Model,[],PlotOpt);       % plot model
PlotOpt.HngSF = 0.3;
PlotOpt.HOfSF = 0.6;
Plot_Releases (Model,[],[],PlotOpt);
PlotOpt.AxsSF = AxsSF;
PlotOpt.LOfSF = 1.8.*NodSF;
Label_Model (Model,PlotOpt);          % label model

%% form static (equilibrium) matrix B
B  = B_matrix(Model);
% extract submatrix for free dofs
Bf = B(1:Model.nf,:);
% determine particular and homogeneous solution
[Bbari,Bbarx] = BbariBbarx_matrix (Bf);

%% specify applied forces at free dofs
Pe(4,1) = 15;
% plot nodal forces for checking
Create_Window (WinXr,WinYr);
PlotOpt.PlNod = 'no';
PlotOpt.PlBnd = 'yes';
Plot_Model (Model,[],PlotOpt);
PlotOpt.Label ='yes';
PlotOpt.TipSF = 1.50;
Plot_NodalForces (Model,Pe,PlotOpt);

% assign nodal forces to nodal force vector
Pf = Create_NodalForces (Model,Pe);
% particular solution
Qp = Bbari*Pf
% homogeneous solution
Bbarx