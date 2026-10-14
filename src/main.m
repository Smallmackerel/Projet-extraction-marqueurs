clear;
clc;

%%%%%%%%% Étape 2.2 : %%%%%%%%%

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
fn = 0 : 1/N : 1/2; 

H = freqz(B, A, 2*pi*fn);

% Affichage du module (l'amplitude) du filtre
plot(fn, abs(H), 'LineWidth', 1.5);
grid on;
xlabel('Fréquence normalisée (f)');
ylabel('Gain |H(f)|');
title('Réponse en fréquence du filtre (Réjections à f_1 et f_2)');