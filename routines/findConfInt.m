

function [f1]=findConfInt(info, MLE_results,conf_int_all)
%close all
%clear
%load OutputFiles/20255612_1103_input_Vesuvius_MLE_results.mat
%load OutputFiles/20255612_1103_input_Vesuvius_info.mat

LL = MLE_results.yy;
yth = MLE_results.xx;

for i=1:length(conf_int_all)
    conf_int = conf_int_all(i);

    MLE_lev = chi2inv(conf_int,1)/2;
    
    [LLmax imax] = max(LL);
    xx_best = yth(imax);
    
    yythr=LLmax-MLE_lev;
    isel=find(LL>yythr);
    
    xx_min = yth(isel(1));
    xx_max = yth(isel(end));

    iet_thr_best(i) = xx_best;
    ll_bg_best(i) = info.background_ev ./ (info.total_per - sum([info.cluster(:).len] + xx_best));
    ll_cl_best(i) = sum([info.cluster(end).nev]) / sum([info.cluster(end).len] + xx_best);

    iet_thr_min(i) = xx_min;
    ll_bg_min(i) = info.background_ev ./ (info.total_per - sum([info.cluster(:).len] + xx_min));
    ll_cl_max(i) = sum([info.cluster(end).nev]) / sum([info.cluster(end).len] + xx_min);

    iet_thr_max(i) = xx_max;
    ll_bg_max(i) = info.background_ev ./ (info.total_per - sum([info.cluster(:).len] + xx_max));
    ll_cl_min(i) = sum([info.cluster(end).nev]) / sum([info.cluster(end).len] + xx_max);

    
end

% confidence intervals, from chi-squared with 1 d.f.
f1 = figure();
plot(yth,LL)
hold on
leg{1}='LL';
for i=1:length(conf_int_all)
   leg{i+1}=['IC:' num2str(conf_int_all(i))];
   plot([iet_thr_min(i) iet_thr_best(i) iet_thr_max(i)],conf_int_all(i)*max(LL)*ones(1,3),'x-')
end
legend(leg)

f2=figure();
nx = ceil(length(conf_int_all)*0.5);
ny = round(length(conf_int_all)/nx);
for isel=1:length(conf_int_all)
    subplot(nx,ny,isel)
    errorbar([2,2],ll_cl_best(isel),ll_cl_best(isel)-ll_cl_min(isel),ll_cl_max(isel)-ll_cl_best(isel))
    set(gca,'yscale','log')
    hold on
    errorbar([1,1],ll_bg_best(isel),ll_bg_best(isel)-ll_bg_min(isel),ll_bg_max(isel)-ll_bg_best(isel))
    %semilogy([2 2],[ll_cl_min(isel) ll_cl_max(isel)],'x-');
    %semilogy([1 1],[ll_bg_min(isel) ll_bg_max(isel)],'x-');
    xlim([0 3])
    ylim([1.e-4 1.e-1])
    grid
    title(['CI:' num2str(conf_int_all(isel))]);

    set(gca,'XTick',[1 2],'XTickLabel',{'\lambda_L','\lambda_H'})
end

end



