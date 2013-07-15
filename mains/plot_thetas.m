function plot_thetas(theta,start_gen,end_gen)
[M N T] = size(theta);

param_names = kmeans_param_names;
for i = 1:M
    subplot(ceil(sqrt(M)),ceil(sqrt(M)),i)

    tmp = squeeze(theta(i,:,start_gen:end_gen));
    
    cloudPlot(repmat(start_gen:end_gen,N,1),tmp,[],[],[20,10]);
    colormap(repmat(1:-.01:0,3,1)')
    %    plot(squeeze(theta(i,:,:))')
    title(param_names{i})
end

figure()

for i = 1:M
    for j = 1:i
        subplot(M,M,(i-1)*M+j)
        cloudPlot(squeeze(theta(j,:,start_gen:end_gen)),squeeze(theta(i,:, ...                              
                            start_gen:end_gen)),[],[],[20,20])
        colormap(repmat(1:-.01:0,3,1)')
        if( j == 1 )
            ylabel(param_names{i})
        end
        if( i == M )
            xlabel(param_names{j})
        end
    end
end

figure()

for i = 1:M
    subplot(1,M,i)
    tmp = squeeze(theta(i,:,start_gen:end_gen));
    %if( i == 1 )
    %    tmp = sqrt(tmp);
    %end
    hist(tmp(:),31)
    xlabel(param_names(i))
end


figure()

tmp = squeeze(theta(3,:,start_gen:end_gen))./squeeze(theta(1,:, ...
                                                  start_gen:end_gen)).^2;
hist(tmp(:),20)