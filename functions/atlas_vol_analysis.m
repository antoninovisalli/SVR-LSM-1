function [atlas_aal_roi, atlas_ba_roi] = atlas_vol_analysis(parameters, variables, beta_map, threshold)

    beta_map(find(abs(beta_map)<=threshold)) = 0;
    beta_map = remove_scatter_clusters(beta_map, parameters.min_cluster_size);

    mask_idx = find(beta_map>threshold);
    [atlas_aal_roi.pos, atlas_ba_roi.pos] = get_significant_roi(variables, mask_idx);
    mask_idx = find(beta_map<-1*threshold);        
    [atlas_aal_roi.neg, atlas_ba_roi.neg] = get_significant_roi(variables, mask_idx);

    % output the AAL atlas area name and significant voxel number for highlited ROIs
    fid = fopen(variables.atlas_aal_roi_filename, 'w');
    fprintf(fid, '============ Positive clusters ============= Threshold: %7.4f\n', threshold);
    if(size(atlas_aal_roi.pos,1) == 0)
        fprintf(fid, '\nNone\n');
    else
        fprintf(fid, 'index | %15s    | \t voxel number\n', 'atlas_name');
        for ni=1:size(atlas_aal_roi.pos,1)
            fprintf(fid, ' %3d, %20s, %6d out of %6d voxels\n', atlas_aal_roi.pos(ni,1), variables.atlas_aal.name{atlas_aal_roi.pos(ni,1)}, atlas_aal_roi.pos(ni,2), atlas_aal_roi.pos(ni,3));
        end
    end
    fprintf(fid, '\n============ Negative clusters ============= Threshold: %7.4f\n', -1*threshold);
    if(size(atlas_aal_roi.neg,1) == 0)
        fprintf(fid, '\nNone\n');
    else
        fprintf(fid, 'index | %15s    | \t voxel number\n', 'atlas_name');
        for ni=1:size(atlas_aal_roi.neg,1)
            fprintf(fid, ' %3d, %20s, %6d out of %6d voxels\n', atlas_aal_roi.neg(ni,1), variables.atlas_aal.name{atlas_aal_roi.neg(ni,1)}, atlas_aal_roi.neg(ni,2), atlas_aal_roi.neg(ni,3));
        end 
    end
    
    if(~isempty(variables.exclude_idx))
        fprintf(fid, '*******************************************************************\n');
        fprintf(fid, 'Warning: The following subjects have been excluded from analysis because they have no survival voxel after thresholding, \n');
        for(ni=1:length(variables.exclude_idx))
            fprintf(fid, '%s \n', variables.excluded_SubjectID{ni});
        end

    end
    fclose(fid);

    % output the Brodmann Area name and significant voxel number for highlited ROIs
    fid = fopen(variables.atlas_ba_roi_filename, 'w');
    fprintf(fid, '============ Positive clusters ============= Threshold: %7.4f\n', threshold);
    if(size(atlas_ba_roi.pos,1) == 0)
        fprintf(fid, '\nNone\n');
    else
        fprintf(fid, 'index | voxel number\n', 'atlas_name');
        for ni=1:size(atlas_ba_roi.pos,1)
            fprintf(fid, ' %3d, %6d out of %6d voxels\n', atlas_ba_roi.pos(ni,1), atlas_ba_roi.pos(ni,2), atlas_ba_roi.pos(ni,3));
        end
    end
    fprintf(fid, '\n============ Negative clusters ============= Threshold: %7.4f\n', -1*threshold);
    if(size(atlas_ba_roi.neg,1) == 0)
        fprintf(fid, '\nNone\n');
    else
        fprintf(fid, 'index | voxel number\n', 'atlas_name');
        for ni=1:size(atlas_ba_roi.neg,1)
            fprintf(fid, ' %3d, %6d out of %6d voxels\n', atlas_ba_roi.neg(ni,1), atlas_ba_roi.neg(ni,2), atlas_ba_roi.neg(ni,3));
        end 
    end
    
    if(~isempty(variables.exclude_idx))
        fprintf(fid, '*******************************************************************\n');
        fprintf(fid, 'Warning: The following subjects have been excluded from analysis because they have no survival voxel after thresholding, \n');
        for(ni=1:length(variables.exclude_idx))
            fprintf(fid, '%s \n', variables.excluded_SubjectID{ni});
        end
        
    end
    
    fclose(fid);        
    
end

