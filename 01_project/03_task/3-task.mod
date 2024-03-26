reset;

set POINTS;
set DEVIATION_MULTIPLIERS;

param BASE_PLAN{p in POINTS};

data 3-parameters.dat;

#############################################################################

var plan{p in POINTS} >= 0;
var deviation{p in POINTS, d in DEVIATION_MULTIPLIERS} >= 0;

var deviation_display{p in POINTS};

var total_deviation >= 0;
var max_deviation >= 0;

#############################################################################

subject to deviation_constraint{p in POINTS}:
    deviation[p, 1] - deviation[p, -1] = BASE_PLAN[p] - plan[p];

subject to max_deviation_constraint{p in POINTS, d in DEVIATION_MULTIPLIERS}:
    max_deviation >= deviation[p, d];

subject to total_deviation_constraint:
    sum{p in POINTS, d in DEVIATION_MULTIPLIERS} deviation[p, d] = total_deviation;

subject to 1_3_8_sum_constraint:
    plan[1] + plan[3] + plan[8] >= 1.12 * (BASE_PLAN[1] + BASE_PLAN[3] + BASE_PLAN[8]);

subject to 3_5_sum_constraint:
    plan[3] + plan[5] <= 0.93 * (BASE_PLAN[3] + BASE_PLAN[5]);

subject to 3_7_constraint:
    plan[3] >= 0.8 * plan[7];
    
#############################################################################

subject to deviation_display_constraint{p in POINTS}:
	deviation_display[p] = deviation[p, 1] - deviation[p, -1];

#############################################################################

minimize weighted_average_deviation:
    max_deviation + 0.1 * total_deviation;

#############################################################################

option solver cplex;
solve;

display plan;
display deviation;
display deviation_display;
display total_deviation;
display max_deviation;
