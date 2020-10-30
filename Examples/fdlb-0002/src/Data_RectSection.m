%% geometry, material properties and reference values for homogeneous rectangular section

% unless script is called by another script clear memory and close open windows
FSt = dbstack;
if length(FSt)==1
  CleanStart
  % specify dimension ndm: (ndm = 2 for uniaxial, ndm = 3 for biaxial discretization)
  ndm = 2;
elseif exist('Model','var')
  ndm = Model.ndm;
else
  error ('problem dimension ndm not specified')
end

%% function name for homogeneous rectangular section 
SecName = 'HomoRectSecw1dMat';

%% dimensions of cross section

% insert units file, if necessary
if ~exist('in','var'), run('Units'), end

%% section geometry
d = 18*in;
b = 12*in;

SecData.d = d;
SecData.b = b;

%% numerical integration scheme
SecData.IntTyp = 'Midpoint';

%% section discretization
nyfib = 4;
SecData.ny = nyfib;

% for 3d section analysis only
if ndm>2
  nzfib = 12;
  SecData.nz = nzfib;
end

%% material properties
fy = 40*ksi;          % yield strength
E  = 20000.*ksi;      % elastic modulus
Hk = 1e-6.*E;
ey = fy/E;
% material model and parameters
MatName    = 'BilinInel1dMat';
MatData.E  = E;
MatData.fy = fy;
MatData.Eh = Hk;

%% reference values for rectangular section

%% area, moduli and moments of inertia
A  = b*d;
Zz = b*d^2/4;
Iz = b*d^3/12;
Zy = d*b^2/4;
Iy = d*b^3/12;

% numerical moment of inertia for 4-IPs
In = 5/64*b*d^3;

%% plastic capacities and deformations
Np  = fy*A;
Mpz = fy*Zz;
Mpy = fy*Zy;
ep  = Np/E/A;
kpy = Mpy/E/Iy;
% for uniaxial flexure+axial force
Mp  = Mpz;
kpz = Mp./E/In;
kp  = kpz;

%% copy material properties and function name to SecData
SecData.MatName{1} = MatName;
SecData.MatData{1} = MatData;
SecHndl = str2func(SecName);
SecData = SecHndl('chec',1,ndm,SecData);

%% plot section geometry
WinXr = 0.40;
WinYr = 0.80;
Create_Window(WinXr,WinYr);
Plot_SectionGeometry (SecData,[]);