function [import_loss] = fn_get_import_loss_data(f_name_import, settings, type)
%Function responsible for loading loss data from input file.

switch(type)
    case('no_UQ')
        % Load data from file.
%         employee_loss = load(f_name_employee);
        import_loss.import_fraction_curve = readmatrix(f_name_import,'Range','A2:MV16');
        
        if size(import_loss.import_fraction_curve,2) < settings.Nstep + 1
            import_loss.import_fraction_curve = [import_loss.import_fraction_curve,...
                ones(size(import_loss.import_fraction_curve,1), (settings.Nstep + 1 - size(import_loss.import_fraction_curve,2)))];
        end

    otherwise
        disp("employee loss data type not yet implemented.")

end
