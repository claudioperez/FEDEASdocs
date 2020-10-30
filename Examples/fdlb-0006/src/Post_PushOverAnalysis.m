%% Post-Processing of Results from Incremental PushOver Analysis

close all

% plot parameters
% -------------------------------------------------------------------------
WinXr = 0.40;  % X-ratio of plot window to screen size 
WinYr = 0.80;  % Y-ratio of plot window to screen size
% -------------------------------------------------------------------------

nst = Frame.nst;
Hsv = Frame.Hsv;

GravCol = 0;
% -------------------------------------------------------------------------
%% get roof translation and base shear
HFlrTrans  = Get_HFlrTrans (Model,Frame,Post);
HRoofTrans = HFlrTrans(end,:);

StShear = Get_StShear (Model,ElemData,Frame,Post,GravCol);
% determine load factor by dividing base shear by sum of lateral forces
lam     = StShear(1,:)./sum(LatLoading.Pref);

%% Load factor-horizontal roof drift relation
Create_Window (WinXr,WinYr);

Xp = HRoofTrans./sum(Hsv);
Yp = lam;

PlotOpt.XLbl = 'Roof drift ratio';
PlotOpt.YLbl = 'Load factor $$\lambda$$';

AxHndlA = Plot_XYData (Xp,Yp,PlotOpt);

AxHndlA.XLim  = [ 0 0.08 ];
AxHndlA.XTick = 0:0.02:0.08;
AxHndlA.YLim  = [ 0 2.5 ];
AxHndlA.YTick = 0:0.5:2.5;

% -------------------------------------------------------------------------
%% plot moment distribution at end of push-over
Create_Window (WinXr,WinYr);
Plot_Model(Model);
Plot_2dMomntDistr (Model,ElemData,Post(end),[],0.5);
% show plastic hinge locations
PlotOpt.HngSF = 1.2;
PlotOpt.HOfSF = 1.5;
Plot_PlasticHinges(Model,ElemData,[],Post(end),PlotOpt);

% -------------------------------------------------------------------------
%% plot deformed shape and plastic hinge locations
Create_Window (WinXr,WinYr);
MAGF = 5;
Plot_Model(Model);
% Show plastic hinge locations
PlotOpt.MAGF = MAGF;
Plot_DeformedStructure(Model,ElemData,Post(end).U,Post(end),PlotOpt);
Ufinal = State.U;
Plot_PlasticHinges (Model,ElemData,Post(end).U,Post(end),PlotOpt);

% -------------------------------------------------------------------------
%% plot story shear distribution specific load points
Create_Window (WinXr,WinYr);
% npi = [50:10:100 length(Post)];
npi = 20:10:length(Post);
StShear = Get_StShear (Model,ElemData,Frame,Post(npi),GravCol)./kip;
X = StShear;
Y = repmat( (1:nst)',1,length(npi));
stairs (X,Y,'LineWidth',2)
set (gca,'FontSize',30,'FontName','Times New Roman');
set (gca,'XLim',[0 1000]);
xlabel ('Story Shear (kips)','FontName','Times New Roman','FontSize',30);
ylabel ('Story','FontName','Times New Roman','FontSize',30);
grid on
box on

% -------------------------------------------------------------------------
%% plot interstory drift distribution for specific load points
Create_Window (WinXr,WinYr);
% npi = [50:10:100 length(Post)];
npi = 20:10:length(Post);
RIStDrift = Get_RIStDrift (Model,Frame,Post(npi));
X = RIStDrift;
Y = repmat( (1:nst)',1,length(npi));
% stairs (RIStDrift(:,1:np),repmat( (1:nst)',1,np),'LineWidth',2)
stairs (X,Y,'LineWidth',2)
set (gca,'FontSize',30,'FontName','Times New Roman');
xlabel ('Interstory Drift Ratio','FontName','Times New Roman','FontSize',30);
ylabel ('Story','FontName','Times New Roman','FontSize',30);
grid on
box on

% -------------------------------------------------------------------------
%% plot story shear-interstory drift relation for all stories
Create_Window (WinXr,WinYr);
StShear = Get_StShear (Model,ElemData,Frame,Post,GravCol)./kip;
RIStDrift = Get_RIStDrift (Model,Frame,Post);

Xp = RIStDrift';
Yp = StShear';

PlotOpt.XLbl = 'Interstory Drift Ratio';
PlotOpt.YLbl = 'Story Shear (kips)';
PlotOpt.MltClr = true;

AxHndlB = Plot_XYData (Xp,Yp,PlotOpt);

AxHndlB.XLim  = [ 0 0.1 ];
AxHndlB.XTick = 0:0.02:0.1;
AxHndlB.YLim  = [ 0 1000 ];
AxHndlB.YTick = 0:200:1000;

LG = strsplit(num2str(1:Frame.nst));
LG = strcat(LG,'. Story');
legend(LG,'Location','SouthEast');