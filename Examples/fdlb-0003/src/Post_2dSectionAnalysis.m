%% script for post-processing results of 2d moment-curvature analysis

% extract values from Post
np    = length(Post);
Pplot = zeros(2,np);
Uplot = zeros(2,np);
for k=1:np
   Pplot(:,k) = Post(k).Pr;
   Uplot(:,k) = Post(k).U;
end

NHist = Pplot(Model.DOF(1,1),:);
MHist = Pplot(Model.DOF(1,2),:);
eHist = Uplot(Model.DOF(1,1),:);
kHist = Uplot(Model.DOF(1,2),:);

%% plotting
WinXr = 0.40;
WinYr = 0.80;

if ~exist('Mpz','var')
  Mpz = Mp;
  kpz = kp;
end

% logical switch for superimposing the interaction diagram of the rectangular section on the plot
NMInter = false;
%% plot axial force-moment history
Create_Window(WinXr,WinYr);
% add the exact and the numerical interaction diagram
if NMInter
  n = -1:0.01:1;
  m = -1:0.01:1;
  fNM = @(m,n) (n.^2+abs(m)-1);
  fimplicit (fNM,[0,1,-1,0],'Linewidth',3,'Color','r');
  hold on
  NM_Interaction
end

Xp = MHist./Mpz;
Yp = NHist./Np;

PlotOpt.XLbl = 'Bending moment $$M / M_p$$';
PlotOpt.YLbl = 'Normal force $$N / N_p$$';

AxHndlA = Plot_XYData (Xp,Yp,PlotOpt);

% AxHndlA.XLim  = [ 0 1 ];
% AxHndlA.XTick = 0:0.2:1;
% AxHndlA.YLim  = [-0.5 0 ];
% AxHndlA.YTick = -0.5:0.1:0;

if NMInter, legend ('exact','numerical with 4 IP','Load Path','Location','SouthWest'); end

%% plot axial strain-curvature history
Create_Window(WinXr,WinYr);

Xp = kHist./kpz;
Yp = eHist./ep;

PlotOpt.XLbl = 'Curvature $$\kappa / \kappa_p$$';
PlotOpt.YLbl = 'Axial strain $$\epsilon_a / \epsilon_p$$';

AxHndlB = Plot_XYData (Xp,Yp,PlotOpt);

%% plot axial strain-axial force history
Create_Window(WinXr,WinYr);

Xp = eHist./ep;
Yp = NHist./Np;

PlotOpt.XLbl = 'Axial strain $$\epsilon_a  / \epsilon_p$$';
PlotOpt.YLbl = 'Normal force $$N / N_p$$';

AxHndlC = Plot_XYData (Xp,Yp,PlotOpt);

% AxHndlC.YLim  = [ 0 0.5 ];
% AxHndlC.YTick = 0:0.1:0.5;

%% plot moment-curvature relation
Create_Window(WinXr,WinYr);

Xp = kHist./kpz;
Yp = MHist./Mpz;

PlotOpt.XLbl = 'Curvature $$\kappa / \kappa_p$$';
PlotOpt.YLbl = 'Moment $$M / M_p$$';

AxHndlD = Plot_XYData (Xp,Yp,PlotOpt);

% AxHndlD.YLim  = [ 0 1.5 ];
% AxHndlD.YTick = 0:0.5:1.5;