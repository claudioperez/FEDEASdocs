h = 12*12;
gamma = 1.2;

L = h/alpha2;

% define structural model (coordinates, connectivity, boundary conditions, element types).
XYZ(1,:) = [ 0.0   0.0 ];
XYZ(2,:) = [ 0.0    h  ]; 
XYZ(3,:) = [ L/2    h  ];
XYZ(4,:) = [  L     h  ];
XYZ(5,:) = [  L    0.0 ];

 
% element connectivity array.
CON(1,:) = [ 1   2 ];
CON(2,:) = [ 2   3 ];
CON(3,:) = [ 3   4 ];
CON(4,:) = [ 4   5 ];


% boundary conditions (1 = restrained,  0 = free) (specify only restrained dof's).
BOUN(1,:) = [ 1   1   0 ];
BOUN(5,:) = [ 1   1   0 ];

% create model.

[ElemName{1:4}] = deal('LE2dFrm');


Model = Create_SimpleModel (XYZ,CON,BOUN,ElemName);

% display the structural model
% Create_Window(0.80,0.80);
% Plot_Model(Model);
% Label_Model(Model);

%% Element Properties
% Element 2,3
for el=[2 3]
    ElemData{el}.E  = 1e16;
    ElemData{el}.I  = 1e16;
    ElemData{el}.A  = 1e16;
    ElemData{el}.Np = 1e16;
    ElemData{el}.Mp = 1e16;
    if exist('nmopt')
       ElemData{el}.NMOpt =  nmopt;
    end
end

fy = 50;
for el = [1 4]
    ElemData{el}.E  = 29e3;   % ksi
    ElemData{el}.A  =  125;   % in2
    ElemData{el}.I  =  6600;  % in4
    ElemData{el}.Mp =  869*fy;
    ElemData{el}.Np =  125*fy;
    if exist('nmopt')
       ElemData{el}.NMOpt =  nmopt;
    end
end

if ~exist('nmopt')
    ElemData{1}.Mp =  [ 0.00001 ; 869*fy];
    ElemData{4}.Mp =  [869*fy ; 0.00001];
end

Pf(3,1) = Ph;
Pf(3,3) = -Ph*alpha*h/alpha2;
Pref = Create_NodalForces(Model,Pf);


Pc(3,2) = -Ph*beta*gamma;
Pcf = Create_NodalForces(Model,Pc);