close all;
clear all;

datasetdir = './dataset/';

dataname = {'OV_std0.1_baladata'};
numdata = length(dataname); % data number
for idata = 1:numdata
dataset_name = cell2mat(dataname(idata));
    datafile = [datasetdir, cell2mat(dataname(idata)),'.mat'];
    load(datafile);
% load(dataset_name);
currentTime = datestr(now, 'yyyymmdd_HHMMSS');
% omega = [30, 50, 80]';
X = data;
num_view = length(X);
ind_folds = inds;
num_instance=size(X{1},2);
filename_Z = sprintf('%s_%s_%s.mat', dataset_name, currentTime,"converge_Z");
filename_G = sprintf('%s_%s_%s.mat', dataset_name, currentTime,"converge_G");
for iv = 1:num_view
    X1 = X{iv}';%X1 nxm
    X1 = NormalizeFea(X1,1);
    X2 = X{iv};%X2 mXn
    X2 = NormalizeFea(X2,0);

    ind_0 = find(ind_folds(:,iv) == 0);
    X2(:,ind_0) = 0 ;
    XX{iv} = X2;

    X1(ind_0,:) = [];
    Y{iv} = X1'; 
    W1 = eye(size(ind_folds,1));
    W1(ind_0,:) = [];
    M{iv} = W1;
    %构造缺失部分EW
    Win1 = eye(num_instance);
    ind_1 = find(ind_folds(:,iv) == 1);
    Win1(ind_1,:) = [];
    Win{iv} = Win1;
    Ind_ms{iv} = ind_0;
end
clear X X1 W1 X2
X = Y;
XX2 = XX; 
clear Y XX

alpha_test = [0.111200000000000, 0.111200000000000];  
num = 1; 

lambda1 = linspace(alpha_test(1), alpha_test(2), num);
bestRes1 = [];
for i = 1:length(lambda1)
    for j = 1:length(lambda1)
%         for test = 1:test_num
%         try

            [p converge_Z converge_Z_G] = TIMSC(XX2,lambda1(i),lambda1(j),response,Win);
            fprintf("p = %5.4f, lambda1 = %5.4f, lambda2 = %5.4f\n",p,lambda1(i),lambda1(j));
            bestRes1 = [bestRes1; p,lambda1(i),lambda1(j)]; 

%         end
%         catch
%         end
    end
end

end