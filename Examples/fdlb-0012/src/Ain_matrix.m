function Ain = Ain_matrix(Model, ElemData, lim_coef)
%AIN_MATRIX block diagonal matrix of element limit-surface equations
%  AIN = AIN_MATRIX (MODEL,ELEMDATA)
%  AIN = AIN_MATRIX (MODEL,ELEMDATA,lim_coef)
%  This function sets up the block diagonal matrix of element limit-surface equations, 
%  $A_{in}$, for the structural model specified in data structure MODEL with element property
%  information in cell array ELEMDATA. Options for parameter lim_coef are specified below.
%  
%  ## Parameters
%  - `Model`: struct
%    Contains structure connectivity data.
%
%  - `ElemData`: cell array
%    Contains element property data.
%  
%  - `lim_coef`: (Optional) Char array or float array.
%  
%     **Array.**
%     If an $n \times 2$ array is passed, $n$ piecewise linear axial-moment interaction 
%     equations of the following form will be generated for each element:
%     $$a_n \frac{|N|}{N_{pl}} + b_n\left( \frac{|M_z|}{M_{p,z}} + \frac{|M_y|}{M_{p,y}}\right)  \leq 1.0$$
%  
%     If an $n \times 3$ array is passed, $n$ piecewise linear axial-moment-shear 
%     interaction equations of the following form will be applied:
%     $$a_n \frac{|N|}{N_{p}} + b_n \frac{|M|}{M_{p}} + c_n \frac{|V|}{V_{p}} \leq 1.0$$
%     
%     **String.**
%     Alternatively, a `char array` may be passed indicating one of the following options:
%     - `'AISC-H2'` (Default)
%     - `'AISC-H1'`
%
%     **Empty.**
%     If no parameter is passed in the third position, the function will go to the `NMOpt` 
%     field of the cell `ElemData` for each element, which may also contain a string or an 
%     array. Elements with no such field will default to the `AISC-H2` option.
%  =========================================================================================

% Loop variables
ne = Model.ne;
Ain  = cell(ne,1);


if (nargin>2) % use supplied interaction coefficients for all elements
   lim_coef = NMOpt_2dFrm (lim_coef);
   for el = 1:ne
      % set up element interaction matrix
      [xyz,~] = Localize(Model,el);
      Ain{el} = ain_matrix (Model.ElemName{el},ElemData{el},xyz,lim_coef);
   end

else  % use interaction coefficients supplied for each element in ElemData
   for el = 1:ne
      % set up element interaction matrix
      [xyz,~] = Localize(Model,el);
      Ain{el} = ain_matrix (Model.ElemName{el},ElemData{el},xyz);
   end
end

% set up block-diagonal array of element interaction matrices for structure
Ain = blkdiag (Ain{:});
end

%% -function ain_matrix ----------------------------------------------------------------------
function ain = ain_matrix (ElemName,ElemData,xyz,lim_coef)
   % function forms the element interaction matrix, `ain`, for the element of type ElemName
   % with  element property information in data structure ElemData
   
   % Input handling --------------------------------
   if nargin==4
      % proceed using limit coefficients supplied at function call

   elseif isfield(ElemData,'NMOpt') 
      % use coefficients from ElemData
      lim_coef = NMOpt_2dFrm(ElemData.NMOpt);

   else 
      % default to diamond limit surface
      lim_coef = NMOpt_2dFrm('AISC-H2')
   end
   % End of input handling -------------------------

   if contains(ElemName,'Truss')
      ain = LimEqns_Truss(ElemData, lim_coef);
      
   elseif contains(ElemName,'2dFrm')
      ain = LimEqns_2dFrm(ElemData, lim_coef, xyz);
   else
      error ('Only truss and 2d frame elements supported; check syntax.')
   end
end