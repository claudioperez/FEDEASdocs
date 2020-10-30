% X1 = [-60.06,59.95,-59.88,60.07,-59.80,60.02,-59.71,60.00,-59.65,59.98,-59.71,60.00,-59.80,60.02,-59.88,60.07,-60.06, 59.95];
% E1 = 24750.0;
% E2 = 27740.0;
% F1 = 2005.0;
% F2 = 20.32;

%% Mean values
X1  = [-60.00,60.0,-60.00,60.0,-60.00,60.0,-60.00,60.0,-60.00,60.0,-60.00,60.0,-60.00,60.0,-60.00,60.0,-60.00,60.0];
E1 =   30e3;
E2 =   30e3;
F1 =   20.0;
F2 =  500.0;

[Model,ElemData,Loading] = BuildModel(E1,E2,F1,F2,X1,true);

%% Run Analysis
State = LinearStep(Model,ElemData,Loading);

% SolStrat = Initialize_SolStrat;
% SolStrat.Dlam0 = 0.20
%S_InitialStep
% [State,Post] = MultiStep(Model,ElemData,SolStrat,5)

%% Post-processing
State.U(Model.DOF(10,1))
State.U
PlotOpt.MAGF = 1;
Plot_DeformedStructure(Model,ElemData,State.U,State,PlotOpt)
%Plot_DeformedStructure(Model,ElemData,State.U,Post,PlotOpt)
