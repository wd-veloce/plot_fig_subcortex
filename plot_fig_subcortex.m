function plot_fig_subcortex(file_path, output_plot_path, colormap, min_scale, max_scale, structure_label)
% Visualizing subcortex
% Author: Xinyu Wu and Guoyuan Yang, BIT.
% 
% Inputs:
%     - file_path
%       Path of files to be plot, must be nifti format files with MNI152 2mm standard voxel space(109*91*91).
% 
%     - output_plot_path
%       Path to save figures, we recommend to save a png file.
%       It depends on the project export_fig.
%       about export_fig, please see: https://github.com/altmany/export_fig
% 
%     - colormap
%       A n*3 matrix contains RGB color.
%       This project has already contains project slanCM which contains numerous colormaps.
%       about slanCM, please see: https://github.com/slandarer/slanColor
% 
%     - max_scale
%       upper threshold to control the color to be plot.
% 
%     - min_scale
%       lower threshold to control the color to be plot.
%       
%     - structure_label
%       label number to be showed, using labels defined in the FreeSurfer and contained in 'Atlas_ROIs.2.nii.gz'.
%       structure label could be found in:
%           https://surfer.nmr.mgh.harvard.edu/fswiki/FsTutorial/AnatomicalROI/FreeSurferColorLUT.
%       useful infomations:
%           thalamus_label = [10, 49];
%           hippocampus_label = [17, 53];
%           cerebellum_label = [8, 47];
%           striatum_label = [11, 12, 13, 26, 50, 51, 52, 58];
%           all_subcortex_label = [8, 10, 11, 12, 13, 16, 17, 18, 26, 28, 47, 49, 50, 51, 52, 53, 54, 58, 60];

[basepath, ~, ~] = fileparts(which("plot_fig_subcortex"));

addpath(fullfile(basepath, 'dependencies', 'export_fig'));

file = MRIread(file_path);

rois = MRIread(fullfile(basepath, 'rois', 'Atlas_ROIs.2.nii.gz'));

roi_pos = find(rois.vol);
for i = 1: length(roi_pos)
    if ~ismember(rois.vol(roi_pos(i)), structure_label)
        rois.vol(roi_pos(i)) = 0;
    end
end
roi_pos = find(rois.vol);

posx = zeros(length(roi_pos), 1);
posy = zeros(length(roi_pos), 1);
posz = zeros(length(roi_pos), 1);
color = zeros(length(roi_pos), 3);

scatter_size = 50;

for i = 1: length(roi_pos)
    [tmpx, tmpy, tmpz] = ind2sub([109, 91, 91], roi_pos(i));
    posx(i) = tmpx; posy(i) = tmpy; posz(i) = tmpz;

    if file.vol(roi_pos(i)) <= max_scale && file.vol(roi_pos(i)) > min_scale
        val = file.vol(roi_pos(i));
    elseif file.vol(roi_pos(i)) <= min_scale
        val = min_scale + eps;
    elseif file.vol(roi_pos(i)) > max_scale
        val = max_scale;
    end
        
    color(i, :) = colormap(ceil((val-min_scale)/(max_scale-min_scale) * 256), :);
end

figure;
scatter3(posx, posy, posz, scatter_size, color, 'filled');

% Adjusting figure to get better visualization
axis equal; axis vis3d;
% Adjusting figure size.
set(gcf, 'Position', [0, 0, 800, 800]);
% Hidding the axis.
set(gca, 'xticklabel', []); set(gca, 'yticklabel', []); set(gca, 'zticklabel', []);
set(gca, 'xtick', [], 'ytick', [], 'ztick', [], 'xcolor', 'w', 'ycolor', 'w', 'zcolor', 'w', 'Visible', 0);
% Setting background transparent.
set(gca, 'color', 'none'); set(gcf, 'color', 'none');

% Moving the camera position and angel to get better visualization.
% Recommendations:
%   for hippocampus and thalamus:
%       camorbit(95, -8, 'data', [0, 0, 1]);
%   for striatum:
%       camorbit(102, -2, 'data', [0, 0, 1]);
camorbit(102, -2, 'data', [0, 0, 1]);

% Detailed usage of export_fig, please see: https://github.com/altmany/export_fig
% '-m4' and '-q100' are used for sufficient figure quality.
% for better quality, try '-m10' and '-q100', but it would be slow to generate.
export_fig(output_plot_path, '-m4', '-q100');

end