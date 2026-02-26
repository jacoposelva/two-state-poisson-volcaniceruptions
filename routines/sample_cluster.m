function tout = sample_cluster(lambda_cl,iet_thr)
%    ntrials = round( (50 / lambda_cl) / 1000) * 1000; 
    ntrials = round( (500 / lambda_cl) / 1000) * 1000; % corr 02/07/2025

    iettmp = [0 exprnd(1/lambda_cl,1,ntrials)];
    isel1=find(iettmp(:)>iet_thr,1);
    tout=cumsum(iettmp(1:isel1-1));
    if isempty(tout)
        while isempty(tout)
            ntrials = ntrials*10; 

            iettmp = exprnd(1/lambda_cl,1,ntrials);
            isel1=find(iettmp(:)>iet_thr,1);
            tout=cumsum(iettmp(1:isel1-1));
%            disp(['increasing ntrials = ' num2str(ntrials)]);
        end
    elseif length(tout) > 1
        tout=tout(2:end);
    else
        tout=[];        
    end
    
end
