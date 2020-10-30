%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%TEST 4 - CreateMesh: MR frame, uniform offsets.
%
% CreateMesh implemented in lines 61-62
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% 4-Story, 3-Bay Steel MRSF Building from NIST study
% Table D-6 Member Sizes for Special SMF Performance Group PG-2RSA, SDC Dmax
% from NIST report GCR 10-917-8, Appendix D, pp. D-5

% Department of Civil and Environmental Engineering
% University of California, Berkeley
% Professor Filip C. Filippou

%% Clear memory and close any open windows
CleanStart
% insert file of units
Units

% save name of script in variable ModelName
ModelName = mfilename;

%% no of stories nst
nst = 4;
%% no of bays nby
nby = 3;

%% typical story height
Hs  = 13*ft;
% specify individual story heights in row vector
Hsv = [Hs+2*ft repmat(Hs,1,nst-1)];

%% typical bay length
Lb = 20*ft;
% specify individual bay lengths in row vector
Lbv = repmat(Lb,1,nby);
% number of girder subelements
nsub = 1;

%% call function to generate node coordinates, element connectivity             
Frame = Create_MRFrame (Lbv,Hsv,nsub);

%% add gravity column to frame (choosing GravCol = 1 includes it)
GravCol = 0;
if GravCol, Frame = Add_GravityColumn2Frame (Frame); end

%% ready to generate Model from coordinates and connectivity in Frame
XYZ = Frame.XYZ;
CON = Frame.CON;

%% boundary conditions for fixed base of frame
% find nodes at base
Bnodes = find(XYZ(:,2)==0);
BOUN( Bnodes,:) = repmat([1 1 1],length(Bnodes),1);

%% specify element type (can change later)
ne = length(CON);
[ElemName{1:ne}] = deal ('LE2dFrm');       % 2d linear frame element

%% generate Model data structure
OFF = 15;
[XYZ,CON,ElemName] = CreateMesh(XYZ,CON,ElemName,OFF);
Model = Create_SimpleModel (XYZ,CON,BOUN,ElemName);

% plot parameters
% -------------------------------------------------------------------------
WinXr = 0.40;    % X-ratio of plot window to screen size 
WinYr = 0.80;    % Y-ratio of plot window to screen size
% -------------------------------------------------------------------------

Create_Window(WinXr,WinYr);
PlotOpt.PlNod = 'yes';
PlotOpt.PlBnd = 'yes';
PlotOpt.LnWth = 1.5;
PlotOpt.NodSF = 0.7;
Plot_Model  (Model,[],PlotOpt);    % plot model
PlotOpt.FntSF = 0.4;
Label_Model (Model,PlotOpt);       % label model

clear PlotOpt