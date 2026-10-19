function y = etape1(x)
    y = x - mean(x, "all"); % centrage processsus x
    y = cumtrapz(y); % intégration de y par la méthode des trapèzes
end