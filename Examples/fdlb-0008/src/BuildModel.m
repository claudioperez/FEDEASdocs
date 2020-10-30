function [Model,ElemData,Loading] = BuildModel(E1,E2,F1,F2,X1,plotmodel)

if nargin<5; plotmodel = true; end

if exist ('XYZ','var');  clear XYZ; end
if exist ('BOUN','var'); clear BOUN; end
if exist ('CON','var');  clear CON; end
if exist ('ElemData','var'); clear ElemData; end
if exist ('Model','var'); clear Model; end
if exist ('State','var'); clear State; end
if exist ('Post','var');  clear Post; end
if exist ('Loading','var'); clear Loading; end


% Node Definitions
XYZ(1,:)  = [   0.0    0.0];
XYZ(2,:)  = [ X1(1)   60.0];
XYZ(3,:)  = [ X1(2)   60.0];
XYZ(4,:)  = [ X1(3)  180.0];
XYZ(5,:)  = [ X1(4)  180.0];
XYZ(6,:)  = [ X1(5)  300.0];
XYZ(7,:)  = [ X1(6)  300.0];
XYZ(8,:)  = [ X1(7)  420.0];
XYZ(9,:)  = [ X1(8)  420.0];
XYZ(10,:) = [ X1(9)  540.0];
XYZ(11,:) = [X1(10)  540.0];
XYZ(12,:) = [X1(11)  660.0];
XYZ(13,:) = [X1(12)  660.0];
XYZ(14,:) = [X1(13)  780.0];
XYZ(15,:) = [X1(14)  780.0];
XYZ(16,:) = [X1(15)  900.0];
XYZ(17,:) = [X1(16)  900.0];
XYZ(18,:) = [X1(17) 1020.0];
XYZ(19,:) = [X1(18) 1020.0];
XYZ(20,:) = [   0.0 1080.0];
 
% Connections
CON( 1,:) = [ 1  2];
CON( 2,:) = [ 2  3];
CON( 3,:) = [ 1  3];
CON( 4,:) = [ 3  4];
CON( 5,:) = [ 2  4];
CON( 6,:) = [ 4  5];
CON( 7,:) = [ 3  5];
CON( 8,:) = [ 5  6];
CON( 9,:) = [ 4  6];
CON(10,:) = [ 6  7];
CON(11,:) = [ 5  7];
CON(12,:) = [ 7  8];
CON(13,:) = [ 6  8];
CON(14,:) = [ 8  9];
CON(15,:) = [ 7  9];
CON(16,:) = [ 9 10];
CON(17,:) = [ 8 10];
CON(18,:) = [10 11];
CON(19,:) = [ 9 11];
CON(20,:) = [11 12];
CON(21,:) = [10 12];
CON(22,:) = [12 13];
CON(23,:) = [11 13];
CON(24,:) = [13 14];
CON(25,:) = [12 14];
CON(26,:) = [14 15];
CON(27,:) = [13 15];
CON(28,:) = [15 16];
CON(29,:) = [14 16];
CON(30,:) = [16 17];
CON(31,:) = [15 17];
CON(32,:) = [17 18];
CON(33,:) = [16 18];
CON(34,:) = [18 19];
CON(35,:) = [17 19];
CON(36,:) = [19 20];
CON(37,:) = [18 20];

% Boundary Conditions
BOUN( 1,:) = [1 1];
BOUN(20,:) = [1 0];

% Specify element type
ne = size(CON,1);
[ElemName{1:ne}] = deal('LETruss');

% Create model
Model = Create_SimpleModel (XYZ,CON,BOUN,ElemName);

% Element properties

ElemData = cell(Model.ne,1);

% Element: strut-1
ElemData{1}.A = 1.59;
ElemData{1}.E = E1;
ElemData{1}.Np = 0.0;
ElemData{1}.Geom = 'GL';

% Element: brace-2
ElemData{2}.A = 0.938;
ElemData{2}.E = E2;
ElemData{2}.Np = 0.0;
ElemData{2}.Geom = 'GL';

