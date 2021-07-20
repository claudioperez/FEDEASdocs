%% script for displacement method of structural analysis

%  =========================================================================================
%  FEDEASLab - Release 3.5, August 2014
%  Matlab Finite Elements for Design, Evaluation and Analysis of Structures
%  Professor Filip C. Filippou (filippou@ce.berkeley.edu)
%  Department of Civil and Environmental Engineering, UC Berkeley
%  Copyright(c) 1998-2014. The Regents of the University of California. All Rights Reserved.
%  =========================================================================================

%% the following data must be present in the workspace
%  Model    : data structure with structural model information (from Create_SimpleModel)
%  ElemData : data structure with element property information (specified by user)
%% the following data are optional and are set to default values if not present
%  Pf       : applied force vector at free dofs             ; default is 0
%  Pwf      : equivalent nodal forces due to element loading; default is 0

%% -----------------------------------------------------------------------------------------
if ~exist('Pf','var'), Pf = zeros(Model.nf,1); end
if ~exist('Pwf','var')
   Pw  = Create_PwForces (Model,ElemData);
   Pwf = Pw(1:Model.nf);
end
% form kinematic matrix A for all dofs
A  = A_matrix (Model);
% get element cell array for continuous element deformations
iced = H_index (Model,ElemData);
% concatenate indices to single index vector ic
ic = [iced{:}];
% form Af matrix for free dofs without rows with release deformations
Af = A(ic,1:Model.nf);
% set up Ks matrix and Q0 vector
Ks = Ks_matrix (Model,ElemData);
Q0 = Q0_vector (Model,ElemData);
% set up stiffness matrix Kf and initial force vector P0
Kf = Af'*Ks*Af;
P0 = Pwf + Af'*Q0;
% solve equilibrium equations for free dof displacements Uf
Uf = Kf\(Pf-P0);
% determine continuous element deformations V
V  = Af*Uf;
% determine basic forces Q
Q  = Ks*V + Q0;
% complete Q vector with release values and return Ve
[Q,Ve] = Complete_QV(Model,ElemData,Q);