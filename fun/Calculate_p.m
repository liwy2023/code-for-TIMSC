function [p,K2]=Calculate_p(S1,response)

S1 = (abs(S1)+abs(S1'))./2;

[K1, K2, K12,K22] = Estimate_Number_of_Clusters_given_graph(S1, [2:6]);
fprintf('The best number of clusters according to rotation cost is %d\n', K2);
idx = Ng_SpectralClustering(double(S1),K2);
gt = idx;

survival_matrix = [response gt];

charVector = char(survival_matrix(:,3) + '0');

% 将字符型向量转换为N×1的单元字符向量元胞数组
group_cell = cellstr(charVector);

[p] = MatSurv(survival_matrix(:,1),survival_matrix(:,2),group_cell,'DispHR',false,'Xlabel','Time (days)','NoRiskTable',true);
p = -log10(p);