% plot parameters
% -------------------------------------------------------------------------
WinXr = 0.40;  % X-ratio of plot window to screen size 
WinYr = 0.80;  % Y-ratio of plot window to screen size
% -------------------------------------------------------------------------

%% Post-processing
close all
% extract displacements from Post
np = length(Post);
kappa = zeros(np,1);
Mom   = zeros(np,1);
for k = 1:np
   kappa(k) = Post(k).Elem{1}.Sec{1}.e(2);
   Mom(k)   = Post(k).Elem{1}.Sec{1}.s(2);
end

% plot moment-curvature at base
Create_Window (WinXr,WinYr);

EI = (Mom(2)-Mom(1))./(kappa(2)-kappa(1));
kappap = Mp/(E*I);

Xp = kappa./kappap;
Yp = Mom./Mp;

PlotOpt.XLbl = '$$\kappa /\kappa_p$$';
PlotOpt.YLbl = '$$M/M_p$$';

AxHndlA = Plot_XYData (Xp,Yp,PlotOpt);

AxHndlA.XLim  = [-10 10 ];
AxHndlA.XTick = -10:5:10;
AxHndlA.YLim  = [ -1.25 1.25 ];
AxHndlA.YTick = -1.25:0.5:1.25;