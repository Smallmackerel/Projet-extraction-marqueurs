% 2c)

function t = tendance_phase_nulle(y,b,a, strategie) % b et a : coefficients de h

if strategie == 1  
    % Stratégie 1 : g(n)=y(n)*h(n); r(n)=g(-n)*h(n); sortie : r(-n)
    y = y(:); 
    g = filter(b, a, y); % G=H.Y
    r = filter(b, a, flipud(g)); % R=H.G*=H.H*.Y*
    t = flipud(r); % Z(w) = |H²|.Y*
    % --> Gain réel et positif donc phase nulle pour tout h réel et stable

else
    % Stratégie 2 : g(n)=x(n)*h(n); r(n)=x(-n)*h(n); sortie : g(n)+r(-n)
    x = x(:);
    g = filter(b, a, x); % G=H.X
    r = filter(b, a, flipud(x)); % R=H.X* 
    t = g + flipud(r); % Z(w) = H.X + H*.X = X.(H + H*) = 2Re(H).X(w)
    % --> Gain réel donc phase nulle si 

end
end
