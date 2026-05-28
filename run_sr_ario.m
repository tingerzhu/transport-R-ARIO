function [sr] = run_sr_ario(input, settings)
%
% Inputs:
%           input (sectors, IO, econ, loss, recovery, params)
%           settings (n_sim, st, NStep)
% Output:
%           output (TEMP: sr)

    for sim = 1:settings.n_sim

        tic 

        %% Load_default_ARIO_model_settings 
            % Load default analysis settings
            [settings]     = fn_load_default_ario_settings(input, settings);

        %% Initialize storage containers 
            [sr]           = fn_initialize_sr_variables(input, settings, sim);

        %% Main loop
            disp('Start simulation');
            for k = 1:settings.Nstep
                if (mod(k,1/settings.dt)>=1/settings.dt-1) % every year
                  disp(strcat('year:',int2str(round(k*settings.dt*365)/365),' completed'));
                end
                %% Stage 1: get_production
                % Purpose of this stage: leverage (i) demand, (ii)production capacity, and
                % (iii) supply constraints to generate actual production for each time
                % step

                % Compute demand 
                [sr] = fn_compute_demand(k, input, sr, settings);

                % Impose constraint 1: production capacity 
                [sr] = fn_compute_prod_lim_by_cap(k, sr, input);

                % Impose constraint 2: supply 
                [sr] = fn_compute_prod_lim_by_cap_sup(k, sim, input, sr, settings);

                %% Stage 2: calculate result economic metrics and update for next time step
                % Purpose of this stage: leverage satisfied ratio (production/demand) 
                % to compute (i) output economic metrics for timestep k,
                % (ii) input economic metrics for timestep k+1, and (iii)
                % output economic performance for timestep k

                sr.satisfied_ratio(k+1,:) = sr.production(k+1,:) ./ sr.demand(k+1,:);
                sr.satisfied_ratio_wHousing(k+1,:) = [sr.satisfied_ratio(k+1,:) sr.satisfied_ratio(k+1,input.construction_idx)];

                % Calculate the output economic metrics for timestep k 
                [sr] = fn_get_output_econ_metrics(k, input, sr);

                % Update the input economic metrics for timestep k+1
                [sr] = fn_update_input_econ_metrics(k, sim, input, sr, settings);
                
                % Calculate the output economic performance for timestep k 
                [sr] = fn_get_output_econ_performance(k, input, sr);

            end

        toc
    end

end