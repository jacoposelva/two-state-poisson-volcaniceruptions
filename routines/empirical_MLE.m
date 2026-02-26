function MLE_results = empirical_MLE(info)

    figYN=false;
    refvol = info.name_files;

    %% parametri ricerca
    cluster_4lambda = [info.cluster.use4lambdaYN];
    cluster_nev = [info.cluster.nev];
    cluster_len = [info.cluster.len];    
    
    nsample = 10000;
    dtmax=min(info.repose_times); % tau massimo
%    dtmin = round(max(cluster_len / cluster_nev)/10)*10;       
    dtmin = round(max(cluster_len ./ cluster_nev)/100)*100;  % corr 02/07/2025     
    dt1 = max(round((dtmax-dtmin)/30),1);
    
    
%     dtmax=min(info.repose_times); % tau massimo
%     dtmin = round(max([info.cluster.len]./[info.cluster.nev])/5)*5;    
%     dt1=round((dtmax-dtmin)/30); % ricerca grossolana fine
    dt2=dt1/5; % ricerca fine
    %dtmax=150; % tau massimo
    iet_thr1 =dtmin:dt1:dtmax; 
    nsamples1 = 50000;
    nsamples2 =100000;


    %%
    cluster_lengths = [info.cluster.len];
    cluster_nev = [info.cluster.nev]-1;
    cluster_4lambda = [info.cluster.use4lambdaYN];

    
    
    originalYN = true;
    
    if originalYN
        %% ROUGH SEARCH
        %LL1=try_ietthr_singlepar(iet_thr1,nsamples1,l_cl,cluster_lengths,figYN);
        [LL LLmax par]=try_ietthr_singlepar_corr(iet_thr1,nsamples1,cluster_nev,cluster_lengths,cluster_4lambda,figYN);
        LL1 = LL;

        %fun =@(par) -1*try_ietthr_singlepar(par,nsamples1,l_cl,cluster_lengths);
        %xmin = fminsearch(fun,200)


        tmp = find(LL1>max(LL1)- 1.32/2); % 50% interval, ch2 with 1 degree of freedom     
        iet_thr2 = iet_thr1(tmp(1)-1)+dt2:dt2:iet_thr1(tmp(end)+1)-dt2;
        %LL2=try_ietthr_singlepar(iet_thr2,nsamples2,l_cl,cluster_lengths,figYN);
        [LL LLmax par]=try_ietthr_singlepar_corr(iet_thr2,nsamples2,cluster_nev,cluster_lengths,cluster_4lambda,figYN);
        LL2 = LL;

        [LLmax isel]=max(LL2);
        iet_thr_MLE = iet_thr2(isel);
    else
        pickArea = -1;
        [LL1 LLmax par iet_thr1]= LL_fromSampling(info,pickArea);
        [tmp ipos]=max(LL1);
        pickArea = iet_thr1(ipos);
        [LL2 LLmax_new par,iet_thr2]= LL_fromSampling(info,pickArea);
        
    end    

%     figure()
%     plot(iet_thr1,LL1/abs(max(LL1)),'b.')
%     hold on
%     plot(iet_thr2,LL2/abs(max(LL2)),'b-x')
%     plot(iet_thr_new,LL_new/abs(max(LL_new)),'r-o')

    %% PARAMETERS ASSIGNEMENT

    iet_thr = par(2);
    ll_bg   = info.background_ev / (info.total_per - sum([info.cluster(:).len] + iet_thr));
    ll_cl   = par(1);

    %% SAVE PARAMETERS
    MLE_results = struct;
    MLE_results.LL = LLmax;
    MLE_results.ll_bg =  ll_bg;
    MLE_results.ll_cl   =  ll_cl;
    MLE_results.iet_thr =  iet_thr;
    MLE_results.originalYN=originalYN;
    MLE_results.iet_thr1 = iet_thr1;
    MLE_results.LL1 = LL1;
    MLE_results.iet_thr2 = iet_thr2;
    MLE_results.LL2 = LL2;
    % combination of curves
    MLE_results.xx=[iet_thr1(iet_thr1 < iet_thr2(1)),iet_thr2,iet_thr1(iet_thr1 > iet_thr2(end))];
    MLE_results.yy=[LL1(iet_thr1 < iet_thr2(1)),LL2,LL1(iet_thr1 > iet_thr2(end))];

    %% SAVE RESULTS
    save([info.name_files  '_MLE_results.mat'],'MLE_results')
    
end
