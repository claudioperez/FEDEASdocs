% clear memory and define global variables.
CleanStart

alpha = 3;
beta  = 2;
alpha2 = 4 - alpha;

% Ph = 301.73611111;

Ph = 236.64;
% Ph = 217.667;

% nmopt = 'AISC';
xhw3p3_model

Ain = Ain_matrix(Model,ElemData, 'AISC-H2');
% alph = [1.0 1.0];
% LimSurf = Ain_matrix(Model,ElemData,alph);
[Qc, lamda1] = cpPlasticAnalysis_v2( Model, ElemData,Pref,Pcf,Ain);
lamda1
% 

% LimSurf = Set_PlastCond(Model,ElemData);
% Loading = Create_Loading(Model,Pf);
% % Loading.Pcf = Pcf
% [lamda1,Qc,DUf,DVpl] = PlasticAnalysis( Model, ElemData,Loading);
% 
% Qc
% lamda1

Post_PlasticAnalysis