reset;

set NODES;
set NODES_WITHOUT;
set NODES_WITHOUT_s;
set NODES_WITHOUT_t;

param CAPACITY{u in NODES, v in NODES};

data 1-3-parameters.dat;

#############################################################################

var d{f in NODES, t in NODES} >= 0;

var z{v in NODES};

#############################################################################

subject to s_constraint:
	z['s'] = 1;

subject to t_constraint:
	z['t'] = 0;

subject to first_constraint{u in NODES, v in NODES}: CAPACITY[u, v] != 0 ==>
	d[u, v] - z[u] + z[v] >= 0;

#############################################################################

minimize minimize_total_capacity_of_edges_in_cut:
    sum{u in NODES, v in NODES} CAPACITY[u, v] * d[u, v];

#############################################################################

option solver cplex;
solve;

display d;
display z;
