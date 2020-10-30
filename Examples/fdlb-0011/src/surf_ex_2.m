path_add;

% Control
CleanStart
nIP = 30;            % No. of integration points
IntTyp = 'Midpoint'; % Section integration rule
LoadOpt = 4;         % Load history patter no.
plotOpt = false;     % Turn problem plots on/off

% Analysis
output = Hw12P1B2(nIP,IntTyp,LoadOpt,plotOpt,false);
Post = output('Post');

nstep = size(Post,2);
for i=1:nstep
    close all
    Create_Window(0.8, 0.7);
    MatState = Post(i).Elem{1}.Sec{1}.Mat;
    plot_evol( output('SecData'), MatState )
    saveas(gcf, sprintf('PathOABCO-n30/pB1n%ds%02d.png',nIP,i));
end
