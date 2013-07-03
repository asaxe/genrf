epsilon = 1.7;

D = sum(y,2);

x_pos = x(D < epsilon,:);

figure(1);

subplot(311)
hist(x_pos(:,1))
title('num bases')

subplot(312)
hist(x_pos(:,2))
title('win size')

subplot(313)
hist(x_pos(:,3))
title('whitening dim')