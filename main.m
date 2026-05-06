clear; clc;

params = parameters();

results = encore_simulation(params);

mkdir('sample_output');

writetable(table(results.time', results.alive', ...
    'VariableNames', {'time','alive_nodes'}), ...
    'sample_output/alive_vs_time.csv');

writetable(table(results.time', results.energy', ...
    'VariableNames', {'time','residual_energy'}), ...
    'sample_output/energy_vs_time.csv');

writetable(table(results.time', results.throughput', ...
    'VariableNames', {'time','throughput'}), ...
    'sample_output/throughput_vs_time.csv');

disp('Simulation completed');