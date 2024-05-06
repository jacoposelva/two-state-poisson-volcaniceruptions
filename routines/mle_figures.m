function [f3]=mle_figures(info,MLE_meancat)
close all
[MLE_meancat.LLmax isel]=max(MLE_meancat.LL2);

% 
% confidence intervals, from chi-squared with 1 d.f.
MLE_lev50 = chi2inv(0.50,1)/2;%0.455/2;
MLE_lev70 = chi2inv(0.70,1)/2;%1.32/2;
MLE_lev75 = chi2inv(0.75,1)/2;%1.32/2;
MLE_lev80 = chi2inv(0.80,1)/2;%1.64/2;
MLE_lev90 = chi2inv(0.90,1)/2;%2.71/2;
MLE_lev95 = chi2inv(0.95,1)/2;%3.84/2;
MLE_lev99 = chi2inv(0.99,1)/2;%6.63/2;


%% FIGURES CHECK
% f2=figure();
% plot(MLE_meancat.iet_thr1,MLE_meancat.LL1,'.:k')
% hold on
% plot(MLE_meancat.iet_thr2,MLE_meancat.LL2,'.:r')
% plot(MLE_meancat.iet_thr2(isel),MLE_meancat.LL2(isel),'or')
% 
% xlabel('threshold iet, yr')
% ylabel('LogLikelihood')
% 
% 
% xlimtmp=get(gca,'xlim');
% ylimtmp=get(gca,'ylim');
% hold on
% 
% 
% plot(xlimtmp, MLE_meancat.LLmax-MLE_lev50*ones(2,1),'k.--')
% plot(xlimtmp, MLE_meancat.LLmax-MLE_lev70*ones(2,1),'k.-')
% plot(xlimtmp, MLE_meancat.LLmax-MLE_lev75*ones(2,1),'k.:')
% plot(xlimtmp, MLE_meancat.LLmax-MLE_lev80*ones(2,1),'ko--')
% plot(xlimtmp, MLE_meancat.LLmax-MLE_lev90*ones(2,1),'ko:')
% plot(xlimtmp, MLE_meancat.LLmax-MLE_lev95*ones(2,1),'k--')
% plot(xlimtmp, MLE_meancat.LLmax-MLE_lev99*ones(2,1),'k:')
% legend('LL1','LL2','MLE','p50','p70','p75','p80','p90','p95','p99')
% 


%%
f3=figure('position',[1008        1984         570         413])
cc1=0.9*ones(3,1);
cc2=0.7*ones(3,1);

plot(MLE_meancat.xx,MLE_meancat.yy,'.:k')
xlimtmp=get(gca,'xlim');
ylimtmp=get(gca,'ylim');

plot(MLE_meancat.iet_thr*ones(2,1),ylimtmp,'--k','linewidth',2)
hold on
plot(MLE_meancat.xx,MLE_meancat.yy,'.:k')


%area([MLE_meancat.lim_low99,MLE_meancat.lim_high99],ylimtmp(2)*ones(2,1),ylimtmp(1),'facecolor',cc2)
%area([xlimtmp(1);lim_low2],ylimtmp(2)*ones(2,1),ylimtmp(1),'facecolor',cc2)

xx = MLE_meancat.iet_thr1(isfinite(MLE_meancat.LL1));
yy = MLE_meancat.LL1(isfinite(MLE_meancat.LL1));

iet_low  = interp1(yy(xx<MLE_meancat.iet_thr),xx(xx<MLE_meancat.iet_thr),MLE_meancat.LLmax-MLE_lev95,'linear','extrap');
iet_high = interp1(yy(xx>MLE_meancat.iet_thr),xx(xx>MLE_meancat.iet_thr),MLE_meancat.LLmax-MLE_lev95,'linear','extrap');
area([iet_low,iet_high],ylimtmp(2)*ones(2,1),ylimtmp(1),'facecolor',cc2)
%plot(iet_low*ones(2,1) ,ylimtmp,'k')
%plot(iet_high*ones(2,1),ylimtmp,'k')

xx = MLE_meancat.iet_thr1(isfinite(MLE_meancat.LL1));
yy = MLE_meancat.LL1(isfinite(MLE_meancat.LL1));

iet_low  = interp1(yy(xx<MLE_meancat.iet_thr),xx(xx<MLE_meancat.iet_thr),MLE_meancat.LLmax-MLE_lev70);
iet_high = interp1(yy(xx>MLE_meancat.iet_thr),xx(xx>MLE_meancat.iet_thr),MLE_meancat.LLmax-MLE_lev70);
area([iet_low,iet_high],ylimtmp(2)*ones(2,1),ylimtmp(1),'facecolor',cc1)
%plot(iet_low*ones(2,1) ,ylimtmp,'k')
%plot(iet_high*ones(2,1),ylimtmp,'k')

plot(info.censoring*ones(2,1),ylimtmp,'--r')

plot(MLE_meancat.xx,MLE_meancat.yy,'.:k')
plot(MLE_meancat.iet_thr*ones(2,1),ylimtmp,'--k','linewidth',2)

%set(gca,'ylim',[ylimtmp(2)-6 ylimtmp(2)]);
%legend('MLE','LogLikelihood','99% Conf. Int.','95% Conf. Int.','Ongoing repose')
legend('MLE','LogLikelihood','95% Conf. Int.','70% Conf. Int.','Ongoing repose','location','southeast')
xlabel('Threshold Inter-Event Time - \tau (yr)')
ylabel('LogLikelihood')
title(info.name)

saveas(f3,[info.name_files '_figure_LL_onlyIET.png'])

end