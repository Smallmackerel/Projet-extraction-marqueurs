clear; clc;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% étape 0 génération d'un signal pour les tests
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% taille du signal
M = 1000; 
% signal
t1 = 1:M;
x = 5 * sin(2*pi*2*t1/M); 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% étape 1 centrage puis intégration
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

x_centre = x - mean(x);
% intégration par méthode des rectangles
%%% cumtrapz pour la méthode des trapèzes
y = cumsum(x_centre); 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% étape 2a décomposition en blocs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% choix de la méthode de tendance 
% 0 = par la moyenne
% 1 = par droite de régression
choix = 0;

% on fixe la taille d'un bloc
N = 16; 

M = length(y);
% L est le nombre de blocs
L = floor(M/N);
% on ajuste la taille de y (toujours le signal intégré)
% aux nombres de blocs complets
y_ajuste = y(1:L*N);

% définition de la tendance
tendance = zeros(size(y_ajuste));

% Vecteur temps pour 1 bloc
t = (1:N)';

for i = 1:L
    debut = (i-1)*N +1;
    fin = i*N;
    bloc = y_ajuste(debut:fin);

    if choix == 0
        % modèle par la moyenne : (degré 0)
        val_tendance = mean(bloc);
        bloc_tendance = val_tendance * ones(N,1);
    else
        % modèle par droite de régression (degré 1)
        p = polyfit(t, block, 1);
        bloc_tendance = polyval(p,t);
    end
    tendance(debut:fin) = bloc_tendance;
end

%%%%%%%%%%% plot %%%%%%%%%%% 

% % Figure 1 : Signal d'origine et signal intégré
figure('Name', 'Étapes 0 et 1 : Signal et Intégration', 'Color', 'w');

subplot(2,1,1);
plot(x, 'Color', [0 0.447 0.741], 'LineWidth', 1);
title('Signal d''origine x');
xlabel('Indice n'); ylabel('Amplitude');
grid on;

subplot(2,1,2);
plot(y, 'Color', [0.85 0.325 0.098], 'LineWidth', 1);
title('Signal intégré y (somme cumulée centrée)');
xlabel('Indice n'); ylabel('Amplitude');
grid on;

% Figure 2 : Signal intégré et sa tendance estimée par morceaux
figure('Name', 'Étape 2a : Estimation de la tendance', 'Color', 'w');
plot(y_ajuste, 'Color', [0.3 0.3 0.3], 'LineWidth', 1.2, 'DisplayName', 'Signal intégré y');
hold on;
plot(tendance, 'r-', 'LineWidth', 2, 'DisplayName', 'Tendance estimée par blocs');
legend('Location', 'northwest');
title(['Estimation de la tendance par blocs (N = ', num2str(N), ', Degré = ', num2str(choix), ')']);
xlabel('Indice n'); ylabel('Amplitude');
grid on;
hold off;

%%%%%%%%%%% fin plot %%%%%%%%%%% 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% étape 2b filtre passe-bas
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% taille de la fenêtre (N = 16)

% définition de la réponse impulsionnelle
b = (1/N) * ones(1, N);
a = 1;

% filtrage sur y
tendance_2b = filter(a,b,y);

% recalage du signal pour compenser le retard de (N-1)/2

retard = (N-1)/2;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plot Étape 2b
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure('Name', 'Étape 2b : Filtrage passe-bas (Moyenne glissante)', 'Color', 'w');
plot(y, 'Color', [0.5 0.5 0.5], 'LineWidth', 1, 'DisplayName', 'Signal intégré y');
hold on;
plot(tendance_2b, 'b-', 'LineWidth', 1.8, 'DisplayName', 'Tendance (Moyenne glissante causale)');
legend('Location', 'northwest');
title(['Estimation de la tendance par moyenne glissante causale (N = ', num2str(N), ')']);
xlabel('Indice n'); ylabel('Amplitude');
grid on;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%% fin plot %%%%%%%%%%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% étape 2c décomposition en blocs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% ===================================
% Strat 1
% ===================================

g_s1 = filter(b,a,y);
% g_inverse = g(-n)
g_s1_inverse = flipud(g_s1);
r_s1 = filter(b,a,g_s1_inverse);
tendance_s1 = flipud(r_s1);

% ===================================
% Strat 2
% ===================================

g_s2 = filter(a,b,y);

y_s2_inverse = flipud(y);

r_s2 = filter(b,a,y_s2_inverse);

tendance_s2 = (g_s2 + flipud(r_s2)) / 2;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plot Étape 2c
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure('Name', 'Étape 2c : Filtres à phase nulle (Stratégies 1 et 2)', 'Color', 'w');
plot(y, 'Color', [0.7 0.7 0.7], 'LineWidth', 1.2, 'DisplayName', 'Signal intégré y');
hold on;
plot(tendance_s1, 'r-', 'LineWidth', 2, 'DisplayName', 'Stratégie 1 (Aller-Retour)');
plot(tendance_s2, 'b--', 'LineWidth', 1.8, 'DisplayName', 'Stratégie 2 (Sommation)');
legend('Location', 'northwest');
title(['Estimation de la tendance à phase nulle (N = ', num2str(N), ')']);
xlabel('Indice n'); ylabel('Amplitude');
grid on;
hold off;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% étape 3 tendance retranchée
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

r = y - tendance_s1;

% puissance des flucuations
P_N = mean(r.^2);

fprintf('Pour une taille de bloc N = %d, la puissance P(N) vaut : %.4f\n', N, P_N);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% étape 4 : log-log et droite de régression
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

vecteur_N = (3 : floor(M/2))';
nb_N = length(vecteur_N);

P_N = zeros(nb_N, 1);

for k = 1:nb_N
    N_courant = vecteur_N(k);
    
% Étape 2a
    L = floor(M / N_courant);
    y_tronque = y(1 : L * N_courant);
    tendance_loc = zeros(L * N_courant, 1);
    t_loc = (1:N_courant)';
    
    for i = 1:L
        idx = (i-1)*N_courant + 1 : i*N_courant;
        p = polyfit(t_loc, y_tronque(idx), 1);
        tendance_loc(idx) = polyval(p, t_loc);
    end
    
% Étape 3
    r_loc = y_tronque - tendance_loc;
    P_N(k) = mean(r_loc(:).^2);
end

log_N = log10(vecteur_N);
log_P = log10(P_N);

p_droite = polyfit(log_N, log_P, 1);
pente = p_droite(1);

% Reconstruction de la droite théorique pour le tracé graphique
droite_fit = polyval(p_droite, log_N);

fprintf('===============================================\n');
fprintf('MARQUEUR OBTENUE (Pente de la droite) : %.4f\n', pente);
fprintf('===============================================\n');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plot Étape 4
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure('Name', 'Étape 4 : Graphique Log-Log et Pente (DFA)', 'Color', 'w');

% Tracé des points calculés pour chaque N
plot(log_N, log_P, 'o', 'MarkerSize', 4, 'MarkerFaceColor', [0 0.447 0.741], ...
    'DisplayName', 'Points mesurés (log(P(N)) vs log(N))');
hold on;

% Tracé de la droite de régression
plot(log_N, droite_fit, 'r-', 'LineWidth', 2, ...
    'DisplayName', sprintf('Droite d''ajustement (Pente \\alpha = %.3f)', pente));

grid on;
xlabel('log_{10}(N)', 'FontWeight', 'bold');
ylabel('log_{10}(P(N))', 'FontWeight', 'bold');
title('Étape 4 : Détermination de la pente en échelle Log-Log');
legend('Location', 'northwest');
hold off;