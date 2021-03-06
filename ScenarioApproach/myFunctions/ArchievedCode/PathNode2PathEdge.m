function [pathEdges] = PathNode2PathEdge(G, pathNodes)

starts = pathNodes(1:end-1);
targets = pathNodes(2:end);
pathEdges = findedge(G, starts, targets);
pathEdges = G.Edges.LinkIndex(pathEdges)';

end