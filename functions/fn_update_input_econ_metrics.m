function [sr] = fn_update_input_econ_metrics(k, sim, input, sr, settings)
%Function to calculate input economic metrics for timestep k+1.
%Updated on 4/2/2025: consider changing import.
    
    % Update reconstruction demand
    sr.reconstr_demand_matrix(:,:,k+1) = max(0, sr.reconstr_demand_matrix(:,:,k) - ...
        sr.reconstr_demand_rate(:,:,k+1) .* sr.satisfied_ratio_wHousing(k+1,:)' .* settings.dt);
    sr.reconstr_inv(k+1,:) = transpose(max(0, sum(sr.reconstr_demand_matrix(:,:,k),2)...
        - sum(sr.reconstr_demand_matrix(:,:,k+1),2)));
    sr.reconstr_needs(k+1,:) = sr.reconstr_needs(k,:)- sr.reconstr_inv(k+1,:);

    % Update stock
    sr.stock(:,:,k+1) = sr.stock(:,:,k) + settings.dt*...
        (sr.supply(:,:,k+1)-sr.IO_norm.* repmat(sr.dom_production(k+1,:),input.sectors.N,1));
    sr.stock(:,:,k+1) = max(settings.epsilon,sr.stock(:,:,k+1));
    
    % Update order
    stock_required = repmat(sr.prod_lim_by_cap(k+1,:)-sr.imports_used(k,:),input.sectors.N,1).*...
        sr.IO_norm.*repmat(input.params.n_stock(:,sim)*settings.dt,1,input.sectors.N);

    for i = 1:input.sectors.N
        for j = 1:input.sectors.N
            sr.orders(i,j,k+1) = max(settings.epsilon,sr.production(k+1,j)/sr.production(1,j)*input.IO(i,j)...
                + (sr.long_ST(i,j)-sr.stock(i,j,k+1))/input.params.tau_stock(i,sim));
        end
    end
    
    % Update import
    sr.imports(k+1,:) = input.econ.imports_pre_eq .* input.import_loss.import_fraction_curve(:,k+1)';
    
    % Update overproduction capacity
    sr.scarcity_index(k+1,:) = 1 - sr.satisfied_ratio(k+1,:);
    for i = 1:input.sectors.N
        if sr.scarcity_index(k+1,i) > settings.epsilon
            sr.alpha_prod(i,k+1) = sr.alpha_prod(i,k) + ...
                (input.params.alpha_prod_max(i,sim)-sr.alpha_prod(i,k))* sr.scarcity_index(k+1,i)*settings.dt/input.params.tau_alpha(i,sim);
        else
            sr.alpha_prod(i,k+1) = sr.alpha_prod(i,k) + ...
                (1-sr.alpha_prod(i,k))*settings.dt/input.params.tau_alpha(i,sim);
        end    
    end
    
    % Update loss of productive capital
    for i=1:input.sectors.N
        sr.destr(k+1,i)=sum(sr.reconstr_demand_matrix(i,:,k+1))/sr.assets(i)*input.loss.frac_loss_prod(sim,i);
    end
    
    % Update macro effect
    sr.labor_comp(k+1,:) = sr.labor_comp(1,:).*sr.production(k+1,:)./sr.production(1,:);
    sr.total_labor(k+1) = sum(sr.labor_comp(k+1,:));
    sr.inter_purchases(k+1,:) = sum(sr.IO_norm.* repmat(sr.dom_production(k+1,:),input.sectors.N,1).* repmat(sr.price(k+1,:)',1,input.sectors.N));
    sr.profit(k+1,:) = sr.production(k+1,:) - (sr.inter_purchases(k+1,:) + sr.labor_comp(k+1,:)+ sr.imports_used(k,:))...
         - sr.reconstr_inv(k,1:input.sectors.N)*(1-settings.penetrationf);
    sr.total_profit(k+1) = sum(sr.profit(k+1,:));
    sr.budget(k+1) = sr.budget(k)+ (settings.wage*sr.total_labor(k+1)-settings.wage*sr.total_labor(k)...
        + settings.alpha*(sr.total_profit(k+1) - sr.total_profit(k)));
    sr.macro_effect(k+1) = (sr.DL_initial + 1/settings.tauR * sr.budget(k+1))/sr.DL_initial;

end