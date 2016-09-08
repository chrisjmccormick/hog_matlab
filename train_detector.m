
addpath('./common/');
addpath('./svm/');
addpath('./svm/minFunc/');

%%
% Load all training windows and get their HOG descriptors.

% Get the list of all images in the directory.
posFiles = getImagesInDir('./Images/Training/Positive/', true);
negFiles = getImagesInDir('./Images/Training/Negative/', true);

% Create the category labels.
y_train = [ones(length(posFiles), 1); zeros(length(negFiles), 1)];

% Combine the file lists to get a list of all training images.
fileList = [posFiles, negFiles];

% Build a matrix of all of the descriptors, one per row.
X_train = zeros(length(fileList), 3780);

fprintf('Computing descriptors for %d training windows: ', length(fileList));
		
% For all training window images...
for i = 1 : length(fileList)

    % Get the next filename.
    imgFile = char(fileList(i));

    % Print the current iteration (using some clever formatting to
    % overwrite).
    printIteration(i);
    
    %fprintf('%s\n', imgFile);
    % Load the image into a matrix.
    img = imread(imgFile);
    
    % Calculate the HOG descriptor for the window.
    H = getHOGDescriptor(img);
    
    % Add the descriptor to the rest.
    X_train(i, :) = H';
end

fprintf('\n');

%%
% Train the SVM
fprintf('\nTraining linear SVM classifier...\n');
theta = train_svm(X_train, y_train, 1.0);

% Evaluate the SVM over the training data.
p = X_train * theta;

% Recognize as a pedestrian if the confidence is over 0.
numRight = sum((p > 0) == y_train);

fprintf('\nTraining accuracy: (%d / %d) %.2f%%\n', numRight, length(y_train), numRight / length(y_train) * 100.0);

