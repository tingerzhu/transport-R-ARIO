function [params] = fn_get_behavorial_parameters(input, settings, type)
%Function responsible for loading behavorial parameters from input file.
    
    % Load default sector-specific parameter settings from file       
      default_alpha_max     = readtable(fullfile('inputs','default_alpha_max.csv'));
      default_inventory     = readtable(fullfile('inputs','default_inventory.csv'));
      default_psi           = readtable(fullfile('inputs','default_psi.csv'));
      default_tau_alpha     = readtable(fullfile('inputs','default_tau_alpha.csv'));
      default_tau_inventory = readtable(fullfile('inputs','default_tau_inventory.csv'));
   
   % Initialize each variable    
      params.alpha_prod_max = zeros(input.sectors.N, settings.n_sim); 
      params.n_stock        = zeros(input.sectors.N, settings.n_sim); 
      params.psi            = zeros(input.sectors.N, settings.n_sim); 
      params.tau_alpha      = zeros(input.sectors.N, settings.n_sim); 
      params.tau_stock      = zeros(input.sectors.N, settings.n_sim); 
      
    switch(type)
        case('UQ_tr_norm')
            params = fn_sample_param_truncated_norm(input, ...
                                                 params, ...
                                                 settings.n_sim, ...
                                                 default_alpha_max, ...
                                                 default_inventory, ...
                                                 default_psi, ...
                                                 default_tau_alpha ./ 12, ...
                                                 default_tau_inventory ./365) 
        case('mean')
              params.alpha_prod_max = ones(input.sectors.N, settings.n_sim) .* default_alpha_max.mean; 
              params.n_stock        = ones(input.sectors.N, settings.n_sim) .* default_inventory.mean; 
              params.psi            = ones(input.sectors.N, settings.n_sim) .* default_psi.mean; 
              params.tau_alpha      = ones(input.sectors.N, settings.n_sim) .* default_tau_alpha.mean ./ 12; 
              params.tau_stock      = ones(input.sectors.N, settings.n_sim) .* default_tau_inventory.mean ./365; 

end
