function ain = LimEqns_Frm2d (ElemData, lim_coef, xyz)
    % function forms the element interaction matrix, `ain`, for the element
    % with  element property information in data structure ElemData.
    %
    % Preliminary - 4/8/2020
    %-----------------------------------------------------------------------

    %% Input Handling ------------------------------------------------------
    N = size(lim_coef, 1); % number of interaction surface equations
    
    if size(lim_coef,2)==2
       ns = 4; % Case II  - NM interaction
    else 
       ns = 8; % Case III - NVM interaction
    end
 
    % Set up Plastic capacities
    % Check that plastic capacities are supplied for pos/neg and i/j cases
    if isfield(ElemData,'Vp')
       Vp = ElemData.Vp;
       [L,~] = ElmLenOr(xyz);
    else 
       Vp = 1.0;
       L  = 1.0;
    end
 
    Np = ElemData.Np;
    if size(Np,2)==1, Np = repmat(Np,1,2); end
    if size(Np,1)==1, Np = repmat(Np,2,1); end
    Npi = Np(:,1);
    Npj = Np(:,2);
  
    Mp = ElemData.Mp;
    if size(Mp,2)==1, Mp = repmat(Mp,1,2); end
    if size(Mp,1)==1, Mp = repmat(Mp,2,1); end
    Mpi = Mp(:,1);
    Mpj = Mp(:,2);
   % End of Input Handling ----------------------------------------------------
   
   %% Construct matrices
   if isequal(size(lim_coef) , [1,1]) 
      % Case I - No interaction
   
      ai = [ 1/Npi(1)    0.0       0.0; 
            -1/Npi(2)    0.0       0.0;
               0.0     1/Mpi(2)    0.0;  % Note: Mpi is specified with a different sign convention from Q2i
               0.0    -1/Mpi(1)    0.0];

      aj = [ 1/Npj(1)   0.0     0.0;  
            -1/Npj(2)   0.0     0.0;
               0.0      0.0  1/Mpj(1);
               0.0      0.0 -1/Mpj(2)];
   else 
      % Case II and III - NM, NVM interaction
      
      ai = zeros(ns*N,3);
      for n=1:N
         % Construct matrix at i-node
          A = lim_coef(n,1);
          B = lim_coef(n,2);
          C = 0.0;
          if size(lim_coef,1)>2, C = lim_coef(n,3); end
          
          aii =  [  A/Npi(1)   B/Mpi(2)+C/(L*Vp)   C/(L*Vp);
                   -A/Npi(2)   B/Mpi(2)+C/(L*Vp)   C/(L*Vp);
                    A/Npi(1)  -B/Mpi(1)+C/(L*Vp)   C/(L*Vp);
                   -A/Npi(2)  -B/Mpi(1)+C/(L*Vp)   C/(L*Vp);
                    A/Npi(1)   B/Mpi(2)-C/(L*Vp)  -C/(L*Vp);
                   -A/Npi(2)   B/Mpi(2)-C/(L*Vp)  -C/(L*Vp);
                    A/Npi(1)  -B/Mpi(1)-C/(L*Vp)  -C/(L*Vp);
                   -A/Npi(2)  -B/Mpi(1)-C/(L*Vp)  -C/(L*Vp)];

          ai(ns*(n-1)+1:n*ns,:) = aii(1:ns,:);
      end
 
      aj = zeros(ns*N,3);
      for n=1:N
         % Construct matrix at j-node

          A = lim_coef(n,1);
          B = lim_coef(n,2);
          C = 0.0;
          if size(lim_coef,2)==3, C = lim_coef(n,3); end
          ajj = [ A/Npj(1)    C/(L*Vp)    B/Mpj(1)+C/(L*Vp);
                 -A/Npj(2)    C/(L*Vp)    B/Mpj(1)+C/(L*Vp);
                  A/Npj(1)    C/(L*Vp)   -B/Mpj(2)+C/(L*Vp);
                 -A/Npj(2)    C/(L*Vp)   -B/Mpj(2)+C/(L*Vp);
                  A/Npj(1)   -C/(L*Vp)    B/Mpj(1)-C/(L*Vp);
                 -A/Npj(2)   -C/(L*Vp)    B/Mpj(1)-C/(L*Vp);
                  A/Npj(1)   -C/(L*Vp)   -B/Mpj(2)-C/(L*Vp);
                 -A/Npj(2)   -C/(L*Vp)   -B/Mpj(2)-C/(L*Vp)];  
          aj(ns*(n-1)+1:n*ns,:) = ajj(1:ns,:);     
      end
   end
   ain = [ ai; aj];
end
 