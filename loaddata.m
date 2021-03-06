function [ y,K_COM1,K_COM2] = loaddata( task ,mkl_method)
%LOADDATA 此处显示有关此函数的摘要
%   此处显示详细说明
if strcmp(task, 'DTI')
    regcoef = 10000;
    dataname = 'ic';
    %dataname = 'e';
    %dataname = 'nr';
    %dataname = 'gpcr';
    [y,l1,l2] = loadtabfile(['data/interactions/' dataname '_admat_dgc.txt']);
    k1_paths = {['data/kernels/' dataname '_simmat_proteins_sw-n.txt'],...
        ['data/kernels/' dataname '_simmat_proteins_go.txt'],...
        ['data/kernels/' dataname '_simmat_proteins_ppi.txt'],...
        };
    K1_list = [];
    for i=1:length(k1_paths)
        [mat, labels] = loadtabfile(k1_paths{i});
        mat = process_kernel(mat);
        K1_list(:,:,i) = Knormalized(mat);
    end
    k2_paths = {['data/kernels/' dataname '_simmat_drugs_simcomp.txt'],...
                ['data/kernels/' dataname '_simmat_drugs_sider.txt'],...
                };
    K2_list = [];
    for i=1:length(k2_paths)
        [mat, labels] = loadtabfile(k2_paths{i});
        mat = process_kernel(mat);
        K2_list(:,:,i) = Knormalized(mat);
    end
    % 2. multiple kernel
    [weight_v1] = FKL_weights(K1_list,y,1,regcoef);
    K_COM1 = combine_kernels(weight_v1, K1_list);
    [weight_v2] = FKL_weights(K2_list,y,2,regcoef);
    K_COM2 = combine_kernels(weight_v2, K2_list);
    
elseif strcmp(task, 'GDI')
    y = load('./data2/interactions/GDI_matrix.txt');
    fprintf('---------------get Y \n')
    fprintf('----------MKL Method:%s\n',mkl_method);
    K_COM1 = load(['./data2/Kdiseases_' mkl_method '.txt']);
    fprintf('---------------get K_COM1 \n')
    K_COM2 = load(['./data2/Kgenes_' mkl_method '.txt']);
    fprintf('---------------get K_COM2 \n')
    

end

end

