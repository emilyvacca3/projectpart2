clear all; close all; clc

dataFolder = fullfile('..',"data");
matFile    = fullfile(dataFolder, "data_project_05.mat");
xlsxFile   = fullfile(dataFolder, "data_project_05.xlsx"); 


if isfile(matFile)
    load(matFile,"data"); % load the matfile into a variable called data
else
    data = readtable(xlsxFile);
    save(matFile, "data"); % cache if we don't have the matfile
end 

latitude = data.gps_0;
longitude = data.gps_1;
speed = data.WheelBasedVehicleSpeed; % speed in m/s
totalDist = data.HighResolutionTotalVehicleDistance; % distance in m (?)

isStopped = abs(speed) < 0.2; % change based on error of speed 
% this gives a list of all rows that either are false or true based on
% whether it matches the speed cutoff
minStop = 5; % how many seconds a bus should not be moving in order to count as a stop

count = 0;
stopLat = [];
stopLon = [];

for i = 1:numel(isStopped)
    if isStopped(i)
        count = count + 1; % if it's true (speed is low enough), increase seconds being still by 1
    else
        if count>= minStop 
            idx = (i-count):(i-1); % rows of the run that ended
            stopLat(end+1) = mean(latitude(idx)); % just take the average from that range while it was stopped
            stopLon(end+1) = mean(longitude(idx));
        end
    count = 0;
    end
end

geoplot(latitude,longitude,"-","LineWidth",2,"DisplayName","Bus route")
hold on 
geoscatter(stopLat,stopLon,"filled","red")
geobasemap streets
title("My data points")
legend
