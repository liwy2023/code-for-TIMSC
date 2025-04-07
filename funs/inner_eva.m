function [result]=inner_eva(U,k)
if nargin == 2

    S = (U+U')/2;
    % 计算度矩阵
    D = diag(sum(S, 2));

    % 计算拉普拉斯矩阵
    L = D - S;


    % 计算特征值和特征向量
    [U, ~] = eig(L);

    % 对特征向量进行归一化
    for i=1:size(U, 2)
        U(:, i) = U(:, i)/norm(U(:, i));
    end

    % 取前k个特征向量
    %[K1, k, K12,K22] = Estimate_Number_of_Clusters_given_graph(S, [2:10]);
    V = U(:, 1:k);
end

if nargin == 1

    S = (U+U')/2;
    % 计算度矩阵
    D = diag(sum(S, 2));

    % 计算拉普拉斯矩阵
    L = D - S;


    % 计算特征值和特征向量
    [U, ~] = eig(L);

    % 对特征向量进行归一化
    for i=1:size(U, 2)
        U(:, i) = U(:, i)/norm(U(:, i));
    end

    % 取前k个特征向量
    [K1, k, K12,K22] = Estimate_Number_of_Clusters_given_graph(S, [2:10]);
    V = U(:, 1:k);
end



%DaviesBouldin_result = evalclusters(V,"kmeans","DaviesBouldin","KList",k);
silhouette_result = evalclusters(V,"kmeans","silhouette","KList",k);

%d_result = DaviesBouldin_result.CriterionValues;
s_result = silhouette_result.CriterionValues;
result =[s_result];



