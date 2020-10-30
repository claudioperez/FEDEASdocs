function plot_evol(SecData, MatState)
% This function plots points on the evolved yield surface for a given material state.
% Limit surface points are generated by calling the function `lim_evol, which takes 
% 
% Sections of code that are marked as **Section-specific** can be switched out 
% to allow for a wider range of singly-symmetric cross sections.
% 

%% Set up
MatData = SecData.MatData;
fy = MatData.fy;
nIP = size(MatState,2);
XY=zeros(nIP,2);
for i=1:nIP, XY(i,2) = MatState{i}.sig/fy; end
[xIP,wIP] = feval(SecData.IntTyp, nIP);

% **Section-specific**; consider generalizing
b = SecData.b;
d = SecData.d;
xIP = xIP.*d/2; 
wIP = wIP.*(d/2*b);
Np = b*d*fy;
Mpz = 0.25*fy*b*d^2;

%% Get compatible yielding stress distributions
XY(:,1) = xIP;
[epsa,kappa,sig_y] = lin_clip(XY, d/2);

np = size(sig_y, 2); % number of points

%% Plot section stress distribution at each point
subplot(1,2,1)
hold on
for i=1:np, plot(sig_y(:,i), XY(:,1)); end

% Styling
xlabel('\sigma/\sigma_y');
ylabel('y');
grid on;
line([0,0], ylim, 'Color', 'k', 'LineWidth', 2); % Draw line for Y axis.
line(xlim, [0,0], 'Color', 'k', 'LineWidth', 2); % Draw line for X axis.
hold off

%% Plot interaction points
% for i=1:np, sig_y(:,i) = sig_y(:,i).*wIP*fy; end
Ni = zeros(np,1);
Mi = zeros(np,1);
for i = 1:np
    Ni(i) =  sum( sig_y(:,i).*wIP*fy );
    Mi(i) = -sum( sig_y(:,i).*xIP.*wIP*fy);
end
size(Ni)
size(Mi)
% Create_Window(0.4, 0.6);
subplot(1,2,2)
scatter( Mi/Mpz, Ni/Np );
hold on
% Plot M-N point at load
M = -sum( fy* XY(:,2).*wIP.*xIP);
N =  sum( fy* XY(:,2).*wIP );
plot(M/Mpz, N/Np,'o','Color','k')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% NM_Interaction
% get numerical interaction diagram by calculating all combinations
% of IPs with +ve and -ve fy. **Section-specific**.
Ni = zeros(nIP+1,1);
Mi = zeros(nIP+1,1);
Ni(1) = sum(fy.*wIP);       % tensile capacity
Mi(1) = 0;
sigma = zeros(nIP,1);
for i=1:nIP
   k = 1:i;                 % points in compression
   sigma(k) = -fy.*wIP(k);
   m = i+1:nIP;             % points in tension
   sigma(m) =  fy.*wIP(m);
   Ni(i+1)  =  sum(sigma);
   Mi(i+1)  = -sum(sigma.*xIP);
end
plot( Mi./Mpz, Ni./Np, '--', 'Color','b');
plot(-Mi./Mpz, Ni./Np, '--', 'Color','b');
xlim([-1.1,1.1]);
ylim([-1.1,1.1]);
grid on;
line([0,0], ylim, 'Color', 'k', 'LineWidth', 2); % Draw line for Y axis.
line(xlim, [0,0], 'Color', 'k', 'LineWidth', 2); % Draw line for X axis.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
hold off
