%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   Adapted R-ARIO model for transport-economic interdependencies analysis
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Clean up MATLAB workspace
clc; clear all; close all;

%% Main analysis settings

    settings.n_sim   = 1;
    settings.dt      = 1/365;
    settings.Nstep   = round(10/settings.dt+1);
    settings.epsilon = 1.e-6;
    settings.t       = 0:settings.dt:settings.Nstep*settings.dt;

%% Enter path settings

    f_name.IO       = "IO.mat";
    f_name.econ     = "econ.mat";
    f_name.loss     = "loss.mat";
    f_name.sectors  = "sectors.csv";
    f_name.recovery = "recovery.mat";
    f_name.employee = "labor_loss_curve.csv";
    f_name.export   = "export_reduction.csv";
    f_name.import   = "import_reduction.csv";

addpath inputs
addpath functions

%% Load analysis input parameters/data

    % get_sectors
        input.sectors  = fn_get_sectors(f_name.sectors);
        input.construction_idx = 4; % manually identified the index for construction sector
        input.manufacturing_idx = 5;
        
    % get_IO_data
        input.IO       = fn_get_IO_data(f_name.IO);
    
    % get_economic_data
        input.econ     = fn_get_economic_data(f_name.econ, settings, 'no_UQ');
    
    % get_loss_data
        input.loss          = fn_get_loss_data(f_name.loss, settings, 'no_UQ');
        input.employee_loss = fn_get_employee_loss_data(f_name.employee, settings, 'no_UQ');
        input.export_loss   = fn_get_export_loss_data(f_name.export, settings, 'no_UQ');
        input.import_loss   = fn_get_import_loss_data(f_name.import, settings, 'no_UQ');
    
    % get_t95_data or get_emp_recovery_curves
        input.recovery = fn_get_recovery(f_name.recovery, settings, 'no_UQ');
    
    % get_behavorial_parameters
        input.params   = fn_get_behavorial_parameters(input, settings, 'mean');
    
    
%% Run single_region_ARIO function

    sr = run_sr_ario(input, settings);

    % save results to file
    save('output/sr_ario_results.mat', 'sr', 'input', 'settings');
       