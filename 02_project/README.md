---
title: "Modelowanie Matematyczne - Projekt 2"
author: Bartłomiej Krawczyk, 310774
geometry: margin=2cm
header-includes:
    - \usepackage{float}
    - \floatplacement{figure}{H}
    - \renewcommand{\figurename}{Rysunek}
---

# Zadanie

Niech będą dane dwa zakłady wytwórcze W1 i W2. Zakład W1 może wytwarzać maksymalnie 52 jednostek produktu P1 i 40
jednostek produktu P2, a zakład W2 62 jednostek produktu P1 i 68 jednostek produktu P2. Transport produktów od
wytwórców do punktów sprzedaży detalicznej odbywa się poprzez magazyny hurtowe. Każdego dnia rano produkty są
przewożone do magazynów a następnie rozwożone z magazynów do punktów sprzedaży.

Oba produkty są przechowywane razem w tych samych magazynach hurtowych. Istnieje magazyn M1 o
pojemności 46 jednostek, który może zostać pozostawiony bez zmian lub być powiększony do pojemności 142 jednostek.
Magazyn M2 może nie być budowany (pojemność 0), może być budowany jako magazyn o pojemności 87 jednostek albo o
pojemności 156 jednostek. Dzienne koszty operacyjne magazynów zależą jedynie od ich wielkości, a nie od ilości faktycznie
składowanych produktów. Koszty te wynoszą odpowiednio

- 0 tys. zł dla magazynu o pojemności 0 jednostek
- 160 tys. zł dla magazynu 1 o pojemności 46 jednostek
- 476 tys. zł dla magazynu 1 o pojemności 142 jednostek
- 316 tys. zł dla magazynu 2 o pojemności 87 jednostek
- 580 tys. zł dla magazynu 2 o pojemności 156 jednostek

Z magazynów produkty są transportowane do trzech punktów sprzedaży detalicznej: S1, S2, S3. Zapotrzebowanie $b_{rj}$ (r=1,2;
j=1,2,3) na poszczególne produkty określa poniższa tabela

$b_{rj}$ | S1 | S2 | S3
---------|----|----|---
P1       | 33 | 32 | 36
P2       | 31 | 24 | 25

Transport produktów odbywa się ciężarówkami. Od wytwórców do magazynów produkty mogą być transportowane dużymi
ciężarówkami o ładowności 21 jednostek i o stałym dziennym koszcie utrzymania równym 5000 zł. Z magazynów do
odbiorców mogą być natomiast transportowane jedynie małymi ciężarówkami o ładowności 10 jednostek i o stałym
dziennymi koszcie utrzymania wynoszącym 1800 zł. Ze względu na duże odległości pojedyncza ciężarówka może danego
dnia wykonać tylko jeden kurs. Pojedyncza ciężarówka jest tak skonstruowana, że może przewozić obydwa produkty
jednocześnie w dowolnych proporcjach.

Jednostkowe koszty transportu są identyczne dla obu produktów. Poniższe tabele podają wyrażone w tys. zł wartości
jednostkowych kosztów transportu od wytwórców do magazynów $c_{ki}$ (k=1,2; i=1,2) oraz od magazynów do punktów
sprzedaży $t_{ij}$ (i=1,2; j=1,2,3)

$c_{ki}$ | M1 | M2
---------|----|---
W1       | 9  | 2
W2       | 6  | 4

$t_{ij}$ | S1 | S2 | S3
---------|----|----|---
M1       | 10 | 16 | 7
M2       | 7  | 14 | 3

Produkty nie są policzalne (np. cement), czyli mogą być dowolnie dzielone pomiędzy magazyny i odbiorców.

Należy ustalić ilości produktów transportowanych na poszczególnych trasach, optymalne wielkości magazynów oraz liczby
ciężarówek, które mają kursować na poszczególnych trasach tak, aby zagwarantować minimalny dzienny koszt dystrybucji
(transportu i magazynowania) produktów.

