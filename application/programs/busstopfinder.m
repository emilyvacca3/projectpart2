clear all; close all; clc

disp(pwd)

scriptDir  = fileparts(mfilename('fullpath'));
dataFolder = fullfile(scriptDir, '..', 'data');

if ~isfolder(dataFolder)                  % catches the Temp\Editor_... path
    dataFolder = fullfile('..', 'data');
end

matFile  = fullfile(dataFolder, 'busstopssimple.mat');
xlsxFile = fullfile(dataFolder, 'busstopssimple.xlsx');

if isfile(matFile)
    load(matFile,"data"); % load the matfile into a variable called data
else
    data = readtable(xlsxFile);
    save(matFile, "data"); % cache if we don't have the matfile
end 

latitude = data.stop_lat;
longitude = data.stop_lon;

geoscatter(latitude,longitude,"red",".")
geobasemap streets
title("My data points")
legend