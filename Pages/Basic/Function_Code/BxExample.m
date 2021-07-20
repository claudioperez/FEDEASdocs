%% Matlab script for force influence matrix generation

% Department of Civil and Environmental Engineering
% University of California, Berkeley
% Professor Filip C. Filippou

% clear memory
CleanStart

% static matrix Bf of braced frame (Ex 2.7)
Bf = [ 1/6  1/6  0    0    0  0.8;
        0    1   1    0    0   0 ;
        0    0 -1/4 -1/4  1/4  0 ;
        0    0   0    1    1   0 ];

% select basic force redundants
ind_r = [1,4];
[Bbari,Bbarx,ind_x] = BbariBbarx_matrix(Bf,ind_r);
Pf = [20;0;-30;0];
Qp = Bbari*Pf;
format compact
diary on
Bbari
disp('')
disp(['QpT =  ' num2str(Qp')])
disp('')
Bbarx
diary off