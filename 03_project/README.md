---
title: "Modelowanie Matematyczne - Projekt 3"
author: Bartłomiej Krawczyk, 310774
geometry: margin=2cm
header-includes:
    - \usepackage{float}
    - \floatplacement{figure}{H}
    - \renewcommand{\figurename}{Rysunek}
---

# Zadanie

### Zestaw 6_JG

## Opis modelowanego problemu:

Przedsiębiorstwo produkuje trzy produkty $P1$, $P2$, $P3$ (sztuki). Każdy z tych produktów potrzebuje trzech różnych składników $S1$, $S2$, $S3$ (kg/jednostkę). Każdy z produktów ma inną ceną jednostkową sprzedaży $C_{P1}$, $C_{P2}$, $C_{P3}$ (tyś.PLN/jednostkę). Firma zwraca uwagę na ekologię i szacuje jednostkowy poziom zanieczyszczeń emitowanych dla poszczególnych produktów $Z_{P1}$, $Z_{P2}$, $Z_{P3}$ (kg/jednostkę). Dostępne
są również jednostkowe koszty produkcji $K_{P1}$, $K_{P2}$, $K_{P3}$ (tyś.PLN/jednostkę).

Ograniczenia:

1. Nie można użyć więcej niż 110 kg składnika $S1$, ale 100 kg jest akceptowalne.
2. Zaleca się użycie 50 kg składnika $S2$, ale zużycie powyżej 55 kg nie jest akceptowalne.
3. Nie jest akceptowalne zużycie składnika $S3$ powyżej 50 kg.
4. Zakłada się się, że produkcja produktu $P1$ powinna być nie mniejsza niż 3 sztuki, a produktu $P3$ nie mniejsza niż 5 sztuk.

Cele postawione przez zarządzających firmą:

1. Maksymalizacja zysków; dążenie do zysku na poziomie 150 tyś. PLN, ale akceptowalny jest zysk na poziomie 130 tyś PLN.
2. Minimalizacja emisji zanieczyszczeń; dążenie do emisji na poziomie 30 kg, ale poziom 35 kg jest akceptowalny.
3. Minimalizacja kosztów produkcji; dążenie do kosztów na poziomie 70 tyś. PLN, ale koszty na poziomie 80 tyś. są akceptowalne.

### Polecenia do wykonania:

1. (2) Sformułować i opisać wielokryterialny model planowania produkcji z wykorzystaniem metody punktu odniesienia.
2. (3) Sformułować i opisać wielokryterialny model optymalnego planowania produkcji z wykorzystaniem zbiorów rozmytych.
3. (10) Sformułować równoważne zadanie optymalizacji dla zadania 2 z wykorzystaniem zbiorów rozmytych adaptując podejście Zimmermana dla więcej niż jednego kryterium.
4. (3) Zapisz zadanie/zadania sformułowane w punkcie 1 w postaci do rozwiązania z wykorzystaniem wybranego narzędzia implementacji (np. AMPL, AIMMS) i rozwiąż to zadanie/zadania. W przypadku niedopuszczalności zadania zaproponuj zmianę celów i/lub innych parametrów.
5. (7) Zapisz zadania sformułowane w punkcie 3 w postaci do rozwiązania z wykorzystaniem wybranego narzędzia implementacji (np. AMPL, AIMMS) i rozwiąż te zadania. W przypadku niedopuszczalności zadania zaproponuj zmianę celów i/lub innych parametrów.
6. (3) Porównaj rozwiązania zadań z poprzednich dwóch punktów.
7. (2) Rozwiąż zadanie z punktu 2 za pomoca pakietu R – FuzzyLP. Należy w obliczeniach rozpatrywać niezależnie każde z kryteriów.
8. (3) Zaproponuj i zastosuj graficzną formę analizy rozwiązań.
9. (2) Opisz zalety i wady modelowania opisanego problemu z wykorzystaniem zbiorów rozmytych.

### Dane:

produkt | S1 | S2 | S3 | Cx | Zx | Kx
--------|----|----|----|----|----|---
P1      | 2  | 8  | 4  | 9  | 1  | 1
P2      | 10 | 1  | 0  | 21 | 1  | 3
P3      | 4  | 4  | 2  | 11 | 3  | 3

produkt [sztuki] \\ składniki [kg/jednostkę] | S1 | S2 | S3
---------------------------------------------|----|----|---
P1                                           | 2  | 8  | 4
P2                                           | 10 | 1  | 0
P3                                           | 4  | 4  | 2

produkt [sztuki] \\ cena jednostkowa [tyś.PLN/jednostkę] | Cx
---------------------------------------------------------|---
P1                                                       | 9
P2                                                       | 21
P3                                                       | 11

