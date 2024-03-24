reset;

set NODES;
set NODES_WITHOUT;

param CAPACITY{f in NODES, t in NODES};

data 1-2-parameters.dat;

#############################################################################

# Przep�yw nie mo�e by� negatywny:
var flow{f in NODES, t in NODES} >= 0;

# Ca�kowity przep�yw nie mo�e by� negatywny:
var total_flow >= 0;

#############################################################################
	
# Z pierwszego w�z�a wyp�ywa F_GIVEN jednostek:
subject to initial_flow_constraint:
	sum{z in NODES} flow["s", z] = total_flow;

# Suma wp�ywaj�cych jednostek i wyp�ywaj�cych do danego w�z�a powinna by� r�wna:
subject to kirchhoffs_law_constraint{v in NODES_WITHOUT}:
	sum{z in NODES} flow[v, z] = sum{u in NODES} flow[u, v];

# Przep�yw przez dan� �cie�k� nie mo�e przekroczy� maksymalnego przep�ywu:
subject to flow_constraint{f in NODES, t in NODES}:
	flow[f, t] <= CAPACITY[f, t];

#############################################################################

maximize max_total_flow:
    total_flow;

#############################################################################

option solver cplex;
solve;

display flow;
display total_flow;
