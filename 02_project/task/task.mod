reset;

set FACTORY;
set PRODUCT;
set WAREHOUSE;
set WAREHOUSE_TYPE;
set RETAIL_OUTLET;

param FACTORY_MAX_PRODUCTION{f in FACTORY, w in PRODUCT};

param WAREHOUSE_COST{w in WAREHOUSE, t in WAREHOUSE_TYPE};
param WAREHOUSE_MAX_CAPACITY{w in WAREHOUSE, t in WAREHOUSE_TYPE};

param RETAIL_OUTLET_DEMAND{r in RETAIL_OUTLET, p in PRODUCT};

param LARGE_TRUCK_BASE_COST;
param LARGE_TRUCK_CAPACITY;

param SMALL_TRUCK_BASE_COST;
param SMALL_TRUCK_CAPACITY;

param FACTORY_WAREHOUSE_TRANSPORT_COST{f in FACTORY, w in WAREHOUSE};

param WAREHOUSE_RETAIL_OUTLET_TRANSPORT_COST{w in WAREHOUSE, r in RETAIL_OUTLET};

data parameters.dat;

#############################################################################

var factory_production{f in FACTORY, p in PRODUCT} >= 0;

var factory_warehouse_transport{f in FACTORY, w in WAREHOUSE, p in PRODUCT} >= 0;
var large_truck_count{f in FACTORY, w in WAREHOUSE} integer >= 0;
var factory_warehouse_transport_cost{f in FACTORY, w in WAREHOUSE};

var warehouse_type{w in WAREHOUSE, t in WAREHOUSE_TYPE} integer >= 0;
var warehouse_cost{w in WAREHOUSE} >= 0;

var warehouse_retail_outlet_transport{w in WAREHOUSE, r in RETAIL_OUTLET, p in PRODUCT} >= 0;
var small_truck_count{w in WAREHOUSE, r in RETAIL_OUTLET} integer >= 0;
var warehouse_retail_outlet_transport_cost{w in WAREHOUSE, r in RETAIL_OUTLET};

var total_cost;

#############################################################################

# Zak³ad wytwórczy nie mo¿e produkowaæ wiêcej ni¿ ustalone ograniczenia:

subject to max_factory_production_constraint{f in FACTORY, p in PRODUCT}:
	factory_production[f, p] <= FACTORY_MAX_PRODUCTION[f, p];

# Mo¿na transportowaæ tylko tyle produktów ile dana fabryka wyprodukowa³a:

subject to factory_production_transport_constraint{f in FACTORY, p in PRODUCT}:
	sum{w in WAREHOUSE} factory_warehouse_transport[f, w, p] = factory_production[f, p];
	
# Ka¿dy magazyn mo¿e byæ tylko jednego typu:
	
subject to warehouse_type_constraint{w in WAREHOUSE}:
	sum{t in WAREHOUSE_TYPE} warehouse_type[w, t] = 1;

# Pierwszy magazyn ju¿ istnieje - nie mo¿emy siê go pozbyæ:

subject to first_warehouse_cannot_be_none_constraint:
	warehouse_type["M1", "NONE"] = 0;

# Koszt magazynu jest zale¿ny od jego wielkoœci:

subject to warehouse_cost_constraint{w in WAREHOUSE}:
	warehouse_cost[w] = sum{t in WAREHOUSE_TYPE} warehouse_type[w, t] * WAREHOUSE_COST[w, t];

# Ka¿dy magazyn ma okreœlon¹ pojemnoœæ i nie mo¿e przyj¹æ wiêkszego transportu:

subject to warehouse_capacity_constraint{w in WAREHOUSE}:
	sum{f in FACTORY, p in PRODUCT} factory_warehouse_transport[f, w, p] <= sum{t in WAREHOUSE_TYPE} WAREHOUSE_MAX_CAPACITY[w, t] * warehouse_type[w, t];

# Iloœæ produktów dostarczona do magazynu musi byæ równa iloœci wywo¿onej:

subject to incoming_equal_to_outgoing_constraint{w in WAREHOUSE, p in PRODUCT}:
	sum{f in FACTORY} factory_warehouse_transport[f, w, p] = sum{r in RETAIL_OUTLET} warehouse_retail_outlet_transport[w, r, p];

# Zapotrzebowanie na produkty powinny byæ spe³nione:

subject to retail_outlet_demand_transport_constraint{r in RETAIL_OUTLET, p in PRODUCT}:
	sum{w in WAREHOUSE} warehouse_retail_outlet_transport[w, r, p] >= RETAIL_OUTLET_DEMAND[r, p];

# Ca³kowity transport produktów od wytwórcy do magazynu nie mo¿e przekroczyæ iloœci ciê¿arówek transportuj¹cych na danej trasie:

subject to factory_warehouse_transport_constraint{f in FACTORY, w in WAREHOUSE}:
	sum{p in PRODUCT} factory_warehouse_transport[f, w, p] <= LARGE_TRUCK_CAPACITY * large_truck_count[f, w];
	
# Koszt transportu od wytwórcy do magazynu sk³ada siê z dziennego kosztu utrzymania ciê¿arówek i jednostkowego kosztu transportu produktów:

subject to factory_warehouse_transport_cost_constraint{f in FACTORY, w in WAREHOUSE}:
	large_truck_count[f, w] * LARGE_TRUCK_BASE_COST
		+ FACTORY_WAREHOUSE_TRANSPORT_COST[f, w] * sum{p in PRODUCT} factory_warehouse_transport[f, w, p]
		= factory_warehouse_transport_cost[f, w];

# Ca³kowity transport produktów z magazynu do punktu sprzeda¿y detalicznej nie mo¿e przekroczyæ iloœci ciê¿arówek transportuj¹cych na danej trasie:

subject to warehouse_retail_outlet_transport_constraint{w in WAREHOUSE, r in RETAIL_OUTLET}:
	sum{p in PRODUCT} warehouse_retail_outlet_transport[w, r, p] <= SMALL_TRUCK_CAPACITY * small_truck_count[w, r];

# Koszt transportu od magazynu do punktu sprzeda¿y detalicznej sk³ada siê z dziennego kosztu utrzymania ciê¿arówek i jednostkowego kosztu transportu produktów:

subject to warehouse_retail_outlet_transport_cost_constraint{w in WAREHOUSE, r in RETAIL_OUTLET}:
	small_truck_count[w, r] * SMALL_TRUCK_BASE_COST
		+ WAREHOUSE_RETAIL_OUTLET_TRANSPORT_COST[w, r] * sum{p in PRODUCT} warehouse_retail_outlet_transport[w, r, p] 
		= warehouse_retail_outlet_transport_cost[w, r];

# Ca³kowity koszt sk³ada siê z kosztu transportu i magazynowania produktów:

subject to total_cost_constraint:
	(sum{w in WAREHOUSE} warehouse_cost[w])
   		+ (sum{f in FACTORY, w in WAREHOUSE} factory_warehouse_transport_cost[f, w])
   		+ (sum{w in WAREHOUSE, r in RETAIL_OUTLET} warehouse_retail_outlet_transport_cost[w, r])
   	= total_cost;

#############################################################################

minimize weighted_average_deviation:
   total_cost;

#############################################################################

option solver cplex;
solve;

display factory_production;

display factory_warehouse_transport;
display large_truck_count;
display factory_warehouse_transport_cost;

display warehouse_type;
display warehouse_cost;

display warehouse_retail_outlet_transport;
display small_truck_count;
display warehouse_retail_outlet_transport_cost;

display total_cost;
