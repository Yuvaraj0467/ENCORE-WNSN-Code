function CH = encore_clustering(nodes, sink, k)

dist = vecnorm(nodes - sink,2,2);
[~,idx] = sort(dist);

CH = idx(1:k);

end