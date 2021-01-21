function [xNash, costNash, costLink] = ComputeNashFlow(G, A, b, ODs)

% extract dimensions
numEdge = G.numedges;
numDmnd = size(ODs, 1);

% create decision variables
xFull = sdpvar(numEdge*(numDmnd+1), 1);
xLink = xFull(1:numEdge, 1);

% extract vector values
FFT = G.Edges.FreeFlowTime;
B   = G.Edges.B;
Pow = G.Edges.Power;
Cap = G.Edges.Capacity;

% compute intermediate values
PowPlus   = Pow + 1;
CapPow    = Cap .^ Pow;
BOverC    = B ./ CapPow;
CoeffPoly = FFT .* BOverC ./ (Pow + 1);
CoeffLin  = FFT;
intCost   = CoeffLin .* xLink + CoeffPoly .* (xLink .^ PowPlus);

% solve optimization
Constraints = [A * xFull == b, xFull >= 0, xLink <= Cap];
Objective = sum(intCost);
options = sdpsettings('verbose', 0);
solution = optimize(Constraints, Objective, options);

% exit if optimization not feasible
if solution.problem
    error('optimizaton not feasible')
end

% compute return values
xNash = value(xLink);
costLink = FFT .* (1 + BOverC .* (xNash .^ Pow));
costNash = sum(xNash .* costLink);

% set super small values zero
epsilon = 1e-5;
indZeroX = xNash < epsilon;
xNash(indZeroX) = 0;

end