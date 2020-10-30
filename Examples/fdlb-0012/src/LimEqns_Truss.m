function ain = LimEqns_Truss (ElemData,lim_coef)
    % function forms the element interaction matrix, `ain`, for the element
    % with  element property information in data structure ElemData
    % nFrmLimSurfs

    % linear truss element

    Np = ones(2,2).*ElemData.Np(1,1);
    if isequal(size(ElemData.Np) , [1,1] )
       if isequal(size(ElemData.Np) , [1,2])
          Np = [ElemData.Np ; ElemData.Np]; 
       end
       if isequal(size(ElemData.Np) , [2,1])
          Np = [ElemData.Np   ElemData.Np]; 
       end
    end
    Npi = Np(1,:);
    Npj = Np(2,:);

    
    ain = [ 1/Npi(1);
           -1/Npi(2);
            1/Npj(1);
           -1/Npj(2)];

end
 