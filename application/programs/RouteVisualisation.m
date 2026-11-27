clear all; close all; clc

disp(pwd)

gendetailedmap = false %do not set to true. Your pc will run forever.

function importCache(filename, variableName, fileExtension, refreshFiles)

arguments
    filename
    variableName
    fileExtension = ".xlsx"
    refreshFiles = false
end

scriptDir  = fileparts(mfilename('fullpath'));
dataFolder = fullfile(scriptDir, '..', 'data');

if ~isfolder(dataFolder)                  % catches the Temp\Editor_... path
    dataFolder = fullfile('..', 'data');
end

matFile  = fullfile(dataFolder, filename + ".mat");
xlsxFile = fullfile(dataFolder, filename + fileExtension);

if isfile(matFile) && ~refreshFiles
    data = load(matFile, variableName);
    assignin("base", variableName, data.(variableName))
else
    val = readtable(xlsxFile);
    assignin('base', variableName, val);

    S.(variableName) = val;
    save(matFile, '-struct', 'S');
end 
end


importCache("data_project_05", "data")
latitude = data.gps_0;
longitude = data.gps_1;
speed = data.WheelBasedVehicleSpeed; % speed in m/s
totalDist = data.HighResolutionTotalVehicleDistance; % distance in m (?)

importCache("busstopssimple", "stops");
stopLatitude = stops.stop_lat;
stopLongitude = stops.stop_lon;

importCache('busspecs', "busspecs");
buslength = busspecs.value(1);


isStopped = abs(speed) < 0.2; % change based on error of speed 
% this gives a list of all rows that either are false or true based on
% whether it matches the speed cutoff
minStop = 5; % how many seconds a bus should not be moving in order to count as a stop

count = 0;
stopLat = [];
stopLon = [];

%I want to check which bus stops the bus runs by. 
% I saw that the bus does not stop at every bus stop. 
% Do we do this per stopped bus stop + manual?
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

onRouteStopsLat = [];
onRouteStopsLon = [];

if gendetailedmap;
    for i = 1:3:numel(isStopped);
        for j = 1:numel(stopLatitude);
            if 1000*deg2km(distance(stopLatitude(j), stopLongitude(j), latitude(i), longitude(i)), "earth") < 6
                onRouteStopsLat(end+1) = stopLatitude(j);
                onRouteStopsLon(end+1) = stopLongitude(j);
            end
        end
    end
end

display(onRouteStopsLon)

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
geoscatter(stopLat,stopLon,"filled","red")
geoscatter(stopLatitude,stopLongitude,"*","green")
geobasemap streets
title("My data points")
legend
