function [recovery] = fn_get_recovery(f_name, settings, type)
%Function responsible for loading economic data from input file.

switch(type)
    case('no_UQ')
        % Load data from file.
        recovery     = load(f_name);

    otherwise
        disp("recovery data type not yet implemented.")

end
