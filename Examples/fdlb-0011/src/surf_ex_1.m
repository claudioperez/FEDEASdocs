% path_add;

% Control
CleanStart
nIP = 10;            % No. of integration points
IntTyp = 'Midpoint'; % Section integration rule
LoadOpt = 3;         % Load history patter no.
plotOpt = true;      % Turn problem plots on/off
t = [ 1, 13 ];

% Analysis
output = Hw12P1B2(nIP,IntTyp,LoadOpt,plotOpt,false);
Post = output('Post');

Create_Window(0.8, 0.8);
MatState = Post(t(1)).Elem{1}.Sec{1}.Mat;
plot_evol( output('SecData'), MatState )
saveas(gcf, sprintf('pB1n%ds%02d.png',nIP,t(1)));

Create_Window(0.8, 0.8);
MatState = Post(t(2)).Elem{1}.Sec{1}.Mat;
plot_evol( output('SecData'), MatState )
saveas(gcf, sprintf('pB1n%ds%02d.png',nIP,t(2)));
