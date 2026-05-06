function results = encore_simulation(p)

rng(1); % reproducibility

nodes = rand(p.NUM_NODES,3).*p.AREA;
energy = p.INIT_ENERGY * (0.9 + 0.2*rand(p.NUM_NODES,1));
alive = true(p.NUM_NODES,1);

alive_hist = zeros(1,p.ROUNDS);
energy_hist = zeros(1,p.ROUNDS);
throughput_hist = zeros(1,p.ROUNDS);


% clustering
CH = encore_clustering(nodes, p.SINK, round(p.NUM_NODES/10));

for r=1:p.ROUNDS
    
    successes = 0;
    
    for i=1:p.NUM_NODES
        
        if ~alive(i), continue; end
        
        % choose nearest CH or sink
        d_sink = norm(nodes(i,:) - p.SINK);
        d_ch = min(vecnorm(nodes(CH,:) - nodes(i,:),2,2));
        
        if d_sink < d_ch
            d = d_sink;
        else
            d = d_ch;
        end
        
        % energy
        bits = 600;  % packet size
        
        e_tx = (p.E_ELEC * bits) + (p.E_AMP * bits * d^2);

        % distance-based penalty (NEW)
        e_tx = e_tx * (1 + 0.3 * (d / max(p.AREA)));
        
        % randomness
        e_tx = e_tx * (0.9 + 0.2*rand);
        e_tx = e_tx + 5e-13;
        energy(i) = energy(i) - e_tx;
        
        if energy(i) <= 1e-12
            energy(i) = 0;
            alive(i) = false;
        else
            % --- PDR MODEL (ADD HERE) ---
            snr = 1/(d^2 + 1e-9);
            pdr = 1/(1 + exp(-5*(log10(1+snr))));
    
            if rand() < pdr
                successes = successes + 1;
            end
        end
        
    end
    
    alive_hist(r) = sum(alive);
    if any(alive)
        energy_hist(r) = mean(energy(alive));
    else
        energy_hist(r) = 0;
    end
    throughput_hist(r) = successes / p.packet_interval;
    
end

results.time = (0:p.ROUNDS-1)*p.packet_interval;
results.alive = alive_hist;
results.energy = energy_hist;
results.throughput = throughput_hist;

end