% Element: strut-3
ElemData{3}.A = 1.59;
ElemData{3}.E = E1;
ElemData{3}.Np = 0.0;
ElemData{3}.Geom = 'GL';

% Element: brace-4
ElemData{4}.A = 0.938;
ElemData{4}.E = E2;
ElemData{4}.Np = 0.0;
ElemData{4}.Geom = 'GL';

% Element: strut-5
ElemData{5}.A = 1.59;
ElemData{5}.E = E1;
ElemData{5}.Np = 0.0;
ElemData{5}.Geom = 'GL';

% Element: brace-6
ElemData{6}.A = 0.938;
ElemData{6}.E = E2;
ElemData{6}.Np = 0.0;
ElemData{6}.Geom = 'GL';

% Element: strut-7
ElemData{7}.A = 1.59;
ElemData{7}.E = E1;
ElemData{7}.Np = 0.0;
ElemData{7}.Geom = 'GL';

% Element: brace-8
ElemData{8}.A = 0.938;
ElemData{8}.E = E2;
ElemData{8}.Np = 0.0;
ElemData{8}.Geom = 'GL';

% Element: strut-9
ElemData{9}.A = 1.59;
ElemData{9}.E = E1;
ElemData{9}.Np = 0.0;
ElemData{9}.Geom = 'GL';

% Element: brace-10
ElemData{10}.A = 0.938;
ElemData{10}.E = E2;
ElemData{10}.Np = 0.0;
ElemData{10}.Geom = 'GL';

% Element: strut-11
ElemData{11}.A = 1.59;
ElemData{11}.E = E1;
ElemData{11}.Np = 0.0;
ElemData{11}.Geom = 'GL';

% Element: brace-12
ElemData{12}.A = 0.938;
ElemData{12}.E = E2;
ElemData{12}.Np = 0.0;
ElemData{12}.Geom = 'GL';

% Element: strut-13
ElemData{13}.A = 1.59;
ElemData{13}.E = E1;
ElemData{13}.Np = 0.0;
ElemData{13}.Geom = 'GL';

% Element: brace-14
ElemData{14}.A = 0.938;
ElemData{14}.E = E2;
ElemData{14}.Np = 0.0;
ElemData{14}.Geom = 'GL';

% Element: strut-15
ElemData{15}.A = 1.59;
ElemData{15}.E = E1;
ElemData{15}.Np = 0.0;
ElemData{15}.Geom = 'GL';

% Element: brace-16
ElemData{16}.A = 0.938;
ElemData{16}.E = E2;
ElemData{16}.Np = 0.0;
ElemData{16}.Geom = 'GL';

% Element: strut-17
ElemData{17}.A = 1.59;
ElemData{17}.E = E1;
ElemData{17}.Np = 0.0;
ElemData{17}.Geom = 'GL';

% Element: brace-18
ElemData{18}.A = 0.938;
ElemData{18}.E = E2;
ElemData{18}.Np = 0.0;
ElemData{18}.Geom = 'GL';

% Element: strut-19
ElemData{19}.A = 1.59;
ElemData{19}.E = E1;
ElemData{19}.Np = 0.0;
ElemData{19}.Geom = 'GL';

% Element: brace-20
ElemData{20}.A = 0.938;
ElemData{20}.E = E2;
ElemData{20}.Np = 0.0;
ElemData{20}.Geom = 'GL';

% Element: strut-21
ElemData{21}.A = 1.59;
ElemData{21}.E = E1;
ElemData{21}.Np = 0.0;
ElemData{21}.Geom = 'GL';

% Element: brace-22
ElemData{22}.A = 0.938;
ElemData{22}.E = E2;
ElemData{22}.Np = 0.0;
ElemData{22}.Geom = 'GL';

% Element: strut-23
ElemData{23}.A = 1.59;
ElemData{23}.E = E1;
ElemData{23}.Np = 0.0;
ElemData{23}.Geom = 'GL';

