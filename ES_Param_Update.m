function [ new_pars ] = ES_Param_Update(pars,low_lims,high_lims,cost,w,k,alpha,dt,step)

% The inputs to this function are
% Current parameter settigs:            pars
% Lower limits on parameter settings:   low_lims
% Upper limits on parameter settings:   high_lims
% Current cost function value:          cost
% Parameter dithering frequencies:      w
% Parameter feedback gains:             k
% Parameter dithering amplitudes:       alpha
% ES time scale:                        dt
% Iterative step number:                step

% Calculate number of parameters being updated
npar=length(pars);

% Create vector of new paramter values
new_pars=zeros(1,npar);

% Step through each parameter and update based on cost
for j=1:npar;
    new_pars(j)=pars(j)+dt*(alpha(j)*w(j))^0.5*cos(w(j)*step*dt+k(j)*cost);
    % Check that upper bounds are satisfied
    if new_pars(j) > high_lims(j);
        new_pars(j) = high_lims(j);
    end
    % Check that lower bounds are satisfied
    if new_pars(j) < low_lims(j);
        new_pars(j) = low_lims(j);
    end
end



end

