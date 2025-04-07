function [result converge_Z converge_Z_G] = TIMSC(X, lambda1, lambda2, response, W)
%     try
    fprintf("RDML0:");
    cls_num = length(unique(response))./10;
%     Label = double(gt);
    num_views = length(X); 
    V = length(X);
    N = size(X{1}, 2); % view number; sample number
    alfa = 1.2;
    theta = 1;
    %% Data preprocessing
    for v = 1:num_views
        X{v} = NormalizeData(X{v});
    end
    
    %% Initialize and Settings
    for k = 1:num_views
        Z{k} = zeros(N, N);
        C{k} = zeros(N, N);
        E{k} = zeros(size(X{k}, 1), N);
        Y{k} = zeros(size(X{k}, 1), N);
        S{k} = zeros(N, N);
        B{k} = zeros(size(X{k}, 1), size(W{k}, 1));
    end
    views = num_views;  % 视图个数
    dim1 = N; dim2 = N; dim3 = views;  % 张量维度
    sX = [N, N, views];
    epson = 1e-4; mu =0.1; max_mu = 1e8; pho_mu = 2;
    converge_Z = []; converge_Z_G = [];

    iter = 0; Isconverg = 0; num = 0;
    while (Isconverg == 0)
        num = num + 1;
        
       %% Update E^k
        for k = 1:views
            F1 = (X{k} + B{k} * W{k}) - (X{k} + B{k} * W{k}) * Z{k} + Y{k}/mu;
            E{k} = solve_l1l2(F1,lambda1/mu);
        end
        
       %% Update Z^k
        for k = 1:views
            Q = X{k} + B{k} * W{k};
            Z_h = zeros(N, N);
            for j = 1:views
                if (j ~= k)
                    Z_h = Z_h + Z{j}';
                end
            end
            Z_A = mu * (Q'*Q + eye(N, N));

            Z{k} = inv(Z_A) * (mu * (Q'*Q - Q' * E{k} + S{k}) - C{k} + Q' * Y{k} - lambda2 * Z_h);
        end
        
       % update B^k
        for k = 1:views
            temp1 = X{k} - X{k} * Z{k} - E{k} + Y{k}/ mu;
            temp2 = temp1 * (Z{k}' * W{k}' - W{k}');
            temp3 = W{k} * W{k}' - W{k} * Z{k} * W{k}' - W{k} * Z{k}' * W{k}' + W{k} * Z{k} * Z{k}' * W{k}' ;
            B{k} = temp2 * inv(temp3);
        end
%         for i = 1:views
%             C_1 = X{i}*Z{i}-X{i}+E{i}-Y{i}./mu;
%             D_1 = W{i}-W{i}*Z{i};
%             B{i}= mu*C_1*D_1'*(inv(mu*D_1*D_1'));
%         end
%        %% Update Y^k
%         for k = 1:views
%             
%         end

        %% update S
        Z_tensor = cat(3, Z{:,:});
        z = Z_tensor(:);
        C_tensor = cat(3, C{:,:});
        c = C_tensor(:);

        [s, ~] = wshrinkObj_tanh(z + 1/mu*c,1/mu,sX,0,3,alfa,theta)   ;
        S_tensor = reshape(s, sX);
        for k = 1:views
            S{k} = S_tensor(:,:,k);
        end
        %% Update C
        for k = 1:views
            Y{k} = Y{k} + mu * (X{k} + B{k} * W{k} - (X{k} + B{k} * W{k}) * Z{k} - E{k});
            C{k} = C{k} + mu * (Z{k} - S{k});
        end
        %% Record the iteration information
%         history.objval(iter + 1) = objV;

        %% Convergence condition
        max_Z = 0;
        max_Z_G = 0;
        Isconverg = 1;
        for k = 1:views
            if (norm(X{k} + B{k} * W{k} - (X{k} + B{k} * W{k}) * Z{k} - E{k}, inf) > epson)
                history.norm_Z = norm(X{k} + B{k} * W{k} - (X{k} + B{k} * W{k}) * Z{k} - E{k}, inf);
                Isconverg = 0;
                max_Z = max(max_Z, history.norm_Z);
            end

            if (norm(Z{k} - S{k}, inf) > epson)
                history.norm_Z_G = norm(Z{k} - S{k}, inf);
                Isconverg = 0;
                max_Z_G = max(max_Z_G, history.norm_Z_G);
            end
        end
        converge_Z = [converge_Z max_Z];
        converge_Z_G = [converge_Z_G max_Z_G];
        iter = iter + 1;
        if (iter == 200)
            Isconverg = 1;
            save("./converge_Z.mat","converge_Z");
            save("./converge_Z_G.mat","converge_Z_G");
        end
        mu = min(mu * pho_mu, max_mu);
    end

    %% Final clustering

        S2 = zeros(N, N);
    for i = 1:V
        S2 = S2 + abs(Z{i}) + abs(Z{i}');
    end

    S2 = S2./V;

for i = 1:10
    [result(i,:),~] = Calculate_p(S2,response);
    % result = -log10(result);
end
result = mean(result,1);
%     Clus = Ng_SpectralClustering(S1 ./ views, cls_num); 
%     result = EvaluationMetrics(Label, Clus);
%     result = [result, inner_eva(S1)];
%     catch
%         result = zeros(1,8);
%     end
end

