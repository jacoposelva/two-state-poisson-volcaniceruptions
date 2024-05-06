function [LL,LLmax,par,iet_bins]=try_ietthr_singlepar_corr(iet_thr,nsamples,cluster_nev,cluster_lengths,cluster_4lambda,figYN)
% correct the bias introduced by the last IET
LLmin=-1e10;
LL=LLmin*ones(size(iet_thr));
if figYN
    f1=figure();
end

%% BINNING PER PLOT
binmax = ceil(max(cluster_lengths*1.2)/1000)*1000;
binmin = 0;
%bin=(binmax-binmin)/20;
bin=10;

%bin=250;
iet_bins=bin:bin:binmax;
iet_bins_centr = iet_bins - 0.5*bin;
iet_bins_counts = zeros(length(iet_bins), length(iet_thr));
for i=1:length(cluster_lengths)
    [tmp,ibin]=min(abs(cluster_lengths(i)-iet_bins_centr));
    databin(i) = ibin;
%    databin(i) = find(iet_bins > cluster_lengths(id),1);
end

%% LOOP SUI TRIALS
%ntrials = round( (50 / l_cl) / 1000) * 1000;
for itry=1:length(iet_thr)
    %% CONTO
    t_thr=iet_thr(itry);
    l_cl(itry) = sum(cluster_nev(cluster_4lambda)) / sum(cluster_lengths(cluster_4lambda) + t_thr);
    disp(['Try IET_THR ' num2str(t_thr) ' yr'])
    
    tcl=zeros(nsamples,1);
    for i=1:nsamples
        tout = sample_cluster(l_cl(itry),t_thr);
        if isempty(tout)
            tcl(i)=0;
        else
            tcl(i)=tout(end);
        end
        [tmp,ibin]=min(abs(tcl(i)-iet_bins_centr));
%        ibin=find(iet_bins > tcl(i),1);
        iet_bins_counts(ibin,itry)=iet_bins_counts(ibin,itry)+1/nsamples;
    end
    
    
%    iettmp2 = exprnd(1/l_cl,nsamples,ntrials);
%    tmp=iettmp2 > t_thr;
%     [tmp,ibin]=min(abs(tcl(i)-iet_bins_centr));
%     [a b c]=unique(ibin);
%     de=accumarray(c,1);
    
    LL(itry)=sum( log(iet_bins_counts( databin, itry ) ) );
    
    if LL(itry) < LLmin
        disp(['--- LL: ' num2str(LL(itry))])
%        disp(['--- LL: ' num2str(LL(itry)) ' corrected to ' num2str(1.1*LLmin)])
%        LL(itry)=1.1*LLmin;
    end
    
    %% FIGURE
    if figYN
        figure(f1)
        subplot(3,1,1)
        hist(tcl)
        title(t_thr)
        xlabel('cluster length, yr')
        subplot(3,1,2)
        bar(iet_bins_centr,iet_bins_counts(:,itry))
        xlabel('cluster length, yr')
        hold on
        yy=get(gca,'ylim');
        for iev=1:length(databin)
            plot(iet_bins_centr(databin(iev))*ones(2,1),yy,'r')
        end
        subplot(3,1,3)
        plot(iet_thr,LL,'o:')
        xlabel('threshold iet, yr')
        ylabel('LL')

    %     ylimnow = get(gca,'ylim')
    %     ylim([min(LL(LL>LLmin))-5,ylimnow(2)])

        pause(0)
    end
end

[LLmax imax]=max(LL);
par(1) = l_cl(imax);
par(2) = iet_thr(imax);


end