% Element: brace-24
ElemData{24}.A = 0.938;
ElemData{24}.E = E2;
ElemData{24}.Np = 0.0;
ElemData{24}.Geom = 'GL';

% Element: strut-25
ElemData{25}.A = 1.59;
ElemData{25}.E = E1;
ElemData{25}.Np = 0.0;
ElemData{25}.Geom = 'GL';

% Element: brace-26
ElemData{26}.A = 0.938;
ElemData{26}.E = E2;
ElemData{26}.Np = 0.0;
ElemData{26}.Geom = 'GL';

% Element: strut-27
ElemData{27}.A = 1.59;
ElemData{27}.E = E1;
ElemData{27}.Np = 0.0;
ElemData{27}.Geom = 'GL';

% Element: brace-28
ElemData{28}.A = 0.938;
ElemData{28}.E = E2;
ElemData{28}.Np = 0.0;
ElemData{28}.Geom = 'GL';

% Element: strut-29
ElemData{29}.A = 1.59;
ElemData{29}.E = E1;
ElemData{29}.Np = 0.0;
ElemData{29}.Geom = 'GL';

% Element: brace-30
ElemData{30}.A = 0.938;
ElemData{30}.E = E2;
ElemData{30}.Np = 0.0;
ElemData{30}.Geom = 'GL';

% Element: strut-31
ElemData{31}.A = 1.59;
ElemData{31}.E = E1;
ElemData{31}.Np = 0.0;
ElemData{31}.Geom = 'GL';

% Element: brace-32
ElemData{32}.A = 0.938;
ElemData{32}.E = E2;
ElemData{32}.Np = 0.0;
ElemData{32}.Geom = 'GL';

% Element: strut-33
ElemData{33}.A = 1.59;
ElemData{33}.E = E1;
ElemData{33}.Np = 0.0;
ElemData{33}.Geom = 'GL';

% Element: brace-34
ElemData{34}.A = 0.938;
ElemData{34}.E = E2;
ElemData{34}.Np = 0.0;
ElemData{34}.Geom = 'GL';

% Element: strut-35
ElemData{35}.A = 1.59;
ElemData{35}.E = E1;
ElemData{35}.Np = 0.0;
ElemData{35}.Geom = 'GL';

% Element: strut-36
ElemData{36}.A = 1.59;
ElemData{36}.E = E1;
ElemData{36}.Np = 0.0;
ElemData{36}.Geom = 'GL';

% Element: strut-37
ElemData{37}.A = 1.59;
ElemData{37}.E = E1;
ElemData{37}.Np = 0.0;
ElemData{37}.Geom = 'GL';


ElemData = Structure('chec',Model,ElemData);

%% Element loads

%% Nodal loads
% Pf = zeros(37);
% Pf(17) = 20.32;
% Pf(37) = 2005.0;
% Loading.Pref = Pf;

Pe(10,1) =  F1;
Pe(20,2) = -F2;
Loading = Create_Loading (Model,Pe);

if plotmodel
    % plot parameters
    % -------------------------------------------------------------------------
    WinXr = 0.40;  % X-ratio of plot window to screen size 
    WinYr = 0.80;  % Y-ratio of plot window to screen size
    % -------------------------------------------------------------------------
    Create_Window (WinXr,WinYr);       % open figure window
    PlotOpt.NodSF = 0.35;
    PlotOpt.HngSF = 0.35;
    PlotOpt.PlNod = 'yes';
    PlotOpt.PlBnd = 'yes';
    Plot_Model (Model,[],PlotOpt);
    PlotOpt.AxsSF = 0.5;
    Label_Model(Model,PlotOpt);
    
    PlotOpt.FrcSF = 0.1;
    PlotOpt.TipSF  = 1.0;
    PlotOpt.LineWidth = 0.5;
    Plot_NodalForces(Model,Loading,PlotOpt);
end

end

