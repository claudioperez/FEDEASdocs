%% script for force method of structural analysis

%  =========================================================================================
%  FEDEASLab - Release 3.2, July 2012
%  Matlab Finite Elements for Design, Evaluation and Analysis of Structures
%  Professor Filip C. Filippou (filippou@ce.berkeley.edu)
%  Department of Civil and Environmental Engineering, UC Berkeley
%  Copyright(c) 1998-2012. The Regents of the University of California. All Rights Reserved.
%  =========================================================================================

%% the following data must be present in the workspace
%  Model    : data structure with structural model information (from Create_SimpleModel)
%  ElemData : data structure with element property information (specified by user)
%% the following data are optional and are set to default values if not present
%  Pf       : applied force vector at free dofs             ; default is 0
%  Pfw      : equivalent nodal forces due to element loading; default is 0
%  ind_r    : index for redundant basic forces              ; default is [] (empty)

%% -----------------------------------------------------------------------------------------
if ~exist('Pf','var'),  Pf  = zeros(Model.nf,1); end
if ~exist('Pwf','var'), Pwf = zeros(Model.nf,1); end
% form static matrix B for all dofs
B  = B_matrix (Model);
% get element cell array for continuous element deformations
iced = H_index (Model,ElemData);
% concatenate indices to single index vector ic
ic = [iced{:}];
% form Bf matrix without columns corresponding to releases
Bf = B(1:Model.nf,ic);
% determine force influence matrices Bbari, Bbarx
if ~exist('ind_r','var'), ind_r = []; end
[Bbari,Bbarx] = ForceInfl_matrix (Bf,ind_r);
% set up Fs matrix and V0 vector
Fs  = Fs_matrix (Model,ElemData);
V0  = V0_vector (Model,ElemData);
% determine redundant basic forces
Qp  = Bbari*(Pf-Pwf);
Fxx = Bbarx'*Fs*Bbarx;
Qx  = -Fxx\(Bbarx'*(Fs*Qp+V0));
% determine final basic forces
Q   = Qp + Bbarx*Qx;
% determine element deformations Veps (Ve for short)
Ve  = Fs*Q + V0;
% determine free dof displacements
Uf  = Bbari'*Ve;
% complete Q vector with release values and return Ve 
[Q,Ve] = Complete_QV(Model,ElemData,Q);