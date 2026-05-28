function [sr] = fn_compute_prod_lim_by_cap(k, sr, input)
%Function to calculate new production capacity.
%Updated on 3/31/2025: consider both damage and labor constraints.
%Updated on 4/2/2025: consider changing import.
    
    % Compute production capacity ratio (compared to pre-event production) due to damage
    sr.capital_product_cap_ratio(k+1,:) = 1 - sr.destr(k,:);
    employee_product_cap_ratio = 1 - input.employee_loss.lost_trip_frac_curve(:,k);
    sr.employee_product_cap_ratio(k+1,:) = employee_product_cap_ratio';
    sr.product_cap_ratio(k+1,:) = min(sr.capital_product_cap_ratio(k+1,:),sr.employee_product_cap_ratio(k+1,:));
    
    % Compute production capacity considering overproduction adaptation
    sr.dom_production_cap(k+1,:) = max(0, sr.alpha_prod(:,k)'.*sr.dom_production(1,:).*sr.product_cap_ratio(k+1,:));
    sr.production_cap(k+1,:) = sr.dom_production_cap(k+1,:) + sr.imports(k,:);
    
    % Compute production limited by capacity by taking the minimum of
    % production capacity and demand
    sr.prod_lim_by_cap(k+1,:) = min(sr.production_cap(k+1,:), sr.demand(k+1,:));
    for i = 1:input.sectors.N
        if sr.demand(k+1,i) > sr.production_cap(k+1,i)
            sr.dom_prod_lim_by_cap(k+1,i) = sr.prod_lim_by_cap(k+1,i) - sr.imports(k,i);
            sr.imports_used(k,i) = sr.imports(k,i);
        else
            sr.dom_prod_lim_by_cap(k+1,i) = sr.prod_lim_by_cap(k+1,i)/sr.production_cap(k+1,i)*sr.dom_production_cap(k+1,i);
            sr.imports_used(k,i) = sr.prod_lim_by_cap(k+1,i)/sr.production_cap(k+1,i)*sr.imports(k,i);
        end
    end
end