function [XYZ,CON,ElemName] = CreateMesh(XYZ,CON,BOUN,ElemName,OFF,JointName)
% Generate a mesh of a frame element model's geometry specified by XYZ and CON.
%
% [XYZ,CON,ElemName] = CreateMesh(XYZ,CON,ElemName,OFF,JointName)
%
% ## Description
%     This function generates a mesh of a structural model of 1D frame 
%     elements (2-nodes) with geometry specified in XYZ and CON. 
%
% ## Input parameters
%     - XYZ (2D: [nn x 2], 3D: [nn x 3]): node coordinates of model.
%     - CON ([ne x ?]): model connectivity.
%     - ElemName (cell array): Specifies element types.
%     - OFF ([ne x 2] or float): Specifies element offsets.
%     - JointName (string): String which specifies the element type of 
%         newly created elements. `JointName` can take one of the following 
%         values:
%         '2dFrm': **Description**.
%         '2dTruss': **Description**.
%         ...
%
% ## Output parameters
%     - XYZ (2D: [nn x 2], 3D: [nn x 3]): New node coordinates of meshed model.
%     - CON ([ne x ?]): New element connectivity of meshed model.
%     - ElemName (cell array): New element names of meshed model.
%
%__________________________________________________________________________
%     Preliminary version - 3/13/2020
%__________________________________________________________________________

  %% Control
    sortop='joint'; % This is used to determine the numbering 
                    % scheme for new nodes and elements

    % Defaults
    if size(OFF) == [1 1]
        OFF1 = CON;
        OFF1(:,:) = OFF;
        OFF = OFF1;
    end
    if (nargin<5)
        JointName = 'Lin2dFrm';
    end

    ne = size(CON,1); % scalar; number of existing elements
    nn = size(XYZ,1); % scalar; number of existing nodes

  %% Get direction cosines of elements
    x1 = XYZ(CON(:,1),1);
    y1 = XYZ(CON(:,1),2);
    x2 = XYZ(CON(:,2),1);
    y2 = XYZ(CON(:,2),2);
    L = sqrt((x2-x1).^2 + (y2-y1).^2);
    cs = (x2-x1)./L;
    sn = (y2-y1)./L;
    cs(isnan(cs)) = 0.0; % change any nan values to 0; useful if zero-length elements exist in model
    sn(isnan(sn)) = 0.0;

  %% Identify parent nodes and elements
    idxi = 1:2:2*ne-1;
    idxj = 2:2:2*ne  ;
    %                            1          2          5            6                      7       
    %                           ipe        ipn        i/j          OFF            Angle to parent node
    MESH(idxi,[1,2,5,6,7]) =  [[1:ne]'  CON(:,1)   ones(ne,1)    OFF(:,1)  rad2deg(   acos(cs(:))+(sn(:)<0)*pi)];
    MESH(idxj,[1,2,5,6,7]) =  [[1:ne]'  CON(:,2)  2*ones(ne,1)  -OFF(:,2)  rad2deg(pi+acos(cs(:))-(sn(:)<0)*pi)];
    MESH = MESH(find(MESH(:,6)),:)     % Extract elements with nonzero offsets
    no = size(MESH,1);                 % Number of new elements/joints [int]

  %% Establish numbering of new elements/nodes by sorting MESH
    switch sortop
    case 'joint'
        MESH = sortrows(MESH,[2,7]);
    case 'elem'
        ; % No changes required
    end

  %% Assign new node and element numbers   
    %                 3: ine        4: inn      
    MESH(:,3:4) =  [ ne+[1:no]'   nn+[1:no]' ];

    % Indexing variables used for readability; consider removing
    ipe = MESH(:,1);        % indices of parent element numbers
    ipn = MESH(:,2);        % indices of parent node numbers
    ine = MESH(:,3);        % indices of new element numbers
    inn = MESH(:,4);        % indices of new node numbers

  %% Create new node coordinates
    XYZ(inn,:) = XYZ(ipn,:) + [cs(ipe).*MESH(:,6) sn(ipe).*MESH(:,6)];

  %% Create new elements

    node_mesh = 'jnt' 

    if node_mesh == 'frm'
      CON(ne+1:ne+no,:) = 0; % initialize new connectivity rows
      xx = [ne+no,2];
      lpe_nn = sub2ind(xx,ipe,MESH(:,5));
      lne_pn = sub2ind(xx,ine,MESH(:,5));

      %                       |switch 1s for 2s|
      lne_nn = sub2ind(xx,ine,[~(MESH(:,5)-1)+1]);
      % Assign joint-end of new elements to old nodes
      CON(lne_pn) = CON(lpe_nn);
      % Assign parent-end of new elements to new nodes
      CON(lne_nn) = inn ;
      % Assign parent elements to new nodes
      CON(lpe_nn) = inn;
      [ElemName{ine}] = deal(JointName);
    
    elseif node_mesh == 'jnt'
      CON(ne+1:ne+no,:) = [ 0  0  0  0 ];
      xx = [ne+no,2];
      lpe_nn = sub2ind(xx,ipe,MESH(:,5));
      lne_pn = sub2ind(xx,ine,MESH(:,5));

      %                       |switch 1s for 2s|
      lne_nn = sub2ind(xx,ine,[~(MESH(:,5)-1)+1]);

      % Assign joint-end of new elements to old nodes
      CON(lne_pn) = CON(lpe_nn);

      % Assign parent-end of new elements to new nodes
      CON(lne_nn) = inn ;

      % Assign parent elements to new nodes
      CON(lpe_nn) = inn;

      [ElemName{ine}] = deal(JointName);

    end

    % all4 = true;
    % if all4
    %     % Identify joint types.
    %     jntyp = histcounts(MESH(:,2),nn);
    %     extra = sum(4 - jntyp);
    %     ipne  = find(4-jntyp);
    %     nne = size(ipne,1); % number of new extras
        
    %     MESH(ne+no+1:nne,[1,2,5,6,7]) =  [ne+no+1:nne  ipne'  ones(nne,1)'  ones(nne,1)'*OFF(1,2)  0.0]; % RELATE OFFSET TO COLUMN
    %     MESH = sortrows(MESH,[2,7])
    % end