produkt [sztuki] \\ emitowane zanieczyszczenia [kg/jednostkę] | Zx
--------------------------------------------------------------|---
P1                                                            | 1
P2                                                            | 1
P3                                                            | 3

produkt [sztuki] \\ koszty produkcji [tyś.PLN/jednostkę] | Kx
---------------------------------------------------------|---
P1                                                       | 1
P2                                                       | 3
P3                                                       | 3

\newpage

# Opracowany domyślny model

Został przygotowany bazowy model na bazie, który w zależności od podpunktu zadania został rozbudowany o dodatkowe zbiory, parametry, zmienne decyzyjne, ograniczenia i funkcje oceny.

## Zbiory

- $PRODUCTS = \{P1, P2, P3\}$ - zbiór możliwych do wyprodukowania produktów,
- $COMPONENTS = \{S1, S2, S3\}$ - zbiór składników, z których wytwarzane są produkty,
- $OBJECTIVES = \{S1, S2, income, emissions, cost\}$ - zbiór nazwanych zmiennych decyzyjnych, dla których ustalone są aspiracje. Tak zdefiniowany zbiór pozwala na uproszczenie zapisu niektórych ograniczeń,
- $MAX\_OBJECTIVES = \{income\}$ - dodatkowy zbiór zmiennych decyzyjnych, które należy maksymalizować,
- $MIN\_OBJECTIVES = \{S1, S2, emissions, cost\}$ - zbiór zmiennych decyzyjnych, które należy minimalizować.

## Parametry

- $PRODUCT\_INCOME[p],\ p \in PRODUCTS$ - jednostkowa cena sprzedaży produktów $p$ (tyś.PLN/jednostkę),

$PRODUCTS$ | $PRODUCT\_INCOME[p]$
-----------|---------------------
P1         | 9
P2         | 21
P3         | 11

- $EMITTED\_POLLUTANTS[p],\ p \in PRODUCTS$ - jednostkowy poziom zanieczyszczeń emitowanych dla poszczególnych produktów $p$ (kg/jednostkę),

$PRODUCTS$ | $EMITTED\_POLLUTANTS[p]$
-----------|-------------------------
P1         | 1
P2         | 1
P3         | 3

- $PRODUCTION\_COST[p],\ p \in PRODUCTS$ - jednostkowe koszty produkcji produktu $p$ (tyś.PLN/jednostkę),

$PRODUCTS$ | $PRODUCTION\_COST[p]$
-----------|----------------------
P1         | 1
P2         | 3
P3         | 3

- $PRODUCT\_COMPONENTS[p][c],\ p \in PRODUCTS,\ c \in COMPONENTS$ - wymagana ilość składnika $c$ do wytworzenia produktu $p$.

$PRODUCT\_COMPONENTS[p][c]$ | S1 | S2 | S3
----------------------------|----|----|---
P1                          | 2  | 8  | 4
P2                          | 10 | 1  | 0
P3                          | 4  | 4  | 2

Dodatkowe parametry wynikające z zadanych ograniczeń:

- $COMPONENT\_USAGE\_HARD\_LIMIT[c],\ c \in COMPONENTS$ - maksymalna ilość składnika $c$ jaką można wykorzystać,

$COMPONENTS$ | $COMPONENT\_USAGE\_HARD\_LIMIT[c]$
-------------|-----------------------------------
S1           | 110
S2           | 55
S3           | 50

- $MINIMAL\_PRODUCTION[p],\ p \in PRODUCTS$ - minimalna ilość sztuk produktu $p$ jaką należy wyprodukować,

$PRODUCTS$ | $MINIMAL\_PRODUCTION[p]$
-----------|-------------------------
P1         | 3
P2         | 0
P3         | 5


- $MIN\_INCOME = 130$ - minimalny akceptowalny poziom zarobków,
- $MAX\_EMISSIONS = 35$ - maksymalny akceptowalny poziom emisji zanieczyszczeń,
- $MAX\_COST = 80$ - maksymalny akceptowalny koszt wytwarzania wszystkich produktów.

Parametry wynikające z zadanych aspiracji:

- $ASPIRATIONS[o],\ o \in OBJECTIVES$ - aspiracje ustalone dla poszczególnych zmiennych decyzyjnych.

$OBJECTIVES$ | $ASPIRATIONS[o]$
-------------|-----------------
S1           | 100
S2           | 50
income       | 150
emissions    | 30
cost         | 70

## Zmienne decyzyjne