1. Sformułować model programowania mieszanego liniowego-całkowitoliczbowego. Model powinien zostać zawarty w
sprawozdaniu z wykonania projektu. Należy zdefiniować i opisać wszystkie zmienne występujące w modelu. Funkcja
celu oraz ograniczenia (grupy ograniczeń) muszą zostać dokładnie opisane: funkcja każdego z nich, rola poszczególnych
jego składników itp. Opis modelu musi być czytelny, wyczerpujący i wskazujący na zrozumienie zagadnienia.
Sprawdzający powinien na jego podstawie móc ocenić intencje autora.
2. Sformułować model w postaci do rozwiązania z wykorzystaniem wybranego narzędzia implementacji, np. AMPL, AIMMS.
3. Rozwiązać model, a wynik (wartość funkcji celu oraz wartości zmiennych) przedstawić w sprawozdaniu.


```{.mermaid scale=2 caption="Schemat transportu"}
%%{init:{'theme':'forest', 'flowchart': {'curve':'monotoneX'}}}%%
%% basis, bumpX, linear, monotoneX
%% basis, bumpX, bumpY, cardinal, catmullRom, linear, monotoneX, monotoneY, natural, step, stepAfter, stepBefore
flowchart LR
    W1((W1))
    W2((W2))

    M1((M1))
    M2((M2))

    S1((S1))
    S2((S2))
    S3((S3))

    W1 ----> M1
    W1 ----> M2

    W2 ----> M1
    W2 ----> M2

    M1 ----> S1
    M1 ----> S2
    M1 ----> S3

    M2 ----> S1
    M2 ----> S2
    M2 ----> S3
```

\newpage

# Model programowania mieszanego liniowo-całkowitoliczbowego

## Zbiory

- $W = \{W1, W2\}$ - zbiór dostępnych zakładów wytwórczych,
- $P = \{P1, P2\}$ - zbiór wytwarzanych produktów,
- $M = \{M1, M2\}$ - zbiór magazynów,
- $T = \{NONE, SMALL, LARGE\}$ - zbiór możliwych typów magazynów,
- $S = \{S1, S2, S3\}$ - zbiór dostępnych punktów sprzedaży detalicznej.

## Parametry

- $FACTORY\_MAX\_PRODUCTION_{wp},\ w \in W, p \in P$ - maksymalna ilość produktu $p$, jaką jest w stanie wyprodukować zakład wytwórczy $w$,

$FACTORY\_MAX\_PRODUCTION_{wp}$ | P1 | P2
--------------------------------|----|---
W1                              | 52 | 40
W2                              | 62 | 68

- $FACTORY\_WAREHOUSE\_UNITARY\_TRANSPORT\_COST_{wm},\ w \in W, m \in M$ - jednostkowe koszty transportu produktów z zakładu wytwórczego $w$ do magazynu $m$,

$FACTORY\_WAREHOUSE\_UNITARY\_TRANSPORT\_COST_{wm}$ | M1 | M2
----------------------------------------------------|----|---
W1                                                  | 9  | 2
W2                                                  | 6  | 4

- $WAREHOUSE\_COST_{mt},\ m \in M, t \in T$ - dzienny koszt utrzymania magazynu $m$ typu $t$,

$WAREHOUSE\_COST_{mt}$ | NONE | SMALL  | LARGE
-----------------------|------|--------|-------
M1                     | 0    | 160000 | 476000
M2                     | 0    | 316000 | 580000

- $WAREHOUSE\_MAX\_CAPACITY_{mt},\ m \in M, t \in T$ - pojemność magazynu $m$ typu $t$,

$WAREHOUSE\_MAX\_CAPACITY_{mt}$ | NONE | SMALL | LARGE
--------------------------------|------|-------|------
M1                              | 0    | 46    | 142
M2                              | 0    | 87    | 156

- $WAREHOUSE\_RETAIL\_OUTLET\_UNITARY\_TRANSPORT\_COST_{ms},\ m \in M, s \in S$ - jednostkowe koszty transportu produktów z magazynu $m$ do punktu sprzedaży detalicznej $s$,

$WAREHOUSE\_RETAIL\_OUTLET\_UNITARY\_TRANSPORT\_COST_{ms}$ | S1 | S2 | S3
-----------------------------------------------------------|----|----|---
M1                                                         | 10 | 16 | 7
M2                                                         | 7  | 14 | 3

\newpage

- $RETAIL\_OUTLET\_DEMAND_{ps},\ p \in P, s \in S$ - zapotrzebowanie punktu sprzedaży detalicznej $s$ na produkt $p$,

