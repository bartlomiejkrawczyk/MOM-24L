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

Przedsiębiorstwo produkuje trzy produkty $P1$, $P2$, $P3$ (sztuki). Każdy z tych produktów potrzebuje trzech różnych składników $S1$, $S2$, $S3$ (kg/jednostkę). Każdy z produktów ma inną ceną jednostkową sprzedaży $C_P1$, $C_P2$, $C_P3$ (tyś.PLN/jednostkę). Firma zwraca uwagę na ekologię i szacuje jednostkowy poziom zanieczyszczeń emitowanych dla poszczególnych produktów $Z_P1$, $Z_P2$, $Z_P3$ (kg/jednostkę). Dostępne
są również jednostkowe koszty produkcji $K_P1$, $K_P2$, $K_P3$ (tyś.PLN/jednostkę).

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

# 1. Sformułować i opisać wielokryterialny model planowania produkcji z wykorzystaniem metody punktu odniesienia.

## Zbiory

- $PRODUCTS = \{P1, P2, P3\}$ - zbiór możliwych do wyprodukowania produktów,
- $COMPONENTS = \{S1, S2, S3\}$ - zbiór składników, z których wytwarzane są produkty.

## Parametry

- $PRODUCT\_INCOME[p], p \in PRODUCTS$ - jednostkowa cena sprzedaży produktów $p$ (tyś.PLN/jednostkę),
- $EMITTED\_POLLUTANTS[p], p \in PRODUCTS$ - jednostkowy poziom zanieczyszczeń emitowanych dla poszczególnych produktów $p$ (kg/jednostkę),
- $PRODUCTION\_COST[p], p \in PRODUCTS$ - jednostkowe koszty produkcji produktu $p$ (tyś.PLN/jednostkę),
- $PRODUCT\_COMPONENTS[p][c], p \in PRODUCTS, c \in COMPONENTS$ - wymagana ilość składnika $c$ do wytworzenia produktu $p$.

Dodatkowe parametry wynikające z zadanych ograniczeń:

- $COMPONENT\_USAGE\_HARD\_LIMIT[c], c \in COMPONENTS$ - maksymalna ilość składnika $c$ jaką można wykorzystać,
- $MINIMAL\_PRODUCTION[p], p \in PRODUCTS$ - minimalna ilość sztuk produktu $p$ jaką należy wyprodukować,

- $MIN\_INCOME = 130$ - minimalny akceptowalny poziom zarobków,
- $MAX\_EMISSIONS = 35$ - maksymalny akceptowalny poziom emisji zanieczyszczeń,
- $MAX\_COST = 80$ - maksymalny akceptowalny koszt wytwarzania wszystkich produktów.

Parametry wynikające z zadanych aspiracji:

- $INCOME\_ASPIRATION = 150$ - dążymy do zarobków na poziomie 150 tyś. PLN,
- $EMISSIONS\_ASPIRATION = 30$ - dążymy do emisji zanieczyszczeń na poziomie 30 kg,
- $COST\_ASPIRATION = 70$ - chcielibyśmy, aby koszty nie przekraczały 70 tyś. PLN.

## Zmienne decyzyjne

- $production[p], p \in PRODUCTS$ - zmienna reprezentująca ilość wyprodukowanych produktów typu $p$,
- $component\_usage[c], c \in COMPONENTS$ - reprezentuje całkowite wykorzystanie składnika typu $c$ do produkcji wszystkich produktów,
- $income$ - zmienna pomocnicza oznaczająca całkowity zysk ze sprzedaży produktów,
- $emissions$ - całkowite zanieczyszczenia wyemitowane podczas produkcji wszystkich produktów,
- $cost$ - sumaryczne koszty produkcji wyrobów.

## Ograniczenia

Ograniczenia wynikające z treści:

- Poszczególne składniki są wykorzystywane do produkcji różnych produktów w różnych proporcjach:
$$
\forall{c \in COMPONENTS}:
$$
$$
component\_usage[c] = \sum_{p \in PRODUCTS} PRODUCT\_COMPONENTS[p, c] * production[p]
$$

- Na całkowity zysk składają się zarobki ze sprzedaży wyprodukowanych wyrobów pomniejszone o koszty produkcji:
$$
income = (\sum_{p \in PRODUCTS} PRODUCT\_INCOME[p] * production[p]) - cost
$$

- Całkowity emisje są rezultatem zanieczyszczeń wytworzonych podczas produkcji poszczególnych produktów:
$$
emissions = \sum_{p \in PRODUCTS} EMITTED\_POLLUTANTS[p] * production[p]
$$

- Całkowite koszty produkcji składają się z kosztów wytworzenia poszczególnych produktów:
$$
cost = \sum{p \in PRODUCTS} PRODUCTION\_COST[p] * production[p]
$$

Ograniczenia wynikające z zadanych ograniczeń:

- Zadane są limity wykorzystania poszczególnych składników, których przekroczenie jest nie akceptowalne:
$$
\forall{c \in COMPONENTS}: component\_usage[c] <= COMPONENT\_USAGE\_HARD\_LIMIT[c]
$$

- Narzucona jest minimalna produkcja poszczególnych produktów:
$$
\forall{p \in PRODUCTS}: production[p] >= MINIMAL_PRODUCTION[p]
$$

- Oczekujemy minimalnych zysków na poziomie $MIN\_INCOME$:
$$
income >= MIN\_INCOME
$$

- Można wyprodukować maksymalnie $MAX\_EMISSIONS$ zanieczyszczeń:
$$
emissions <= MAX\_EMISSIONS
$$

- Koszty produkcji nie mogą przekroczyć $MAX\_COST$:
$$
cost <= MAX\_COST
$$

## Funkcja oceny
