% Demo for showing how to use plot_fig_subcortex
% Author: Xinyu Wu and Guoyuan Yang, BIT.

% dependecy: FreeSurfer MRIread functions.

% File must be MNI152 2mm voxel space with size of 109*91*91.
demo_file = fullfile('demo_file', 'HCP_group_principle_functional_gradient.nii.gz');

% Output file path
% We recommend generating .png file.
demo_output = fullfile('demo_file', 'demo_HCP_group_pFG_striatum.png');

% Colormap
%       this project includes slanCM project. 
%       For its detailed usage, please see: https://github.com/slandarer/slanColor
addpath(fullfile('dependencies', 'slanCM'));
colormap = slanCM(1, 256); % Colormap Viridis.

% Scales
min_scale = -1.5e-4;
max_scale = 1e-4;

% Structure labels
%       label number to be showed, using labels defined in the FreeSurfer and contained in 'Atlas_ROIs.2.nii.gz'.
%       structure label could be found in:
%           https://surfer.nmr.mgh.harvard.edu/fswiki/FsTutorial/AnatomicalROI/FreeSurferColorLUT.
%       useful infomations:
%           thalamus_label = [10, 49];
%           hippocampus_label = [17, 53];
%           cerebellum_label = [8, 47];
%           striatum_label = [11, 12, 13, 26, 50, 51, 52, 58]; Left and right Caudate, Putamen, Pallidum and Accumbens.
%
%           all_subcortex_label = [8, 10, 11, 12, 13, 16, 17, 18, 26, 28, 47, 49, 50, 51, 52, 53, 54, 58, 60];
striatum_label =  [11, 12, 13, 26, 50, 51, 52, 58];

% Generating the figure file would be time consuming, please wait.
plot_fig_subcortex(demo_file, demo_output, colormap, min_scale, max_scale, striatum_label);