$RETAIL\_OUTLET\_DEMAND_{ps}$ | S1 | S2 | S3
------------------------------|----|----|---
P1                            | 33 | 32 | 36
P2                            | 31 | 24 | 25

- $LARGE\_TRUCK\_BASE\_COST = 5000$ - bazowy koszt dużej ciężarówki,
- $LARGE\_TRUCK\_CAPACITY = 21$ - ładowność dużej ciężarówki,
- $SMALL\_TRUCK\_BASE\_COST = 1800$ - bazowy koszt małej ciężarówki,
- $SMALL\_TRUCK\_CAPACITY = 10$ - ładowność małej ciężarówki.


## Zmienne decyzyjne

- $factory\_production_{wp},\ w \in W, p \in P$ - ilość produktu $p$ wytwarzana przez zakład wytwórczy $w$,
- $factory\_warehouse\_transport_{wmp},\ w \in W, m \in M, p \in P$ - ilość produktu $p$ transportowana ciężarówkami z zakładu wytwórczego $w$ do magazynu $m$,
- $large\_truck\_count_{wm},\ w \in W, m \in M$ - ilość dużych ciężarówek transportujących produkty z zakładu wytwórczego $w$ do magazynu $m$,
- $factory\_warehouse\_transport\_cost_{wm},\ w \in W, m \in M$ - całkowity koszt transportu produktów dużymi ciężarówkami na trasie z zakładu wytwórczego $w$ do magazynu $m$,
- $warehouse\_type_{mt} \in \{0, 1\},\ m \in M, t \in T$ - zmienna binarna reprezentująca wybór typu $t$ magazynu $m$. Jeden oznacza wybudowanie magazynu, a zero nie budowanie tego typu,
- $warehouse\_cost_{m},\ m \in M$ - dzienny koszt wybudowanego magazynu $m$,
- $warehouse\_retail\_outlet\_transport_{msp},\ m \in M, s \in S, p \in P$ - ilość produktu $p$ transportowana ciężarówkami z magazynu $m$ do punktu sprzedaży detalicznej $s$,
- $small\_truck\_count_{ms},\ m \in M, s \in S$ - liczba małych ciężarówek transportujących produkty z magazynu $m$ do punktu sprzedaży detalicznej $s$,
- $warehouse\_retail\_outlet\_transport\_cost_{ms},\ m \in M, s \in S$ - całkowity koszt transportu produktów małymi ciężarówkami na trasie z magazynu $m$ do punktu sprzedaży detalicznej $s$,
- $total\_cost$ - sumaryczny koszt transportu i magazynowania.

## Funkcja oceny

- $min(total\_cost)$ - minimalizujemy całkowity koszt dystrybucji (transportu i magazynowania).

## Ograniczenia

- Zakład wytwórczy nie może produkować więcej niż pozwalają na to ustalone ograniczenia:

$$
\forall{w \in W, p \in P}: factory\_production_{wp} \leq FACTORY\_MAX\_PRODUCTION_{wp}
$$

- Można transportować tylko tyle produktów ile dana fabryka wyprodukowała:

$$
\forall{w \in W, p \in P}: \sum_{m \in M} factory\_warehouse\_transport_{wmp} = factory\_production_{wp}
$$

- Każdy magazyn może być tylko jednego typu:

$$
\forall{m \in M}: \sum_{t \in T} warehouse\_type_{mt} = 1
$$

- Pierwszy magazyn już istnieje - nie możemy go zdegradować:

$$
warehouse\_type_{M1,NONE} = 0
$$

\newpage

- Koszt magazynu jest zależny od jego wielkości:

$$
\forall{m \in M}: warehouse\_cost_{m} = \sum_{t \in T} warehouse\_type_{mt} * WAREHOUSE\_COST_{mt}
$$

- Każdy magazyn ma określoną pojemność i nie może przyjąć większego transportu:

$$
\forall{m \in M}: 
$$
$$
\sum_{w \in W, p \in P} factory\_warehouse\_transport_{wmp} \leq 
$$
$$
\sum_{t \in T} WAREHOUSE\_MAX\_CAPACITY_{mt} * warehouse\_type_{mt}
$$

- Ilość produktów dostarczona do magazynu musi być równa ilości wywożonej:

