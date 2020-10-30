function Ain = Set_PlastCond_mod (Model,ElemData,LimCoef)

% separate truss and frame elements
iNp = cellfun(@(x) contains(x,'Truss'),Model.ElemName);
iMp = cellfun(@(x) contains(x,'2dFrm'),Model.ElemName);
el  = 1:Model.ne;
tel = el(iNp);
fel = el(iMp);

LimitSurf = cell(Model.ne,1);
% for frame elements
for el = fel
  Npv = ElemData{el}.Np;
  if isscalar(Npv),  Np = [Npv Npv]; else, Np = Npv; end
  Mp = ElemData{el}.Mp;
  if size(Mp,2)==1, Mp = repmat(Mp,1,2); end
  if size(Mp,1)==1, Mp = repmat(Mp,2,1); end
  Mpi = Mp(:,1);
  Mpj = Mp(:,2);
  if isfield(ElemData{el},'NMOpt')
    NMOpt = ElemData{el}.NMOpt;
  else
    NMOpt = 'None';
  end
  %% limit surfaces for frame elements
  switch NMOpt
    case {'None','none'}
      LimitSurf{el} = [ diag([1/Np(1);1/Mpi(2);1/Mpj(1)]);
                       -diag([1/Np(2);1/Mpi(1);1/Mpj(2)])];
    case 'Dmnd'
      LimitSurf{el} = [ 1/Np(1)   1/Mpi(2)    0;
                       -1/Np(2)   1/Mpi(2)    0;
                        1/Np(1)  -1/Mpi(1)    0;
                       -1/Np(2)  -1/Mpi(1)    0;
                        1/Np(1)    0         1/Mpj(1);
                       -1/Np(2)    0         1/Mpj(1);
                        1/Np(1)    0        -1/Mpj(2);
                       -1/Np(2)    0        -1/Mpj(2)];
    case 'AISC'
      LimitSurf{el} = [  1/Np(1)   (8/9)/Mpi(2)      0;
                       1/2/Np(1)       1/Mpi(2)      0;
                        -1/Np(2)   (8/9)/Mpi(2)      0;
                      -1/2/Np(2)       1/Mpi(2)      0;
                         1/Np(1)  -(8/9)/Mpi(1)      0;
                       1/2/Np(1)      -1/Mpi(1)      0;
                        -1/Np(2)  -(8/9)/Mpi(1)      0;
                      -1/2/Np(2)      -1/Mpi(1)      0;
                         1/Np(1)        0       (8/9)/Mpj(1);
                       1/2/Np(1)        0           1/Mpj(1);
                        -1/Np(2)        0       (8/9)/Mpj(1);
                      -1/2/Np(2)        0           1/Mpj(1);
                         1/Np(1)        0      -(8/9)/Mpj(2);
                       1/2/Np(1)        0          -1/Mpj(2);
                        -1/Np(2)        0      -(8/9)/Mpj(2);
                      -1/2/Np(2)        0          -1/Mpj(2)];
  end
end
% for truss elements  
for el = tel
  Npv = ElemData{el}.Np;
  if isscalar(Npv),  Np = [Npv Npv]; else, Np = Npv; end
  LimitSurf{el} = [ 1/Np(1) ; -1/Np(2) ];
end
Ain = blkdiag (LimitSurf{:});