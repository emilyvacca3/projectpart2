%deg2km(distance(51, 51, 51.1, 51), "earth")

clear all; close all; clc

disp(pwd)

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

importCache('busspecs', "busspecs",".xlsx")

display(busspecs)
busspecs.value(1)

stopLatitude = []
stopLongitude = []

"strings" + 'can combine'