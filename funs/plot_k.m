function [] = plot_k(nmi,x_label,name)
figure('Position', [200, 200, 600, 400]);
plot(nmi,'-o','LineWidth', 2);


 
% 给x轴和y轴加标签并设置标签的字体大小和字体
xlabel('\gamma', 'FontSize', 22, 'FontName', 'Arial', 'FontAngle', 'italic');
%ylabel('NMI', 'FontSize', 22, 'FontName', 'Arial');
ylabel('-log_{10}(p-value)', 'FontSize', 22, 'FontName', 'Arial');


%ylim([0, 1])
 
set(gca,'Xticklabel', x_label);
% set(gca, 'XTick', 1:10);
% xlabel(x_name,'FontWeight', 'bold');

% 获取当前轴句柄
ax = gca;
 
% 设置轴句柄的字体属性
set(ax, 'FontSize', 22);

name = strcat("lam3_",name);
%zp = BaseZoom();
%zp.plot;
print(name, '-depsc');
