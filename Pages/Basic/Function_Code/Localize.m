function [xyz,id] = Localize (Model,el)
%LOCALIZE node coordinates and id array of specific element
%  [XYZ,ID] = LOCALIZE (MODEL,EL)
%  the function returns the node coordinates XYZ and the id array ID
%  of the element with number EL for the structural model specified in data structure MODEL

%  =========================================================================================
%  FEDEASLab - Release 3.0, July 2009
%  Matlab Finite Elements for Design, Evaluation and Analysis of Structures
%  Professor Filip C. Filippou (filippou@ce.berkeley.edu)
%  Department of Civil and Environmental Engineering, UC Berkeley
%  Copyright(c) 1998-2009. The Regents of the University of California. All Rights Reserved.
%  =========================================================================================

XYZ = Model.XYZ;        % node coordinates
DOF = Model.DOF;        % array with dof numbers for all nodes

CON = Model.CON{el};    % extract connectivity array for element
ndf = Model.ndf(el);    % extract no of dofs/node for element

% extract element coordinates into array xyz;
% use CON array to extract appropriate rows of global XYZ array
xyz = XYZ(CON(CON>0),:)';

% extract dof numbers into array id
% use CON array to extract appropriate rows of DOF array
id = DOF(CON(CON>0),1:ndf)';
% reshape id array into vector   
id = id(:);