- $production[p],\ p \in PRODUCTS$ - zmienna reprezentująca ilość wyprodukowanych produktów typu $p$,
- $component\_usage[c],\ c \in COMPONENTS$ - reprezentuje całkowite wykorzystanie składnika typu $c$ do produkcji wszystkich produktów,
- $income$ - zmienna pomocnicza oznaczająca całkowity zysk ze sprzedaży produktów,
- $emissions$ - całkowite zanieczyszczenia wyemitowane podczas produkcji wszystkich produktów,
- $cost$ - sumaryczne koszty produkcji wyrobów.

W celu prostszego zapisu wzorów na zadane aspiracje został zdefiniowany dodatkowy wektor zmiennych decyzyjnych:

- $objectives[o],\ o \in OBJECTIVES$ - zmienna agregująca wartości kilku innych zmiennych decyzyjnych. W ramach tej zmiennej zostały także zdefiniowane odpowiednie ograniczenia:
$$
objectives[S1] = component\_usage[S1]
$$
$$
objectives[S2] = component\_usage[S2]
$$
$$
objectives[income] = income
$$
$$
objectives[emissions] = emissions
$$
$$
objectives[cost] = cost
$$

W celu prostszego zapisu wzorów na zadane nieakceptowalne poziomy został zdefiniowany dodatkowy wektor zmiennych decyzyjnych:

- $hard\_limits[o],\ o \in OBJECTIVES$ - zmienna agregująca wartości kilku innych parametrów. W ramach tej zmiennej zostały także zdefiniowane odpowiednie ograniczenia:
$$
hard\_limits[S1] = COMPONENT\_USAGE\_HARD\_LIMIT[S1];
$$
$$
hard\_limits[S2] = COMPONENT\_USAGE\_HARD\_LIMIT[S2];
$$
$$
hard\_limits[income] = MIN\_INCOME;
$$
$$
hard\_limits[emissions] = MAX\_EMISSIONS;
$$
$$
hard\_limits[cost] = MAX\_COST;
$$

## Ograniczenia

Ograniczenia wynikające z treści:

- Poszczególne składniki są wykorzystywane do produkcji różnych produktów w różnych proporcjach:
$$
\forall{c \in COMPONENTS}:
$$
$$
component\_usage[c] = \sum_{p \in PRODUCTS} PRODUCT\_COMPONENTS[p, c] \cdot production[p]
$$

- Na całkowity zysk składają się zarobki ze sprzedaży wyprodukowanych wyrobów pomniejszone o koszty produkcji:
$$
income = (\sum_{p \in PRODUCTS} PRODUCT\_INCOME[p] \cdot production[p]) - cost
$$

- Całkowity emisje są rezultatem zanieczyszczeń wytworzonych podczas produkcji poszczególnych produktów:
$$
emissions = \sum_{p \in PRODUCTS} EMITTED\_POLLUTANTS[p] \cdot production[p]
$$

- Całkowite koszty produkcji składają się z kosztów wytworzenia poszczególnych produktów:
$$
cost = \sum{p \in PRODUCTS} PRODUCTION\_COST[p] \cdot production[p]
$$

Ograniczenia wynikające z zadanych ograniczeń:

- Zadane są limity wykorzystania poszczególnych składników, których przekroczenie jest nieakceptowalne:
$$
\forall{c \in COMPONENTS}: component\_usage[c] \le COMPONENT\_USAGE\_HARD\_LIMIT[c]
$$

- Narzucona jest minimalna produkcja poszczególnych produktów:
$$
\forall{p \in PRODUCTS}: production[p] \ge MINIMAL\_PRODUCTION[p]
$$

- Oczekujemy minimalnych zysków na poziomie $MIN\_INCOME$:
$$
income \ge MIN\_INCOME
$$

- Można wyprodukować maksymalnie $MAX\_EMISSIONS$ zanieczyszczeń:
$$
emissions \le MAX\_EMISSIONS
$$

- Koszty produkcji nie mogą przekroczyć $MAX\_COST$:
$$
cost \le MAX\_COST
$$

## Funkcja oceny

Funkcje oceny, które są optymalizowane będą zdefiniowane oddzielnie w zależności od rozwiązywanego podpunktu.

\newpage

# 1. Sformułować i opisać wielokryterialny model planowania produkcji z wykorzystaniem metody punktu odniesienia.

Model bazuje na przygotowanym modelu podstawowym. W tym rozdziale zostaną zdefiniowane jedynie dodatkowe parametry, ograniczenia, i zmienne decyzyjne. Zostały one zdefiniowane, by wykorzystać metodę punktu odniesienia.

## Zbiory

- $RANGE = \{utopia, nadir\}$ - zbiór pozwalający na ustalenie zakresu dla zmiennych celu.

