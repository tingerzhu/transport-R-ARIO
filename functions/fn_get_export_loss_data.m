function [export_loss] = fn_get_export_loss_data(f_name_export, settings, type)
%Function responsible for loading loss data from input file.

switch(type)
    case('no_UQ')
        % Load data from file.
%         employee_loss = load(f_name_employee);
        export_loss.export_fraction_curve = readmatrix(f_name_export,'Range','A2:MV16');
        
        if size(export_loss.export_fraction_curve,2) < settings.Nstep
            export_loss.export_fraction_curve = [export_loss.export_fraction_curve,...
                ones(size(export_loss.export_fraction_curve,1), (settings.Nstep - size(export_loss.export_fraction_curve,2)))];
        end

    otherwise
        disp("employee loss data type not yet implemented.")

end
