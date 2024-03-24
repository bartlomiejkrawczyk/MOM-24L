reset;

set NODES;
set NODES_WITHOUT;

param F_GIVEN;

param TIME{f in NODES, t in NODES};
param CAPACITY{f in NODES, t in NODES};

data 2-3-parameters.dat;

#############################################################################

var flow{f in NODES, t in NODES} integer >= 0;

var total_time >= 0;

#############################################################################

subject to total_time_constraint{f in NODES, t in NODES}:
	total_time >= TIME[f, t] * flow[f, t];
	
subject to initial_flow_constraint:
	sum{z in NODES} flow["s", z] = F_GIVEN;

subject to kirchhoffs_law_constraint{v in NODES_WITHOUT}:
	sum{z in NODES} flow[v, z] = sum{u in NODES} flow[u, v];

subject to flow_constraint{f in NODES, t in NODES}:
	flow[f, t] <= CAPACITY[f, t];

#############################################################################

minimize min_total_time:
    total_time;

#############################################################################

option solver cplex;
solve;

display flow;
display total_time;
