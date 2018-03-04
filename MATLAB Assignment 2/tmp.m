L = 2E-6
C = 50E-12
R = 5000
R_L = 3330

clf

for i = 1:size(R_L, 2)
    num = [L/R 0];
    den = [L*C L*((1/R)+(1/R_L)) 1];
    
    sys = tf(num, den)
    bode(sys)
    
end

size(R_L)