% 2A décomposition du signal en bloc

M = 2000; % nombre d'échantillons
N = 100;  % Augmenté pour une meilleure visualisation de la tendance par bloc
m = 2;    % Moyenne non nulle pour mieux voir le signal
sigma_carre = 1;

L = floor(M/N);

% Génération du signal (Lissage/Modif pour avoir une tendance visible)
t = 1:M;
signal_utile = 5 * sin(2*pi*2*t/M); % Ajout d'une vraie tendance pour le test

bruit = sqrt(sigma_carre) * randn(1,M) + m;
x = signal_utile + bruit;

% pour avoir un multiple de N
x_tronque = x(1 : L*N);

% Séparation en blocs : chaque colonne est un bloc de N échantillons
bloc = reshape(x_tronque, N, L);

% Initialisation du vecteur de tendance globale
tendance = zeros(1, L*N);

% Estimation de la tendance (moyenne) pour chaque bloc
for i = 1:L 
    % Calcul de la moyenne du bloc i
    moyenne_bloc = mean(bloc(:, i)); 
    
    % Remplissage de la tendance globale pour les indices du bloc i
    indices = (i-1)*N + 1 : i*N;
    tendance(indices) = moyenne_bloc;
end

figure;
plot(x_tronque, 'Color', [0.7 0.7 0.7], 'DisplayName', 'Signal brut tronqué'); 
hold on;
plot(tendance, 'r', 'LineWidth', 2, 'DisplayName', 'Tendance par bloc');

% Esthétique du graphique
grid on;
title(sprintf('Estimation de la tendance par blocs de N = %d', N));
xlabel('Échantillons');
ylabel('Amplitude');
legend('Location', 'best');
