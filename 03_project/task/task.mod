set PRODUCTS;
set COMPONENTS;
set OBJECTIVES;
set MAX_OBJECTIVES;
set MIN_OBJECTIVES;

param PRODUCT_INCOME{p in PRODUCTS};
param EMITTED_POLLUTANTS{p in PRODUCTS};
param PRODUCTION_COST{p in PRODUCTS};
param PRODUCT_COMPONENTS{p in PRODUCTS, c in COMPONENTS};

param COMPONENT_USAGE_HARD_LIMIT{c in COMPONENTS};
param MINIMAL_PRODUCTION{p in PRODUCTS};

param MIN_INCOME;
param MAX_EMISSIONS;
param MAX_COST;

param ASPIRATIONS{o in OBJECTIVES};

#############################################################################

var production{p in PRODUCTS} >= 0;

var component_usage{c in COMPONENTS};

var income;

var emissions;

var cost;

#############################################################################

var objectives{o in OBJECTIVES};
s.t. objectives_1: objectives['S1'] = component_usage['S1'];
s.t. objectives_2: objectives['S2'] = component_usage['S2'];
s.t. objectives_3: objectives['income'] = income;
s.t. objectives_4: objectives['emissions'] = emissions;
s.t. objectives_5: objectives['cost'] = cost;

#############################################################################

var hard_limits{o in OBJECTIVES};
s.t. hard_limits_1: hard_limits['S1'] = COMPONENT_USAGE_HARD_LIMIT['S1'];
s.t. hard_limits_2: hard_limits['S2'] = COMPONENT_USAGE_HARD_LIMIT['S2'];
s.t. hard_limits_3: hard_limits['income'] = MIN_INCOME;
s.t. hard_limits_4: hard_limits['emissions'] = MAX_EMISSIONS;
s.t. hard_limits_5: hard_limits['cost'] = MAX_COST;

#############################################################################

subject to component_usage_constraint{c in COMPONENTS}:
	component_usage[c] = sum{p in PRODUCTS} PRODUCT_COMPONENTS[p, c] * production[p];

subject to income_constraint:
	income = (sum{p in PRODUCTS} PRODUCT_INCOME[p] * production[p]) - cost;

subject to emissions_constraint:
	emissions = sum{p in PRODUCTS} EMITTED_POLLUTANTS[p] * production[p];
	
subject to cost_constraint:
	cost = sum{p in PRODUCTS} PRODUCTION_COST[p] * production[p];

#############################################################################

subject to component_usage_hard_limit_constraint{c in COMPONENTS}:
	component_usage[c] <= COMPONENT_USAGE_HARD_LIMIT[c];
	
subject to minimal_production_constraint{p in PRODUCTS}:
	production[p] >= MINIMAL_PRODUCTION[p];

#############################################################################

subject to min_income_constraint:
	income >= MIN_INCOME;

subject to max_emissions_constraint:
	emissions <= MAX_EMISSIONS;

subject to max_cost_constraint:
	cost <= MAX_COST;
