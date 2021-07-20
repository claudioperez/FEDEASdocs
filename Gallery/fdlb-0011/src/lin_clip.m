function [yref,M,Y_lim] = lin_clip(XY,xref)

    X = XY(:,1);
    n = size(XY,1);
    ct = 1;
    
    for i = 1:n
        ys = 1 - XY(i,2);
        Yt = XY(:,2) + ys;
        x = XY(i,1);
        
        if max(Yt)<=1.001 && min(Yt)>=-1.001
            yref(ct) = ys;
            M(ct) = 0 ;
            Y_lim(:,ct) = Yt;
            ct = ct + 1;
        end
        
        for j = [1:i-1, i+1:n]
            % y(i,j) = [+1,+1]
            m = -( Yt(j) - 1  ) / ( XY(j,1) - XY(i,1) );
            Yr = Yt + m*(X-x);
            if max(Yr)<=1.001 && min(Yr)>=-1.001
                yref(ct) = ys + m*(x-xref);
                M(ct) = m;
                Y_lim(:,ct) = Yr;
                ct = ct + 1;
            end
            % y(i,j) = [+1,-1]
            m = -( Yt(j) + 1  ) / ( XY(j,1) - XY(i,1) );
            Yr = Yt + m*(X-x);
            if max(Yr)<=1.001 && min(Yr)>=-1.001
                yref(ct) = ys + m*(x-xref);
                M(ct) = m;
                Y_lim(:,ct) = Yr;
                ct = ct + 1;
            end
        end
    end
    for i = 1:n
        ys =-1 - XY(i,2);
        Yt = XY(:,2) + ys;
        x = XY(i,1); 
        if max(Yt)<=1.001 && min(Yt)>=-1.001
            yref(ct) = ys;
            M(ct) = 0 ;
            Y_lim(:,ct) = Yt;
            ct = ct + 1;
        end
        
        for j = [1:i-1, i+1:n]
            % y(i,j) = [-1,+1]
            m = -( Yt(j) - 1  ) / ( XY(j,1) - XY(i,1) );
            Yr = Yt + m*(X-x);
            if max(Yr)<=1.001 && min(Yr)>=-1.001
                yref(ct) = ys + m*(x-xref);
                M(ct) = m ;
                Y_lim(:,ct) = Yr;
                ct = ct + 1;
            end
            % y(i,j) = [-1,-1]
            m = -( Yt(j) + 1  ) / ( XY(j,1) - XY(i,1) );
            Yr = Yt + m*(X-x);
            if max(Yr)<=1.001 && min(Yr)>=-1.001
                yref(ct) = ys + m*(x-xref);
                M(ct) = m ;
                Y_lim(:,ct) = Yr;
                ct = ct + 1;
            end
        end
    end