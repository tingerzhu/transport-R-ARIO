function [sr] = fn_get_output_econ_performance(k, input, sr)
%Function to calculate output economic performance for timestep k.
%Updated on 4/2/2025: consider changing export.
    
    % Calculate value added
    sr.value_added(k+1,:) = sr.production(k+1,:) - sr.imports_used(k,:)...
        - sum(sr.IO_norm.* repmat(sr.dom_production(k+1,:),input.sectors.N,1),1);
    
    
end