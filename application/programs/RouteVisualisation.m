clear all; close all; clc

disp(pwd)

%Load bus data
scriptDir  = fileparts(mfilename('fullpath'));
dataFolder = fullfile(scriptDir, '..', 'data');

if ~isfolder(dataFolder)                  % catches the Temp\Editor_... path
    dataFolder = fullfile('..', 'data');
end

matFile  = fullfile(dataFolder, 'data_project_05.mat');
xlsxFile = fullfile(dataFolder, 'data_project_05.xlsx');

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

stopLatitude = data.stop_lat;
stopLongitude = data.stop_lon;

arrowLocations = [];
arrowStep = 600;

arrowLocations = 1:arrowStep:height(data)-1;

function plot_arrow_geoplot(begin_point,end_point,varargin) % source: [1] 

if ~(isvector(begin_point) && length(begin_point)==2)
    error('begin_point is not a 2D vector') 
end

if ~(isvector(end_point) && length(end_point)==2)
    error('end_point is not a 2D vector') 
end

begin_point = begin_point(:)';
end_point = end_point(:)';

pivot_x = end_point(1);
pivot_y = end_point(2);

theta = 20;

px = begin_point(1);
py = begin_point(2);

s = sind(theta);
c = cosd(theta);

px = (px - pivot_x)*0.4;
py = (py - pivot_y)*0.4;

xnew = px * c - py * s;
ynew = px * s + py * c;

px = xnew + pivot_x;
py = ynew + pivot_y;

theta = -20;

px2 = begin_point(1);
py2 = begin_point(2);

s = sind(theta);
c = cosd(theta);

px2 = (px2 - pivot_x)*0.4;
py2 = (py2 - pivot_y)*0.4;

xnew = px2 * c - py2 * s;
ynew = px2 * s + py2 * c;

px2 = xnew + pivot_x;
py2 = ynew + pivot_y;

% plot
geoplot([begin_point(1) end_point(1)],[begin_point(2) end_point(2)],... % line
    [px end_point(1)],[py end_point(2)],... % arrow end first part
    [px2 end_point(1)],[py2 end_point(2)],varargin{:}) % arrow end second part

end

pointa = [latitude(1) longitude(1)]
pointb = [latitude(6000) longitude(6000)]
plot_arrow_geoplot(pointa,pointb,'color','r',"LineWidth",3)
hold on 
geoplot(latitude,longitude,"k-","LineWidth",2,"DisplayName","Bus route")
hold on 
%geoscatter(stopLat,stopLon,"filled","red")
geoscatter(stopLatitude,stopLongitude,"*","red")
geobasemap streets
title("My data points")
legend
