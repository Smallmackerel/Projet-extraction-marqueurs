Voici l'explication théorique et l'implémentation MATLAB pour l'**Étape 2c**, qui traite du **filtrage à phase nulle** avec deux stratégies distinctes.

---

### 1. Analyse théorique des deux stratégies (Étape 2c)

L'objectif d'un filtre à phase nulle est de **conserver la phase originale** du signal (ne pas décaler les composantes temporelles), ce qui est crucial lorsqu'on veut estimer une tendance sans introduire le retard de groupe qu'on avait à l'étape 2b.

#### Stratégie 1 : Filtrage aller-retour (Forward-Backward Filtering)

1. **Signal $g(n)$ :** $y(n)$ est filtré par $h(n) \implies G(z) = Y(z) \cdot H(z)$
2. **Signal $r(n)$ :** La séquence inversée $g(-n)$ est filtrée par $h(n)$. En domaine $z$, inverser le temps revient à remplacer $z$ par $z^{-1}$. Donc $R(z) = G(z^{-1}) \cdot H(z) = Y(z^{-1}) \cdot H(z^{-1}) \cdot H(z)$.
3. **Sortie finale $s(n) = r(-n)$ :** On ré-inverse le temps $\implies S(z) = R(z^{-1})$.

$$S(z) = Y(z) \cdot H(z) \cdot H(z^{-1})$$



* **Réponse en fréquence globale :**

$$H_{\text{global}}(e^{j\omega}) = H(e^{j\omega}) \cdot H(e^{-j\omega}) = \vert{}H(e^{j\omega})\vert{}^2$$


* **Condition phase nulle :** Puisque la réponse globale est égale au carré du module de $H(e^{j\omega})$, elle est **purement réelle et positive**. Sa phase est donc **strictement nulle** ($\arg(H_{\text{global}}) = 0$).
* **Fonction MATLAB dédiée :** C'est exactement ce que réalise la commande `filtfilt` de MATLAB !

---

#### Stratégie 2 : Sommation directe et temps-inversé

1. $g(n)$ est la sortie du filtrage de $y(n)$ par $h(n) \implies G(z) = Y(z) \cdot H(z)$
2. $r(n)$ est la sortie du filtrage de $y(-n)$ par $h(n) \implies R(z) = Y(z^{-1}) \cdot H(z)$
3. **Sortie finale $s(n) = g(n) + r(-n)$ :**

$$S(z) = G(z) + R(z^{-1}) = Y(z) \cdot H(z) + Y(z) \cdot H(z^{-1}) = Y(z) \cdot [H(z) + H(z^{-1})]$$



* **Réponse en fréquence globale :**

$$H_{\text{global}}(e^{j\omega}) = H(e^{j\omega}) + H(e^{-j\omega}) = 2 \cdot \text{Re}\{H(e^{j\omega})\}$$


* **Condition phase nulle :** $H_{\text{global}}(e^{j\omega})$ est toujours purement réelle. Cependant, si $H(n)$ est une réponse impulsionnelle réelle symétrique (ou un filtre passe-bas classique), cette somme donne une phase nulle ou un déphasage de $\pi$ (si la partie réelle devient négative). Pour garantir une vraie phase nulle sans annulation indésirable de fréquences, $h(n)$ doit être choisi de manière à ce que $\text{Re}\{H(e^{j\omega})\} \ge 0$ sur la bande utile.

---

### 2. Code MATLAB (Étape 2c)

Voici le code pour tester et comparer les deux stratégies par rapport au filtre causal classique de l'étape 2b :

```matlab
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Étape 2c : Filtrage à phase nulle (Stratégies 1 & 2)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

N = 16;
b = (1/N) * ones(1, N); % Filtre moyenneur RIF
a = 1;

% ---------------------------------------------
% Stratégie 1 : Filtrage aller-retour
% ---------------------------------------------
% Méthode manuelles / explicite (comme décrite dans le sujet) :
g_strat1 = filter(b, a, y);              % 1. Filtrer y(n) -> g(n)
g_rev    = flipud(g_strat1);            % 2. Inverser le temps g(-n)
r_strat1 = filter(b, a, g_rev);          % 3. Filtrer g(-n) par h(n)
tendance_strat1 = flipud(r_strat1);      % 4. Ré-inverser r(-n)

% Note : En pratique sur MATLAB, on peut aussi utiliser directement :
% tendance_strat1 = filtfilt(b, a, y);

% ---------------------------------------------
% Stratégie 2 : Somme g(n) + r(-n)
% ---------------------------------------------
g_strat2 = filter(b, a, y);              % 1. Filtrer y(n) -> g(n)
y_rev    = flipud(y);                   % 2. Inverser y(-n)
r_strat2 = filter(b, a, y_rev);          % 3. Filtrer y(-n) par h(n) -> r(n)
tendance_strat2 = (g_strat2 + flipud(r_strat2)) / 2; % 4. g(n) + r(-n) (divisé par 2 pour normaliser)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% VISUALISATION COMPARATIVE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure('Name', 'Étape 2c : Filtres à phase nulle', 'Color', 'w');
plot(y, 'Color', [0.7 0.7 0.7], 'LineWidth', 1, 'DisplayName', 'Signal intégré y');
hold on;
plot(tendance_strat1, 'r-', 'LineWidth', 1.8, 'DisplayName', 'Stratégie 1 (Aller-retour / filtfilt)');
plot(tendance_strat2, 'b--', 'LineWidth', 1.8, 'DisplayName', 'Stratégie 2 (Sommation)');
legend('Location', 'northwest');
title(['Comparaison des filtres à phase nulle (N = ', num2str(N), ')']);
xlabel('Indice n'); ylabel('Amplitude');
grid on;

```

---