function Model = Model_PlaneArch(ne,L,H)

    % span and height of the arch
    if nargin <3, H= 5; end
    if nargin <2, L=20; end

    nn = ne+1;     % number of nodes

    % coordinate generation for parabolic profile
    Xn = linspace(0,L,nn);
    Yn = (1-Xn./L).*(Xn./L).*(4*H);
    XYZ(1:nn,:) = [Xn' Yn'];
    % connectivity generation
    CON(1:ne,:) = [(1:nn-1)' (2:nn)'];

    % boundary conditions (1 = restrained,  0 = free) (specify only restrained dof's)
    BOUN(1, :)  = [1 1];
    BOUN(nn,:)  = [1 1];

    % specify element type
    [ElemName{1:ne}] = deal('Truss');     % truss element

    % create model
    Model = Create_SimpleModel(XYZ,CON,BOUN,ElemName);
end