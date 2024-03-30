clear; close all; clc
M = readmatrix("data\sol_100.dat");
vidfile = VideoWriter('testmovie.mp4','MPEG-4');
open(vidfile);

arrsize = 100;
for i = 1:size(M, 1)
imagesc(reshape(M(i,:), [arrsize arrsize])')
writeVideo(vidfile, getframe(gcf));
end 

close(vidfile);

M = readmatrix("data\sol_100_sparky.dat");
vidfile = VideoWriter('testmovie_spark.mp4','MPEG-4');
open(vidfile);

arrsize = 100;
for i = 1:size(M, 1)
imagesc(reshape(M(i,:), [arrsize arrsize])')
writeVideo(vidfile, getframe(gcf));
end 

close(vidfile);