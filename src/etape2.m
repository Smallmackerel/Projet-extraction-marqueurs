% décomposition du signal en bloc

M = 2000; % nombre d'échantillons
N = 8;
m = 0;
sigma_carre = 1;

L = floor(M/N);

x = abs(sqrt(sigma_carre) + randn(1,M) + m);
x = x(1 : L*N);

bloc = reshape(x, N, L);

tendance = zeros(1, L*N);

for i = 1:L 
    tendance = mean(bloc(1,:))* ones(N,1);
end