function [] = plot_surf(str_x,str_y,y_nama_,x_name,z,acc_nmi,name)
figure('Position', [200, 200, 820, 400]);
Go = surf(z);

%beta:
set(gca,'Yticklabel', str_x);
set(gca, 'YTick', 1:10);
ylabel(y_nama_,'FontWeight', 'bold');

%gamma:
set(gca,'Xticklabel', str_y);
set(gca, 'XTick', 1:10);
xlabel(x_name,'FontWeight', 'bold');

%zlim([0.8,1]);


c=colorbar;
%c.Position(2) = 0.042;  % 调整左边距
% c.Position(3) = 0.011;    % 调整宽度，设置为您需要的值

pos = c.Position;

% 修改Position，将彩色条向右移动一些
pos(1) = pos(1) + 0.085; % 增加x位置，向右移动

% 更新colorbar的Position
c.Position = pos;

ax = gca;
ax.FontSize = 16;  % 设置为您需要的字体大小
ax.XLabel.FontSize = 28;  % 设置为您需要的字体大小
ax.YLabel.FontSize = 28;  % 设置为您需要的字体大小
% 设置坐标轴刻度标签的字体大小





%name = strcat(name,".eps");
if acc_nmi=="plog_value"
    %zlim([0,1]);
    zlabel('-log_{10}(p-value)');
    ax = gca;  % 获取当前的坐标轴句柄
    ax.LineWidth = 1.2;  % 设置坐标轴线的宽度
    print(name, '-depsc');
end
if acc_nmi=="nmi"
    zlabel('NMI');
    ax = gca;  % 获取当前的坐标轴句柄
    ax.LineWidth = 1.2;  % 设置坐标轴线的宽度
    print(name, '-depsc');
end

end