## Parametry

- $\beta = 10^{-3}$ - parametr pozwalający na ograniczenie wzrostu wartości funkcji oceny dla zmiennych decyzyjnych ponad zadany poziom aspiracji. Funkcja oceny dla parametrów, które ten poziom osiągnęły będzie rosła o $\beta$ wolniej, niż dla tych zmiennych, które tego poziomu nie osiągnęły,
- $\varepsilon  = 10^{-4} / 5 = 2 \cdot 10^{-5}$ - parametr z wagą jaką będziemy przyjmować dla sumy zmiennych celu. Zapewnia on, że każde otrzymane rozwiązanie będzie efektywne,
- $OBJECTIVE\_RANGE[o][r],\ o \in OBJECTIVES,\ r \in RANGE$ - wyliczone na podstawie bazowego modelu dla każdej zmiennej celu wartości utopii i nadiru:

$OBJECTIVE\_RANGE[o][r]$ | utopia | nadir
-------------------------|--------|------
S1                       | 64     | 106
S2                       | 48     | 55
income                   | 208    | 134
emissions                | 22     | 28
cost                     | 30     | 42

## Zmienne decyzyjne

- $\lambda[o],\ o \in OBJECTIVES$ - parametry normalizujące zakres zmienności kryteriów. Wyliczone na bazie wartości utopii i nadiru dla poszczególnych celów $o$,
- $accomplishment[o],\ o \in OBJECTIVES$ - wyznaczony poziom zadowolenia z osiągnięcia poszczególnych wartości zmiennych celu $o$,
- $lower\_bound$ - dolne ograniczenie wszystkich poziomów zadowolenia z osiągnięcia aspiracji.

## Ograniczenia

- Wyliczamy parametr normalizujący $\lambda$ na bazie wartości utopii i nadiru:
$$
\lambda[o] = 1 / (OBJECTIVE\_RANGE[o][utopia] - OBJECTIVE\_RANGE[o][nadir])
$$

- Wprowadzamy zmienną $lower\_bound$, która będzie mniejsza niż każde z poziomów zadowolenia:
$$
\forall{o \in OBJECTIVES}: lower\_bound \le accomplishment[o]
$$

- Poziom zadowolenia dla wartości przekraczających aspirację będzie pomniejszony o $\beta$:
$$
\forall{o \in OBJECTIVES}: accomplishment[o] \le \beta \cdot \lambda[o] \cdot (objectives[o] - ASPIRATIONS[o])
$$

- Poziom zadowolenia będzie rósł liniowo zgodnie z wartościami celu, do osiągnięcia poziomu aspiracji:
$$
\forall{o \in OBJECTIVES}: accomplishment[o] \le \lambda[o] \cdot (objectives[o] - ASPIRATIONS[o])
$$

## Funkcja oceny

- W pierwszej kolejności maksymalizujemy najmniejszy poziom zadowolenia, a z mniejszą wagą maksymalizujemy całkowite zadowolenie:
$$
max(lower\_bound + \varepsilon  \cdot \sum_{o \in OBJECTIVES} accomplishment[o])
$$

\newpage

# 2. Sformułować i opisać wielokryterialny model optymalnego planowania produkcji z wykorzystaniem zbiorów rozmytych.

Model bazuje na przygotowanym modelu podstawowym. W tym rozdziale zostaną zdefiniowane jedynie dodatkowe parametry, ograniczenia, ograniczenia rozmyte, zmienne decyzyjne i cele rozmyte. Zostały one zdefiniowane, by wykorzystać metodę zbiorów rozmytych.

## Zmienne decyzyjne

- $tolerance[o], o \in OBJECTIVES$ - zmienna reprezentująca rozmycie ograniczeń (wartość stała). Zostało przyjęte, że dla zmiennych z górnym nieakceptowalnym ograniczeniem wartość jest dodatnia, a z dolnym ograniczeniem wartość ujemna.

## Ograniczenia

- Przyjęty poziom tolerancji możemy osiągnąć poprzez odjęcie od ustalonych nieprzekraczalnych limitów naszych aspiracji:
$$
\forall{o \in OBJECTIVES}: tolerance[o] = hard\_limits[o] - ASPIRATIONS[o]
$$

## Ograniczenia rozmyte

- Nie powinniśmy wykorzystać więcej składnika $S1$ niż zadany poziom aspiracji z poziomem tolerancji równym $|tolerance[S1]|$:
$$
component\_usage[S1] \underset{\sim}{\le} ASPIRATIONS[S1]
$$

