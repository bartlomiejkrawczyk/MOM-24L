reset;

set NODES;
set NODES_WITHOUT;

param F_GIVEN;

param COST{f in NODES, t in NODES};
param CAPACITY{f in NODES, t in NODES};

data 1-1-parameters.dat;

#############################################################################

# Przep�yw nie mo�e by� negatywny:
var flow{f in NODES, t in NODES} >= 0;

# Ca�kowity koszt nie mo�e by� negatywny:
var total_cost >= 0;

#############################################################################

# Ca�kowity koszt jest sum� kosztu wszystkich przep�yw�w:
subject to total_cost_constraint:
	total_cost = sum{f in NODES, t in NODES} COST[f, t] * flow[f, t];
	
# Z pierwszego w�z�a wyp�ywa F_GIVEN jednostek:
subject to initial_flow_constraint:
	sum{z in NODES} flow["s", z] = F_GIVEN;

# Suma wp�ywaj�cych jednostek i wyp�ywaj�cych do danego w�z�a powinna by� r�wna:
subject to kirchhoffs_law_constraint{v in NODES_WITHOUT}:
	sum{z in NODES} flow[v, z] = sum{u in NODES} flow[u, v];

# Przep�yw przez dan� �cie�k� nie mo�e przekroczy� maksymalnego przep�ywu:
subject to flow_constraint{f in NODES, t in NODES}:
	flow[f, t] <= CAPACITY[f, t];

#############################################################################

minimize min_total_cost:
    total_cost;

#############################################################################

option solver cplex;
solve;

display flow;
display total_cost;
