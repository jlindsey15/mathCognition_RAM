%% generate some training examples
% the image has only one object, the ram agent needs to learn to fixate at 
% that object
clear variables; clf; 

% high level parameters
numImages = 700;              % the number of output images 

param.showImg = 0;          % display a sample image 
param.saveImg = 0;          % same the image 
param.saveStruct = 1;       % save the matrix representation 
imgName = 'fourObj_realistic';
% imgName = 'oneObj';
% imgName = 'oneObj_big';
param.saveDir = strcat('../../datasets/', imgName);

%% set simulation parameters 
% prototype: all objects are "centered" and aligned
% randomVec: each object is translated by a random vector
% allPoss: UNDER CONSTRUCTION
allPatterns = {'prototype', 'randomVec', 'allPoss'};
param.pattern = allPatterns{2};

alignmentPatterns = {'left', 'center'};
param.alignment = alignmentPatterns{2};

param.max_obj_num = 4; 
param.obj_radius = 4;       % size of the object 
param.varySize = 0;         % random radius for object 

param.frame_ver = 60;       % the length of the image
param.frame_hor = 60;       % the height of the image
param.frame_boundary = param.obj_radius * 2;    % space to the boundary of img
param.frame_space = param.obj_radius * 3.5;       % space in between objects

param.distortion_x = param.obj_radius * 1; % magnitude of distortion
param.distortion_y = param.obj_radius * 1;
noise_allDistributions = {'elliptical', 'rectangular'};
param.frame_randVecDistribution = noise_allDistributions{2};

param.supervised = true; 

numObj_allDistributions = {'uniform', 'realistic', 'fixed'};
param.numObj_sampling = numObj_allDistributions{2};
% param.staticNumObj = 4; 

%% generate images 
checkParameters(param)
for n = 1 : numImages
    % generate the number of objects randomly 
    if strcmp(param.numObj_sampling, 'realistic')
        param.obj_num = generateNum(param.max_obj_num);
    elseif strcmp(param.numObj_sampling, 'uniform')
        param.obj_num = randsample(param.max_obj_num,1,true);
    elseif strcmp(param.numObj_sampling, 'fixed')
        param.obj_num = param.staticNumObj; 
    end
    % param.obj_num = 5;          % number of objects
    
    param.imgName = sprintf('%s%.3d', imgName, n);
    % generate the image!
    genTrainExp(param);
end

%% write a parameter file 
filename = fullfile(param.saveDir,'paramRecord.txt');
fileID = fopen(filename,'w');
writeParam(fileID, param)
fclose(fileID);