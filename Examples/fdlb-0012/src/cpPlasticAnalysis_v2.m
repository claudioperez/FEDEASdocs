function [Q,lamda] = cpPlasticAnalysis(Model,ElemData,Pref, Pcf, Ain)
%Plastic analysis with UBT
%  this function is intended only for rough testing of the funtion `Ain_matrix`
%  for the upper bound theorem of plastic analysis.
%  =========================================================================================

%% Additions by Claudio Perez
A = A_matrix(Model);
Af = A(:,1:Model.nf);
% End addition

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Excerpt of an email recieved from Prof. Filippou 
% dated Monday, January 13, 2020 2:14 PM
% --------------------------------------------------

% the equilibrium equations serve as equality constraints with coefficient matrix Aeq
Aeq = [Pref -Af'];          % Variable name changed 
% beq = -Pcf;
beq = -Pcf;

% the plastic conditions are inequality constraints with coefficient matrix Ain

% Ain = Set_PlastCond (Model,ElemData);

[nr,nc] = size(Ain);
% left hand side of plastic conditions
Aub = [zeros(nr,1) Ain];    % Variable name changed 
% right hand side of plastic conditions
bub = ones(nr,1);           % Variable name changed 

% maximize load factor (minimize negative of load factor) 
f  = [-1 zeros(1,nc)];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Additions by Claudio Perez
x = linprog(f,Aub,bub,Aeq,beq);
Q = x(2:end);
lamda = x(1);
end
% End addition