$$
\forall{m \in M, p \in P}: 
\sum_{w \in W} factory\_warehouse\_transport_{wmp}
= \sum_{s \in S} warehouse\_retail\_outlet\_transport_{msp}
$$

- Zapotrzebowanie na produkty powinno być spełnione:

$$
\forall{s \in S, p \in P}: \sum_{m \in M} warehouse\_retail\_outlet\_transport_{msp} \ge RETAIL\_OUTLET\_DEMAND_{sp}
$$

- Całkowity transport produktów od wytwórcy do magazynu nie może przekroczyć ładowności ciężarówek transportujących na danej trasie:

$$
\forall{w \in W, m \in M}: 
$$
$$
\sum_{p \in P} factory\_warehouse\_transport_{wmp} \le 
$$
$$
LARGE\_TRUCK\_CAPACITY * large\_truck\_count_{wm}
$$

- Koszt transportu od wytwórcy do magazynu składa się z dziennego kosztu utrzymania ciężarówek i jednostkowego kosztu transportu produktów:

$$
\forall{w \in W, m \in M}: 
$$
$$
factory\_warehouse\_transport\_cost_{wm} =
$$
$$
large\_truck\_count_{wm} * LARGE\_TRUCK\_BASE\_COST
$$
$$
+ FACTORY\_WAREHOUSE\_UNITARY\_TRANSPORT\_COST_{wm} 
$$
$$
* \sum_{p \in P} factory\_warehouse\_transport_{wmp}
$$

- Całkowity transport produktów z magazynu do punktu sprzedaży detalicznej nie może przekroczyć ładowności ciężarówek transportujących na danej trasie:

$$
\forall{m \in M, s \in S}: 
$$
$$
\sum_{p \in P} warehouse\_retail\_outlet\_transport_{msp} \le 
$$
$$
SMALL\_TRUCK\_CAPACITY * small\_truck\_count_{ms}
$$

\newpage

- Koszt transportu od magazynu do punktu sprzedaży detalicznej składa się z dziennego kosztu utrzymania ciężarówek i jednostkowego kosztu transportu produktów:

$$
\forall{m \in M, s \in S}:
$$
$$
warehouse\_retail\_outlet\_transport\_cost\_{ms} =
$$
$$
small\_truck\_count_{ms} * SMALL\_TRUCK\_BASE\_COST
$$
$$
+ WAREHOUSE\_RETAIL\_OUTLET\_UNITARY\_TRANSPORT\_COST_{ms} 
$$
$$
* \sum_{p \in P} warehouse\_retail\_outlet\_transport_{msp}
$$

- Całkowity koszt składa się z kosztu transportu i magazynowania produktów:

$$
total\_cost = 
$$
$$
(\sum_{m \in M} warehouse\_cost_{m}) 
$$
$$
+\ (\sum_{w \in W, m \in M} factory\_warehouse\_transport\_cost_{wm})
$$
$$
+\ (\sum_{m \in M, s \in S} warehouse\_retail\_outlet\_transport\_cost_{ms})
$$

\newpage

# Implementacja modelu

Ograniczenia zostały przeniesione do programu AMPL:

