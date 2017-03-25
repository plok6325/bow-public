function fig = visualise(data,p_rf,p_svm,showSVM)
% This visualisation function is partially borrowed from Karpathy's RF toolbox

try
    fig = figure;
    p_all = sum(p_rf,3);
    if showSVM
        subplot(1,2,1)
        plot_toydata(data);
        imagesc([-1.5 1.5],[-1.5 1.5],reshape(p_all,151,151,3)/size(p_rf,3));
        hold on;
        plot_toydata(data);
        hold on;
        axis([-1.5 1.5 -1.5 1.5]);
        hold off
        
        subplot(1,2,2)
        % SVM
        plot_toydata(data);
        imagesc([-1.5 1.5],[-1.5 1.5],reshape(p_svm,151,151,3));
        hold on;
        plot_toydata(data);
        hold on;
        axis([-1.5 1.5 -1.5 1.5]);
        hold off
    else
        plot_toydata(data); 
        imagesc([-1.5 1.5],[-1.5 1.5],reshape(p_all,151,151,3)/size(p_rf,3));
        hold on;
        plot_toydata(data);
        hold on;
        axis([-1.5 1.5 -1.5 1.5]);
        hold off
    end
catch
    close all;
    fprintf('skip visualisation.\n');
end

end
