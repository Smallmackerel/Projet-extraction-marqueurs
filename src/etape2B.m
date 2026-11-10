clear; clc;

% Paramètres
M = 2000; % nombre d'échantillons
N = 8;
m_val = 0;
sigma_carre = 1;
m = 2;

% Génération du signal
% x = abs(sqrt(sigma_carre) + randn(1, M) + m_val);
t = 1:M;
signal_utile = 5 * sin(2*pi*2*t/M); % Ajout d'une vraie tendance pour le test
bruit = sqrt(sigma_carre) * randn(1,M) + m;
x = signal_utile + bruit;

% --- Filtrage passe-bas par moyenne des N derniers échantillons ---
b = ones(1, N) / N; % Coefficients du numérateur (moyenneur)
a = 1;              % Coefficient du dénominateur (égal à 1 pour un RIF)

% Application du filtrage
tendance = filter(b, a, x);

% Alternative équivalente avec movmean :
% tendance = movmean(x, [N-1 0]);

% Visualisation optionnelle
figure;
plot(1:M, x, 'Color', [0.7 0.7 0.7], 'LineWidth', 1); hold on;
plot(1:M, tendance, 'r-', 'LineWidth', 1.5);
legend('Signal original $x$', 'Tendance filtrée', 'Interpreter', 'latex');
xlabel('Indice des échantillons');
ylabel('Amplitude');
title('Filtrage passe-bas (moyenne mobile)');
grid on;