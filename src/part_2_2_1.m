clear;
clc;

%%%%%%%%% Étape 2.2.1 : %%%%%%%%%

%% génération bbgc :

N = 2000;
m = 0;
sigma_carre = 1;
x = abs(sqrt(sigma_carre) + randn(1,N) + m);

%% création du filtre : 

f_1 = 1/4;
f_2 = 4/9;
R = 0;
r = 0.95;

%%% pôles

p_1 = R*exp(1i*2*pi*f_1);
p_2 = R*exp(1i*2*pi*f_2);

%%% zéros

z_1 = r*exp(1i*2*pi*f_1);
z_2 = conj(z_1);
z_3 = r*exp(1i*2*pi*f_2);
z_4 = conj(z_3);

%%% Numérateur

Zeros = [z_1 z_2 z_3 z_4];
B = poly(Zeros);

%%% Dénominateur : 
A = 1;

%% filtrage : 
y = filter(B,A,x);


%% Affichage de la réponse en fréquence (Réjections)
figure;

%%% Représentation temporelle %%%

n = 1:N;
% Plot du signal de sortie filtré
subplot(3,3,1)
plot(n, y);
grid on;

xlim([1 300]); 
xlabel('Échantillons (n)');
ylabel('Amplitude');
title('Représentation temporelle du signal filtré y(n)');

%%% Représentation spectrale %%%

fn = 0 : 1/N : 1/2; 

H = freqz(B, A, 2*pi*fn);

subplot(3,3,2);
plot(fn, abs(H), 'LineWidth', 1.5);
grid on;
xlabel('Fréquence normalisée (f)');
ylabel('Gain |H(f)|');
title('Réponse en fréquence du filtre (Réjections à f_1 et f_2)');


%% Comparaison des estimateurs de DSP (Welch, Bartlett, Daniell vs Théorique)
figure('Name', 'Comparaison des Périodogrammes - Filtre 1', 'Position', [100, 100, 900, 600]);
Fs = 1; 

% 4. Périodogramme de Daniell (on le calcule d'abord pour récupérer f_d)
[pxx_raw, f_d] = periodogram(y, [], 1024, Fs);
m_daniell = 5; % Fenêtre de lissage
kernel = ones(2*m_daniell + 1, 1) / (2*m_daniell + 1);
pxx_daniell = conv(pxx_raw, kernel, 'same');

% 1. DSP Théorique (évaluée sur la même grille de fréquence f_d et avec Fs=1)
[H2, f_th] = freqz(B, A,length(f_d) , Fs);
DSP_theorique = abs(H2).^2;

% 2. Périodogramme de Welch
[pxx_welch, f_w] = pwelch(y, hamming(256), 128, 1024, Fs);

% 3. Périodogramme de Bartlett (Cas particulier de Welch avec 0 recouvrement)
segmentLength = floor(N/4);
[pxx_bartlett, f_b] = pwelch(y, segmentLength, 0, 1024, Fs);

% 5. Corrélogramme
[r_yy, lags] = xcorr(y, 'biased');
M_lag = 100; 
w = hamming(2*M_lag + 1)';
r_yy_windowed = r_yy(N - M_lag : N + M_lag) .* w;
[pxx_correlo, f_c] = freqz(r_yy_windowed, 1, 1024, Fs);

% 6. Affichage en dB
plot(f_th, 10*log10(DSP_theorique), 'k', 'LineWidth', 2, 'DisplayName', 'DSP Théorique');
hold on;
plot(f_d, 10*log10(pxx_raw), 'Color', [0.7 0.7 0.7], 'DisplayName', 'Périodogramme brut'); % Gris clair
plot(f_w, 10*log10(pxx_welch), 'b', 'DisplayName', 'Welch');
plot(f_b, 10*log10(pxx_bartlett), 'g', 'DisplayName', 'Bartlett');
plot(f_d, 10*log10(pxx_daniell), 'm', 'LineWidth', 1.5, 'DisplayName', 'Daniell (m=5)');

grid on;
xlabel('Fréquence normalisée');
ylabel('Densité Spectrale de Puissance (dB)');
title('Comparaison des estimateurs de DSP pour le Filtre de Réjection');
legend('show', 'Location', 'southwest');
xlim([0 0.5]); 