```py
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

param FACTORY_WAREHOUSE_UNITARY_TRANSPORT_COST{f in FACTORY, w in WAREHOUSE};

param WAREHOUSE_RETAIL_OUTLET_UNITARY_TRANSPORT_COST{w in WAREHOUSE, r in RETAIL_OUTLET};

data parameters.dat;

#########################################################################################

var factory_production{f in FACTORY, p in PRODUCT} >= 0;

var factory_warehouse_transport{f in FACTORY, w in WAREHOUSE, p in PRODUCT} >= 0;
var large_truck_count{f in FACTORY, w in WAREHOUSE} integer >= 0;
var factory_warehouse_transport_cost{f in FACTORY, w in WAREHOUSE};

var warehouse_type{w in WAREHOUSE, t in WAREHOUSE_TYPE} integer >= 0;
var warehouse_cost{w in WAREHOUSE};

var warehouse_retail_outlet_transport{w in WAREHOUSE, r in RETAIL_OUTLET, p in PRODUCT} >= 0;
var small_truck_count{w in WAREHOUSE, r in RETAIL_OUTLET} integer >= 0;
var warehouse_retail_outlet_transport_cost{w in WAREHOUSE, r in RETAIL_OUTLET};

var total_cost;

#########################################################################################

# Zakład wytwórczy nie może produkować więcej niż ustalone ograniczenia:

subject to max_factory_production_constraint{f in FACTORY, p in PRODUCT}:
	factory_production[f, p] <= FACTORY_MAX_PRODUCTION[f, p];

# Można transportować tylko tyle produktów ile dana fabryka wyprodukowała:

subject to factory_production_transport_constraint{f in FACTORY, p in PRODUCT}:
	sum{w in WAREHOUSE} factory_warehouse_transport[f, w, p] = factory_production[f, p];
	
# Każdy magazyn może być tylko jednego typu:
	
subject to warehouse_type_constraint{w in WAREHOUSE}:
	sum{t in WAREHOUSE_TYPE} warehouse_type[w, t] = 1;

# Pierwszy magazyn już istnieje - nie możemy się go pozbyć:

subject to first_warehouse_cannot_be_none_constraint:
	warehouse_type["M1", "NONE"] = 0;

# Koszt magazynu jest zależny od jego wielkości:

subject to warehouse_cost_constraint{w in WAREHOUSE}:
	warehouse_cost[w] = sum{t in WAREHOUSE_TYPE} warehouse_type[w, t] * WAREHOUSE_COST[w, t];

# Każdy magazyn ma określoną pojemność i nie może przyjąć większego transportu:

subject to warehouse_capacity_constraint{w in WAREHOUSE}:
	sum{f in FACTORY, p in PRODUCT} factory_warehouse_transport[f, w, p] 
        <= sum{t in WAREHOUSE_TYPE} WAREHOUSE_MAX_CAPACITY[w, t] * warehouse_type[w, t];

# Ilość produktów dostarczona do magazynu musi być równa ilości wywożonej:

subject to incoming_equal_to_outgoing_constraint{w in WAREHOUSE, p in PRODUCT}:
	sum{f in FACTORY} factory_warehouse_transport[f, w, p] 
        = sum{r in RETAIL_OUTLET} warehouse_retail_outlet_transport[w, r, p];

# Zapotrzebowanie na produkty powinno być spełnione:

subject to retail_outlet_demand_transport_constraint{r in RETAIL_OUTLET, p in PRODUCT}:
	sum{w in WAREHOUSE} warehouse_retail_outlet_transport[w, r, p] 
        >= RETAIL_OUTLET_DEMAND[r, p];

# Całkowity transport produktów od wytwórcy do magazynu nie może przekroczyć ładowności 
# ciężarówek transportujących na danej trasie:

subject to factory_warehouse_transport_constraint{f in FACTORY, w in WAREHOUSE}:
	sum{p in PRODUCT} factory_warehouse_transport[f, w, p] 
        <= LARGE_TRUCK_CAPACITY * large_truck_count[f, w];
	
# Koszt transportu od wytwórcy do magazynu składa się z dziennego kosztu utrzymania
# ciężarówek i jednostkowego kosztu transportu produktów:

subject to factory_warehouse_transport_cost_constraint{f in FACTORY, w in WAREHOUSE}:
	large_truck_count[f, w] * LARGE_TRUCK_BASE_COST
		+ FACTORY_WAREHOUSE_UNITARY_TRANSPORT_COST[f, w] 
        * sum{p in PRODUCT} factory_warehouse_transport[f, w, p]
		= factory_warehouse_transport_cost[f, w];

# Całkowity transport produktów z magazynu do punktu sprzedaży detalicznej 
# nie może przekroczyć ładowności ciężarówek transportujących na danej trasie:

subject to warehouse_retail_outlet_transport_constraint{w in WAREHOUSE, r in RETAIL_OUTLET}:
	sum{p in PRODUCT} warehouse_retail_outlet_transport[w, r, p] 
        <= SMALL_TRUCK_CAPACITY * small_truck_count[w, r];

# Koszt transportu od magazynu do punktu sprzedaży detalicznej składa się 
# z dziennego kosztu utrzymania ciężarówek i jednostkowego kosztu transportu produktów:

subject to warehouse_retail_outlet_transport_cost_constraint{w in WAREHOUSE, r in RETAIL_OUTLET}:
	small_truck_count[w, r] * SMALL_TRUCK_BASE_COST
		+ WAREHOUSE_RETAIL_OUTLET_UNITARY_TRANSPORT_COST[w, r] 
        * sum{p in PRODUCT} warehouse_retail_outlet_transport[w, r, p] 
		= warehouse_retail_outlet_transport_cost[w, r];

# Całkowity koszt składa się z kosztu transportu i magazynowania produktów:

subject to total_cost_constraint:
	(sum{w in WAREHOUSE} warehouse_cost[w])
   		+ (sum{f in FACTORY, w in WAREHOUSE} factory_warehouse_transport_cost[f, w])
   		+ (sum{w in WAREHOUSE, r in RETAIL_OUTLET} warehouse_retail_outlet_transport_cost[w, r])
   	= total_cost;

#########################################################################################

minimize total_cost_minimalization:
   total_cost;

#########################################################################################

option solver cplex;
solve;
```

