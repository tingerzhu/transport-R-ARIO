function [employee_loss] = fn_get_employee_loss_data(f_name_employee, settings, type)
%Function responsible for loading loss data from input file.

switch(type)
    case('no_UQ')
        % Load data from file.
%         employee_loss = load(f_name_employee);
        employee_loss.lost_trip_frac_curve = readmatrix(f_name_employee,'Range','B2:KO16');
        
        if size(employee_loss.lost_trip_frac_curve,2) < settings.Nstep
            employee_loss.lost_trip_frac_curve = [employee_loss.lost_trip_frac_curve,...
                zeros(size(employee_loss.lost_trip_frac_curve,1), (settings.Nstep - size(employee_loss.lost_trip_frac_curve,2)))];
        end

    otherwise
        disp("employee loss data type not yet implemented.")

end
