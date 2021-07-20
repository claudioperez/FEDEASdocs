function [L,dcx] = ElmLenOr (xyz)
%ELMLENOR element length and x-axis orientation (direction cosines)
%  [L,DCX] = ELMLENOR (XYZ);
%  the function determines the length L and x-axis orientation of an element
%  with end node coordinates XYZ (column 1 for node i, column 2 for node j);
%  the direction cosines for the element x-axis are reported in vector DCX 

%  =========================================================================================
%  FEDEASLab - Release 3.0, July 2009
%  Matlab Finite Elements for Design, Evaluation and Analysis of Structures
%  Professor Filip C. Filippou (filippou@ce.berkeley.edu)
%  Department of Civil and Environmental Engineering, UC Berkeley
%  Copyright(c) 1998-2009. The Regents of the University of California. All Rights Reserved.
%  =========================================================================================

% coordinate differences Dx, Dy, Dz depending on problem dimension
Dxyz = xyz (:,2) - xyz(:,1);   
% element length
L    = sqrt (Dxyz'*Dxyz);
% direction cosines of element orientation
dcx  = Dxyz./L;