\newpage

Przygotowany plik z danymi numer 8:

```py
data;

set FACTORY := W1 W2;
set PRODUCT := P1 P2;
set WAREHOUSE := M1 M2;
set WAREHOUSE_TYPE := NONE SMALL LARGE;
set RETAIL_OUTLET := S1 S2 S3;

param FACTORY_MAX_PRODUCTION 
	:    P1     P2     :=
	W1   52     40
	W2   62     68;

param WAREHOUSE_COST
	:    NONE   SMALL  LARGE  :=
	M1   0      160000 476000
	M2   0      316000 580000;

param WAREHOUSE_MAX_CAPACITY
	:    NONE   SMALL  LARGE  :=
	M1   0      46     142
	M2   0      87     156;

param RETAIL_OUTLET_DEMAND
    :    P1     P2     :=
    S1   33     31
    S2   32     24
    S3   36     25;

param LARGE_TRUCK_BASE_COST := 5000;
param LARGE_TRUCK_CAPACITY := 21;

param SMALL_TRUCK_BASE_COST := 1800;
param SMALL_TRUCK_CAPACITY := 10;

param FACTORY_WAREHOUSE_UNITARY_TRANSPORT_COST
    :    M1     M2     :=
    W1   9      2
    W2   6      4;

param WAREHOUSE_RETAIL_OUTLET_UNITARY_TRANSPORT_COST
    :    S1     S2     S3    :=
    M1   10     16     7
    M2   7      14     3;

end;
```

\newpage

# Wyniki

<!-- Należy ustalić ilości produktów transportowanych na poszczególnych trasach, optymalne wielkości magazynów oraz liczby
ciężarówek, które mają kursować na poszczególnych trasach tak, aby zagwarantować minimalny dzienny koszt dystrybucji
(transportu i magazynowania) produktów. -->

### Minimalny koszt dystrybucji

W wyniku otrzymujemy minimalny koszt dystrybucji (transportu i magazynowania) produktów równy 823 115 zł.

### Ilości produktów transportowanych na trasach od zakładów wytwórczych do magazynów

| wytwórcy \\ magazyny | M1           | M2          |
|----------------------|--------------|-------------|
| W1                   | P1 0\ \ P2 0 | P1 44 P2 40 |
| W2                   | P1 34\ P2 0  | P1 23 P2 40 |

### Ilości produktów transportowanych na trasach od magazynów do punktów sprzedaży detalicznej

| magazyny \\ punkty sprzedaży | S1           | S2            | S3           |
|------------------------------|--------------|---------------|--------------|
| M1                           | P1 0\ \ P2 0 | P1 30 P2 0    | P1 4\ \ P2 0 |
| M2                           | P1 33 P2 31  | P1 2\ \ P2 24 | P1 32 P2 25  |

### Optymalna rozbudowa magazynów

| magazyny \\ typ | NONE | SMALL | LARGE |
|-----------------|------|-------|-------|
| M1              | 0    | 1     | 0     |
| M2              | 0    | 0     | 1     |

### Liczba dużych ciężarówek

| wytwórcy \\ magazyny | M1 | M2 |
|----------------------|----|----|
| W1                   | 0  | 4  |
| W2                   | 2  | 3  |

### Liczba małych ciężarówek

| magazyny \\ punkty sprzedaży | S1 | S2 | S3 |
|------------------------------|----|----|----|
| M1                           | 0  | 3  | 1  |
| M2                           | 7  | 3  | 6  |

