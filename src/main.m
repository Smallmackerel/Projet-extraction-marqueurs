clear;
clc;

%%%%%%%%% Étape 2.2 : %%%%%%%%%

N_ech = 2000;

theta_0 = pi/3;
r = 0.95;

z_1 = r*exp(1i*theta_0);
z_2 = conj(z_1);
z_3 = r*exp(1i*theta_0);
z_4 = conj(z_1);


fn = -1/2:1/N_ech:1/2-1/N_ech; 