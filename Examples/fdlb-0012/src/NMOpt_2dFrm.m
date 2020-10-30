function lim_coef = NMOpt_2dFrm (NMOpt)
    % function returns the interaction equation coefficient matrix, `lim_coef`,
    % if the value of lim_coef is a string corresponding to a predefined set 
    % of interaction equations.
 
    if ischar(NMOpt)
        switch NMOpt
            case {'AISC-H2','Dmnd'}
             %            N     M     
             lim_coef = [1.0  1.0];
            case {'AISC-H1', 'AISC'}
             %            N    M   
             lim_coef = [1.0  8/9; 
                         0.5  1.0];
            case {'nvm'}
             %            N    M    V 
             lim_coef = [1.0  1.0  1.0];
            case {'none'}
             %        N    
             lim_coef = 1.0;
            otherwise
             error ('Unrecognized interaction equation option in `ElemData.NMOpt`.')
        end
    else
       lim_coef = NMOpt;
    end
 end