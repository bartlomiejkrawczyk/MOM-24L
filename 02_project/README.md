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

Z magazynów produkty są transportowane do trzech punktów sprzedaży detalicznej: S1, S2, S3. Zapotrzebowanie brj (r=1,2;
j=1,2,3) na poszczególne produkty określa poniższa tabela

brj | S1 | S2 | S3
----|----|----|---
P1  | 33 | 32 | 36
P2  | 31 | 24 | 25

Transport produktów odbywa się ciężarówkami. Od wytwórców do magazynów produkty mogą być transportowane dużymi
ciężarówkami o ładowności 21 jednostek i o stałym dziennym koszcie utrzymania równym 5000 zł. Z magazynów do
odbiorców mogą być natomiast transportowane jedynie małymi ciężarówkami o ładowności 10 jednostek i o stałym
dziennymi koszcie utrzymania wynoszącym 1800 zł. Ze względu na duże odległości pojedyncza ciężarówka może danego
dnia wykonać tylko jeden kurs. Pojedyncza ciężarówka jest tak skonstruowana, że może przewozić obydwa produkty
jednocześnie w dowolnych proporcjach.

Jednostkowe koszty transportu są identyczne dla obu produktów. Poniższe tabele podają wyrażone w tys. zł wartości
jednostkowych kosztów transportu od wytwórców do magazynów cki (k=1,2; i=1,2) oraz od magazynów do punktów
sprzedaży tij (i=1,2; j=1,2,3)

cki | M1 | M2
----|----|---
W1  | 9  | 2
W2  | 6  | 4

tij | S1 | S2 | S3
----|----|----|---
M1  | 10 | 16 | 7
M2  | 7  | 14 | 3

Produkty nie są policzalne (np. cement), czyli mogą być dowolnie dzielone pomiędzy magazyny i odbiorców.

Należy ustalić ilości produktów transportowanych na poszczególnych trasach, optymalne wielkości magazynów oraz liczby
ciężarówek, które mają kursować na poszczególnych trasach tak, aby zagwarantować minimalny dzienny koszt dystrybucji
(transportu i magazynowania) produktów.