- Nie powinniśmy wykorzystać więcej składnika $S2$ niż zadany poziom aspiracji z poziomem tolerancji równym $|tolerance[S2]|$:
$$
component\_usage[S2] \underset{\sim}{\le} ASPIRATIONS[S2]
$$

## Cele rozmyte

- Celujemy by zysk przekroczył poziom aspiracji z poziomem tolerancji równym $|tolerance[income]|$:
$$
income \underset{\sim}{\le} ASPIRATIONS[income]
$$

- Celujemy by emisja zanieczyszczeń była mniejsza niż zadany poziom aspiracji z poziomem tolerancji równym $|tolerance[emissions]|$:
$$
emissions \underset{\sim}{\le} ASPIRATIONS[emissions]
$$

- Celujemy by całkowite koszty były mniejsze niż zadany poziom aspiracji z poziomem tolerancji równym $|tolerance[cost]|$:
$$
cost \underset{\sim}{\le} ASPIRATIONS[cost]
$$

\newpage

# 3. Sformułować równoważne zadanie optymalizacji dla zadania 2 z wykorzystaniem zbiorów rozmytych adaptując podejście Zimmermana dla więcej niż jednego kryterium.

Model bazuje na przygotowanym modelu podstawowym. W tym rozdziale zostaną zdefiniowane jedynie dodatkowe parametry, ograniczenia, zmienne decyzyjne i funkcje oceny. Zostały one zdefiniowane, by wykorzystać metodę zbiorów rozmytych z podejściem Zimmermana dla więcej niż jednego kryterium.

## Zmienne decyzyjne

- $\alpha$ - zmienna decyzyjna dla $\alpha$-przekrojów,

- $tolerance[o], o \in OBJECTIVES$ - zmienna reprezentująca rozmycie ograniczeń (wartość stała). Zostało przyjęte, że dla zmiennych z górnym nieakceptowalnym ograniczeniem wartość jest dodatnia, a z dolnym ograniczeniem wartość ujemna.

## Ograniczenia

- Zmienna $\alpha$ może przyjmować wartości z zakresu [0; 1]. Warto tutaj zwrócić uwagę, że przez narzucone górne ograniczenie na wartość $\alpha$ w efekcie możemy otrzymać rozwiązanie, które nie będzie najlepszym jeśli byśmy brali pod uwagę także inne kryteria:
$$
0 \le \alpha \le 1
$$

- Przyjęty poziom tolerancji możemy osiągnąć poprzez odjęcie od ustalonych nieprzekraczalnych limitów naszych aspiracji:
$$
\forall{o \in OBJECTIVES}: tolerance[o] = hard\_limits[o] - ASPIRATIONS[o]
$$

Definiujemy rozmyte ograniczenia:

- Ograniczenia dla celów, które maksymalizujemy (znak dla $tolerance[o]$ zależy od przyjętych założeń):
$$
\forall{o \in MAX\_OBJECTIVES}:
$$
$$
objectives[o] \ge ASPIRATIONS[o] + tolerance[o] \cdot (1 - \alpha)
$$

- Ograniczenia dla celów, które minimalizujemy (znak dla $tolerance[o]$ zależy od przyjętych założeń):
$$
\forall{o \in MIN\_OBJECTIVES}:
$$
$$
objectives[o] \le ASPIRATIONS[o] + tolerance[o] \cdot (1 - \alpha)
$$

\newpage

# Przygotowany bazowy model

\newpage

# 4. Zapisz zadanie/zadania sformułowane w punkcie 1 w postaci do rozwiązania z wykorzystaniem wybranego narzędzia implementacji (np. AMPL, AIMMS) i rozwiąż to zadanie/zadania. W przypadku niedopuszczalności zadania zaproponuj zmianę celów i/lub innych parametrów.

\newpage

# 5. Zapisz zadania sformułowane w punkcie 3 w postaci do rozwiązania z wykorzystaniem wybranego narzędzia implementacji (np. AMPL, AIMMS) i rozwiąż te zadania. W przypadku niedopuszczalności zadania zaproponuj zmianę celów i/lub innych parametrów.

\newpage

# 6. Porównaj rozwiązania zadań z poprzednich dwóch punktów.

\newpage

# 7. Rozwiąż zadanie z punktu 2 za pomoca pakietu R – FuzzyLP. Należy w obliczeniach rozpatrywać niezależnie każde z kryteriów.

\newpage

# 8. Zaproponuj i zastosuj graficzną formę analizy rozwiązań.

\newpage

# 9. Opisz zalety i wady modelowania opisanego problemu z wykorzystaniem zbiorów rozmytych.

Zalety | Wady
-------|-----
TODO   | TODO
