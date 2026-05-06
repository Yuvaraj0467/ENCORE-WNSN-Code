function p = parameters()

p.NUM_NODES = 350;
p.ROUNDS = 1000;
p.TX_RANGE = 0.0015;

p.INIT_ENERGY = 800e-9;
p.E_ELEC = 50e-12;
p.E_AMP = 5e-9;

p.AREA = [0.01, 0.01, 0.004];
p.SINK = [0.005, 0.005, 0.002];

p.packet_interval = 0.5;

end