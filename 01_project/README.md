---
title: "Modelowanie Matematyczne - Projekt 1"
author: Bartłomiej Krawczyk, 310774
geometry: margin=2cm
header-includes:
    - \usepackage{float}
    - \floatplacement{figure}{H}
---

## Zadanie 1 - Sieć przepływowa

W centrum dyspozytorskim planuje się dostawy węgla z określonych kopalń do elektrowni.
Rozważana jest możliwość dostaw węgla kamiennego z trzech kopalń A, B, C do trzech elektrowni
F, G, H za pomocą sieci kolejowej z dwoma stacjami pośrednimi D i E.

- Jednostkowe koszty transportowe i przepustowości na poszczególnych odcinkach wynoszą (skierowanie łuku jest od wiersza do kolumny):
    - koszt:

    |   | D | E | F | G | H |
    |---|---|---|---|---|---|
    | A | 3 | 6 | - | - | - |
    | B | 6 | 3 | - | - | - |
    | C | 4 | 5 | - | - | - |
    | D | - | 2 | 5 | 7 | 3 |
    | E | - | - | 5 | 4 | 2 |

    - przepustowość:

    |   | D  | E  | F  | G | H  |
    |---|----|----|----|---|----|
    | A | 8  | 10 | -  | - | -  |
    | B | 10 | 13 | -  | - | -  |
    | C | 10 | 8  | -  | - | -  |
    | D | -  | 20 | 16 | 6 | 10 |
    | E | -  | -  | 7  | 4 | 2  |

- Zdolności wydobywcze kopalń wynoszą (w tys. ton): $W_A = 10, W_B = 13, W_C = 22$.
- Średnie zużycie dobowe węgla przez elektrownie wynosi (w tys. ton): $Z_F = 15, Z_G = 10, Z_H = 10$.

Zadanie polega na wyznaczeniu planu codziennych dostaw węgla zaspokajający zapotrzebowania
elektrowni i minimalizujący sumaryczne koszty transportu. W tym celu należy:
- sformułować i narysować model sieciowy (sieć przepływową); Określić jaki problem na tej
sieci należy rozwiązać (należy nazwać problem do rozwiązania, nie algorytm)
- znaleźć jak najlepsze rozwiązanie (dowolną metodą ręcznie lub algorytmicznie)
- zapisać odpowiadające zadanie programowania liniowego

Ponadto, należy sprawdzić, gdzie w sieci transportowej występuje wąskie gardło, które stanowiłoby
ograniczenie w przypadku zwiększonego zapotrzebowania ze strony elektrowni (koszty transportu
należy pominąć). W tym celu należy znaleźć przekrój o jak najmniejszej przepustowości; jaką
informację niesie przepustowość wybranego przekroju?

\newpage

### Sformułować i narysować model sieciowy (sieć przepływową); Określić jaki problem na tej sieci należy rozwiązać

Problemem, który należy rozwiązać jest **problem najtańszego przepływu**.

Zapotrzebowanie dobowe wszystkich elektrowni wynosi $F_{zadane} = Z_F + Z_G + Z_H = 35$, zatem zadany przepływ to $35$ jednostek (tys. ton).

Należy znaleźć przepływ ze źródła $s$ do ujścia $t$ o zadanej wielkości $F_{zadane}$ i minimalnym sumarycznym koszcie.

```{.mermaid scale=2 caption="TODO"}
%%{init:{'theme':'forest', 'flowchart': {'curve':'monotoneX'}}}%%
%% basis, bumpX, linear, monotoneX
%% basis, bumpX, bumpY, cardinal, catmullRom, linear, monotoneX, monotoneY, natural, step, stepAfter, stepBefore
flowchart LR
    s((s))
    A((A))
    B((B))
    C((C))
    D((D))
    E((E))
    F((F))
    G((G))
    H((H))
    t((t))

    %% Zdolności wydobywcze
    s --[10] 0 --> A
    s --[13] 0 --> B
    s --[22] 0 --> C
    
    %% Koszty transportu i przepustowości
    A --[8] 3--> D
    A --[10] 6--> E

    B --[10] 6--> D
    B --[13] 3--> E

    C --[10] 4--> D
    C --[8] 5--> E

    D --[20] 2--> E
    D --[16] 5--> F
    D --[6] 7--> G
    D --[10] 3--> H

    E --[7] 5--> F
    E --[4] 4--> G
    E --[2] 2--> H

    %% Zapotrzebowanie
    F --[15] 0--> t
    G --[10] 0--> t
    H --[10] 0--> t
```

### Znaleźć jak najlepsze rozwiązanie.

Najlepsze rozwiązanie znalezione algorytmicznie prowadzi do kosztu równego **296**.

from \ to | s | A | B  | C  | D  | E | F | G | H | t
----------|---|---|----|----|----|---|---|---|---|---
s         | 0 | 8 | 13 | 14 | 0  | 0 | 0 | 0 | 0 | 0
A         | 0 | 0 | 0  | 0  | 8  | 0 | 0 | 0 | 0 | 0
B         | 0 | 0 | 0  | 0  | 4  | 9 | 0 | 0 | 0 | 0
C         | 0 | 0 | 0  | 0  | 10 | 4 | 0 | 0 | 0 | 0
D         | 0 | 0 | 0  | 0  | 0  | 0 | 8 | 6 | 8 | 0
E         | 0 | 0 | 0  | 0  | 0  | 0 | 7 | 4 | 2 | 0
F         | 0 | 0 | 0  | 0  | 0  | 0 | 0 | 0 | 0 | 15
G         | 0 | 0 | 0  | 0  | 0  | 0 | 0 | 0 | 0 | 10
H         | 0 | 0 | 0  | 0  | 0  | 0 | 0 | 0 | 0 | 10
t         | 0 | 0 | 0  | 0  | 0  | 0 | 0 | 0 | 0 | 0

```{.mermaid scale=2 caption="TODO"}
%%{init:{'theme':'forest', 'flowchart': {'curve':'monotoneX'}}}%%
%% basis, bumpX, linear, monotoneX
%% basis, bumpX, bumpY, cardinal, catmullRom, linear, monotoneX, monotoneY, natural, step, stepAfter, stepBefore
flowchart LR
    s((s))
    A((A))
    B((B))
    C((C))
    D((D))
    E((E))
    F((F))
    G((G))
    H((H))
    t((t))

    %% Zdolności wydobywcze
    s --[8/10] 0 --> A
    s --[13/13] 0 --> B
    s --[14/22] 0 --> C
    
    %% Koszty transportu i przepustowości
    A --[8/8] 3--> D
    A --[0/10] 6--> E

    B --[4/10] 6--> D
    B --[9/13] 3--> E

    C --[10/10] 4--> D
    C --[4/8] 5--> E

    D --[0/20] 2--> E
    D --[8/16] 5--> F
    D --[6/6] 7--> G
    D --[8/10] 3--> H

    E --[7/7] 5--> F
    E --[4/4] 4--> G
    E --[2/2] 2--> H

    %% Zapotrzebowanie
    F --[15/15] 0--> t
    G --[10/10] 0--> t
    H --[10/10] 0--> t
```

### Zapisać odpowiadające zadanie programowania liniowego.

### Zbiory

- $V = \{s, A, B, C, D, E, F, G, H, t\}$ - zbiór wszystkich węzłów sieci przepływowej,
- $U = V \setminus \{s, t\}$ - zbiór węzłów sieci przepływowej z wyłączeniem źródła $s$ i ujścia $t$,
- $E \subset V \times V$ - zbiór łuków dostępnych w danej sieci przepływowej.

$$
V = \{s, A, B, C, D, E, F, G, H, t\}
$$
$$
U = \{A, B, C, D, E, F, G, H\}
$$
$$
E = \{
    (A, D), (A, E), 
$$
$$
    (B, D), (B, E), 
$$
$$
    (C, D), (C, E), 
$$
$$
    (D, E), (D, F), (D, G), (D, H), 
$$
$$
    (E, F), (E, G), (E, H)
\}
$$

### Parametry

- $F_{zadane} = 35$ - całkowite zapotrzebowanie dobowe węgla (w tys. ton).
- $c_{uv}\ dla (u, v) \in E$ - przepustowość ustalona dla każdego łuku rozpoczynającego się w węźle $u$ i kończącego się w węźle $v$. W przypadku $(u, v) \notin E$ przyjmujemy $c_{uv} = 0$,
- $d_{uv}\ dla (u, v) \in E$ - koszt ustalony dla każdego łuku rozpoczynającego się w węźle $u$ i kończącego się w węźle $v$. W przypadku $(u, v) \notin E$ przyjmujemy $d_{uv} = 0$.

$$
c_{AD} = 8, c_{AE} = 10 
$$
$$
c_{BD} = 10, c_{BE} = 13 
$$
$$
c_{CD} = 10, c_{CE} = 8 
$$
$$
c_{DE} = 20, c_{DF} = 16, c_{DG} = 6, c_{DH} = 10 
$$
$$
c_{EF} = 7, c_{EG} = 4, c_{EH} = 2
$$
$$
c_{sA} = 10, c_{sB} = 13, c_{sC} = 22 
$$
$$
c_{Ft} = 15, c_{Gt} = 10, c_{Ht} = 10
$$

$$
d_{AD} = 3, d_{AE} = 6 
$$
$$
d_{BD} = 6, d_{BE} = 3 
$$
$$
d_{CD} = 4, d_{CE} = 5 
$$
$$
d_{DE} = 2, d_{DF} = 5, d_{DG} = 7, d_{DH} = 3 
$$
$$
d_{EF} = 5, d_{EG} = 4, d_{EH} = 2
$$

### Zmienne decyzyjne

- $f_{uv}\ dla (u, v) \in E$ - przepływ przez łuk rozpoczynający się w węźle $u$ i kończącego się w węźle $v$,
- $D$ - zmienna pomocnicza - całkowity koszt wszystkich przepływów.

### Funkcja oceny

- $min(D)$ - minimalizujemy całkowity koszt wszystkich przepływów.

### Ograniczenia

- Przepływ nie może być negatywny:
$$
\forall{(u, v) \in E} : f_{uv} \ge 0
$$

- Całkowity koszt jest sumą kosztu wszystkich przepływów:
$$
D = \sum_{(u, v) \in E} d_{uv} f_{uv}
$$

- Ze źródła $s$ wypływa $F_{zadane}$ jednostek:
$$
\sum_{z \in V} f_{sz} = F_{zadane}
$$

- Suma wpływających jednostek i wypływających z danego węzła powinna być równa (wyjątkiem jest źródło $s$ i ujście $t$):
$$
\forall{v \in U} : \sum_{z \in V} f_{vz} = \sum_{u \in V} f_{uv}
$$

- Przepływ przez dany łuk nie może przekroczyć maksymalnego przepływu:

$$
\forall{(u, v) \in E} : f_{uv} \le c_{uv}
$$

### Ponadto, należy sprawdzić, gdzie w sieci transportowej występuje wąskie gardło, które stanowiłoby ograniczenie w przypadku zwiększonego zapotrzebowania ze strony elektrowni (koszty transportu należy pominąć). W tym celu należy znaleźć przekrój o jak najmniejszej przepustowości; jaką informację niesie przepustowość wybranego przekroju?

### Zbiory

- $V = \{s, A, B, C, D, E, F, G, H, t\}$ - zbiór wszystkich węzłów sieci przepływowej,
- $U = V \setminus \{s, t\}$ - zbiór węzłów sieci przepływowej z wyłączeniem źródła $s$ i ujścia $t$,
- $E \subset V \times V$ - zbiór łuków dostępnych w danej sieci przepływowej.

### Parametry

- $c_{uv}\ dla (u, v) \in E$ - przepustowość ustalona dla każdego łuku rozpoczynającego się w węźle $u$ i kończącego się w węźle $v$. W przypadku $(u, v) \notin E$ przyjmujemy $c_{uv} = 0$. Przepustowość ma te same wartości co w poprzednim zadaniu z wyjątkiem przepustowości:

$$
c_{Ft} = \infin, c_{Gt} = \infin, c_{Ht} = \infin
$$

### Zmienne decyzyjne

Dzielimy wierzchołki na dwa rozłączne zbiory $S$ i $T$. Zakładamy, że $s \in S$ i $t \in T$.

- $d_{uv}\ dla (u, v) \in E$ - zmienna oznaczająca przynależność łuku do przekroju. Równa $1$ gdy $u \in S$ i $v \in T$ (łuk należy do przekroju), w przeciwnym wypadku $0$.
- $z_{uv}\ dla v \in V$ - zmienna oznaczająca przynależność wierzchołka do zbioru $S$. Równa $1$ gdy $v \in S$, a $0$ w przeciwnym przypadku.

### Funkcja oceny

- $min(\sum_{(u, v) \in E} c_{uv}d_{uv})$ - minimalizujemy całkowitą przepustowość łuków należących do przekroju.

### Ograniczenia

- Zmienna pomocnicza $d_{uv}$ nie może być negatywna:
$$
\forall{(u, v) \in E} : d_{uv} \ge 0
$$

- Wierzchołek $s$ z definicji należy do $S$:
$$
z_s = 1
$$

- Wierzchołek $t$ z definicji należy do $T$, więc nie należy do $S$:
$$
z_t = 0
$$

- Dla każdego nie terminalnego węzła $u, v$, jeśli $u$ należy do podziału $S$ i $v$ należy do podziału $T$, to łuk $(u, v)$ jest liczony do przekroju $(d_{uv} \ge 1)$:

$$
\forall{(u, v) \in E, u \ne s, v \ne t} : d_{uv} - z_u + z_v \ge 0
$$

### Wynik

Maksymalna wyliczona algorytmicznie przepustowość sieci jest równa $41$. Przekrojem o najmniejszej przepustowości jest przekrój: $\{(s, A), (s, B), (C, D), (C, E)\}$.

```{.mermaid scale=2 caption="TODO"}
%%{init:{'theme':'forest', 'flowchart': {'curve':'monotoneX'}}}%%
flowchart LR
    s((s))
    C((C))

    A((A))
    B((B))
    D((D))
    E((E))
    F((F))
    G((G))
    H((H))
    t((t))

    %% Zdolności wydobywcze
    s x--[10/10]--x A
    s x--[13/13]--x B
    s --[18/22]--> C
    
    linkStyle 0,1 stroke:#e81416 ;
    
    A --[8/8]--> D
    A --[2/10]--> E

    B --[10/10]--> D
    B --[3/13]--> E

    C x--[10/10]--x D
    C x--[8/8]--x E
    
    linkStyle 7,8 stroke:#e81416 ;

    D --[0/20]--> E
    D --[16/16]--> F
    D --[6/6]--> G
    D --[6/10]--> H

    E --[7/7]--> F
    E --[4/4]--> G
    E --[2/2]--> H

    F --[23/inf]--> t
    G --[10/inf]--> t
    H --[8/inf]--> t
```

--- 

## Zadanie 2 - Zadanie przydziału

1. Planowanie realizacji portfela przy ograniczonych kompetencjach

Softwarehouse posiada portfel projektów oznaczonych 1-6 oraz zespoły programistyczne
oznaczone A-F. Poniża tabela przedstawia kompetencje zespołów, gdzie „-„ oznacza brak
kompetencji zespołu do realizacji danego projektu.

Kompetencje zespołów:

projekt \ zespół | A | B | C | D | E | F
-----------------|---|---|---|---|---|--
1                | X | - | X | X | - | X
2                | - | X | X | - | X | -
3                | X | X | - | X | - | -
4                | - | X | X | - | X | -
5                | X | - | X | X | - | X
6                | X | - | - | - | X | X

Należy dokonać przydziału zespołów programistycznych do poszczególnych projektów, przy
założeniu, że jeden zespół może realizować tylko jeden projekt, a jeden projekt może być
realizowany przez tylko jeden zespół. W tym celu:

- narysować model sieciowy problemu
- określić jaki problem należy rozwiązać i znaleźć ręcznie rozwiązanie
- na podstawie rozwiązania modelu sieciowego określić przydział zespołów do projektów

### Narysować model sieciowy problemu

```{.mermaid scale=2 caption="TODO"}
%%{init:{'theme':'forest', 'flowchart': {'curve':'monotoneX'}}}%%
%% basis, bumpX, linear, monotoneX
%% basis, bumpX, bumpY, cardinal, catmullRom, linear, monotoneX, monotoneY, natural, step, stepAfter, stepBefore
flowchart LR
    s((s))

    1((1))
    2((2))
    3((3))
    4((4))
    5((5))
    6((6))

    A((A))
    B((B))
    C((C))
    D((D))
    E((E))
    F((F))

    t((t))

    s --> 1
    s --> 2
    s --> 3
    s --> 4
    s --> 5
    s --> 6

    1 ----> A
    1 ----> C
    1 ----> D
    1 ----> F

    linkStyle 6,7,8,9 stroke:#e81416 ;
    style 1 fill:#e81416,stroke:#000 ;

    2 ----> B
    2 ----> C
    2 ----> E

    linkStyle 10,11,12 stroke:#ffa500 ;
    style 2 fill:#ffa500,stroke:#000 ;

    3 ----> A
    3 ----> B
    3 ----> D

    linkStyle 13,14,15 stroke:#faeb36 ;
    style 3 fill:#faeb36,stroke:#000 ;

    4 ----> B
    4 ----> C
    4 ----> E

    linkStyle 16,17,18 stroke:#79c314 ;
    style 4 fill:#79c314,stroke:#000 ;

    5 ----> A
    5 ----> C
    5 ----> D
    5 ----> F

    linkStyle 19,20,21,22 stroke:#487de7 ;
    style 5 fill:#487de7,stroke:#000 ;

    6 ----> A
    6 ----> E
    6 ----> F

    linkStyle 23,24,25 stroke:#4b369d ;
    style 6 fill:#4b369d,stroke:#000 ;

    A --> t
    B --> t
    C --> t
    D --> t
    E --> t
    F --> t
```

Każdy łuk ma maksymalną przepustowość równą **1**.

### Określić jaki problem należy rozwiązać i znaleźć ręcznie rozwiązanie

Problem do rozwiązania w tym zadaniu to zadanie maksymalnego skojarzenia (przydziału).

- Przydzielamy projekty do zespołów
- Każdy projekt wymaga jednego zespołu
- Każdy zespół może realizować maksymalnie jeden projekt

Rozwiązanie znalezione ręcznie:

projekt \ zespół | A | B | C | D | E | F
-----------------|---|---|---|---|---|--
1                | X | - | - | - | - | -
2                | - | - | X | - | - | -
3                | - | X | - | - | - | -
4                | - | - | - | - | X | -
5                | - | - | - | X | - | -
6                | - | - | - | - | - | X


```{.mermaid scale=2 caption="TODO"}
%%{init:{'theme':'forest', 'flowchart': {'curve':'monotoneX'}}}%%
%% basis, bumpX, linear, monotoneX
%% basis, bumpX, bumpY, cardinal, catmullRom, linear, monotoneX, monotoneY, natural, step, stepAfter, stepBefore
flowchart LR
    s((s))

    1((1))
    2((2))
    3((3))
    4((4))
    5((5))
    6((6))

    A((A))
    B((B))
    C((C))
    D((D))
    E((E))
    F((F))

    t((t))

    s --> 1
    s --> 2
    s --> 3
    s --> 4
    s --> 5
    s --> 6

    1 ----> A

    linkStyle 6 stroke:#e81416 ;
    style 1 fill:#e81416,stroke:#000 ;

    2 ----> C

    linkStyle 7 stroke:#ffa500 ;
    style 2 fill:#ffa500,stroke:#000 ;

    3 ----> B

    linkStyle 8 stroke:#faeb36 ;
    style 3 fill:#faeb36,stroke:#000 ;

    4 ----> E

    linkStyle 9 stroke:#79c314 ;
    style 4 fill:#79c314,stroke:#000 ;

    5 ----> D

    linkStyle 10 stroke:#487de7 ;
    style 5 fill:#487de7,stroke:#000 ;

    6 ----> F

    linkStyle 11 stroke:#4b369d ;
    style 6 fill:#4b369d,stroke:#000 ;

    A --> t
    B --> t
    C --> t
    D --> t
    E --> t
    F --> t
```

### Na podstawie rozwiązania modelu sieciowego określić przydział zespołów do projektów

projekt | zespół
--------|-------
1       | A
2       | C
3       | B
4       | E
5       | D
6       | F

---

2. Minimalizacja kosztów realizacji projektów

Zakładamy, że firma wynajmuje zespoły do realizacji projektów. Koszty wynajmu są podane w
poniższej tabeli.

Koszty wykonywania projektów przez poszczególne zespoły:

projekt \ zespół | A  | B  | C  | D  | E  | F
-----------------|----|----|----|----|----|---
1                | 15 | -  | 14 | 9  | -  | 12
2                | -  | 12 | 16 | -  | 10 | -
3                | 11 | 14 | -  | 12 | -  | -
4                | -  | 16 | 11 | -  | 12 | -
5                | 13 | -  | 17 | 13 | -  | 15
6                | 11 | -  | -  | -  | 16 | 18

Należy dokonać przydziału zespołów programistycznych do projektów tak, aby
minimalizować koszty najmu zespołów. Ograniczenia dotyczące jednego zespołu i jednego
projektu pkt. 2.1 dalej obowiązują. W tym celu:
- narysować model sieciowy problemu
- określić jaki problem należy rozwiązać na tym modelu sieciowym
- spróbować znaleźć jak najlepsze rozwiązanie

### Narysować model sieciowy problemu

```{.mermaid scale=2 caption="TODO"}
%%{init:{'theme':'forest', 'flowchart': {'curve':'monotoneX'}}}%%
%% basis, bumpX, linear, monotoneX
%% basis, bumpX, bumpY, cardinal, catmullRom, linear, monotoneX, monotoneY, natural, step, stepAfter, stepBefore
flowchart LR
    s((s))

    1((1))
    2((2))
    3((3))
    4((4))
    5((5))
    6((6))

    A((A))
    B((B))
    C((C))
    D((D))
    E((E))
    F((F))

    t((t))

    s --0--> 1
    s --0--> 2
    s --0--> 3
    s --0--> 4
    s --0--> 5
    s --0--> 6

    1 --15----> A
    1 --14----> C
    1 --9----> D
    1 --12----> F

    linkStyle 6,7,8,9 stroke:#e81416 ;
    style 1 fill:#e81416,stroke:#000 ;

    2 --12----> B
    2 --16----> C
    2 --10----> E

    linkStyle 10,11,12 stroke:#ffa500 ;
    style 2 fill:#ffa500,stroke:#000 ;

    3 --11----> A
    3 --14----> B
    3 --12----> D

    linkStyle 13,14,15 stroke:#faeb36 ;
    style 3 fill:#faeb36,stroke:#000 ;

    4 --16----> B
    4 --11----> C
    4 --12----> E

    linkStyle 16,17,18 stroke:#79c314 ;
    style 4 fill:#79c314,stroke:#000 ;

    5 --13----> A
    5 --17----> C
    5 --13----> D
    5 --15----> F

    linkStyle 19,20,21,22 stroke:#487de7 ;
    style 5 fill:#487de7,stroke:#000 ;

    6 --11----> A
    6 --16----> E
    6 --18----> F

    linkStyle 23,24,25 stroke:#4b369d ;
    style 6 fill:#4b369d,stroke:#000 ;

    A --0--> t
    B --0--> t
    C --0--> t
    D --0--> t
    E --0--> t
    F --0--> t
```

Każdy łuk ma maksymalną przepustowość równą **1**.

### Określić jaki problem należy rozwiązać na tym modelu sieciowym

Problemem do rozwiązania jest **zadanie najtańszego skojarzenia**.

- Przydzielamy projekty do zespołów
- Każdy projekt wymaga jednego z zespołów
- Każdy zespół może realizować tylko jeden projekt
- Trzeba zrealizować wszystkie projekty
- Każdy zespół realizujący projekt ma ustaloną cenę za realizację tego projektu

### Spróbować znaleźć jak najlepsze rozwiązanie

Najlepszym znalezionym algorytmicznie rozwiązaniem jest przydział o koszcie całkowitym **70**:

: | A  | B  | C  | D | E  | F
--|----|----|----|---|----|---
1 | -  | -  | -  | 9 | -  | -
2 | -  | -  | -  | - | 10 | -
3 | -  | 14 | -  | - | -  | -
4 | -  | -  | 11 | - | -  | -
5 | -  | -  | -  | - | -  | 15
6 | 11 | -  | -  | - | -  | -

---

3. Minimalizacja terminu realizacji puli projektów

Załóżmy teraz, że dane podane w tabeli 2 to czasy (w miesiącach) realizacji projektów przez
poszczególne zespoły. Ograniczenia dotyczące jednego zespołu i jednego projektu pkt. 2.1
dalej obowiązują. Zaproponować model programowania liniowego minimalizujący termin
realizacji całego portfela projektów (jest to termin zdeterminowany przez najdłużej
wykonywany projekt).

### Zbiory

- $V = \{s, 1, 2, 3, 4, 5, 6, A, B, C, D, E, F, t\}$ - zbiór wszystkich węzłów sieci przepływowej,
- $U = V \setminus \{s, t\}$ - zbiór węzłów sieci przepływowej z wyłączeniem źródła $s$ i ujścia $t$,
- $E \subset V \times V$ - zbiór łuków dostępnych w danej sieci przepływowej.

$$
V = \{s, 1, 2, 3, 4, 5, 6, A, B, C, D, E, F, t\}
$$
$$
U = \{1, 2, 3, 4, 5, 6, A, B, C, D, E, F\}
$$
$$
E = \{
    (s, 1), (s, 2), (s, 3), (s, 4), (s, 5), (s, 6), 
$$
$$
    (1, A), (1, C), (1, D), (1, F), 
$$
$$
    (2, B), (2, C), (2, E), 
$$
$$
    (3, A), (3, B), (3, D), 
$$
$$
    (4, B), (4, C), (4, E), 
$$
$$
    (5, A), (5, C), (5, D), (5, F), 
$$
$$
    (6, A), (6, E), (6, F), 
$$
$$
    (A, t), (B, t), (C, t), (D, t), (E, t), (F, t), 
\}
$$

### Parametry

- $F_{zadane} = 6$ - ilość projektów - każdy musi być zrealizowany.
- $c_{uv} = 1\ dla (u, v) \in E$ - przepustowość ustalona dla każdego łuku rozpoczynającego się w węźle $u$ i kończącego się w węźle $v$. W przypadku $(u, v) \notin E$ przyjmujemy $c_{uv} = 0$,
- $d_{uv}\ dla (u, v) \in E$ - czas realizacji (w miesiącach) ustalony dla każdego łuku rozpoczynającego się w węźle $u$ i kończącego się w węźle $v$. W przypadku $(u, v) \notin E$ przyjmujemy $d_{uv} = 0$.

$$
c_{s1} = 1, c_{s2} = 1, c_{s3} = 1, c_{s4} = 1, c_{s5} = 1, c_{s6} = 1, 
$$
$$
c_{1A} = 1, c_{1C} = 1, c_{1D} = 1, c_{1F} = 1, 
$$
$$
c_{2B} = 1, c_{2C} = 1, c_{2E} = 1, 
$$
$$
c_{3A} = 1, c_{3B} = 1, c_{3D} = 1, 
$$
$$
c_{4B} = 1, c_{4C} = 1, c_{4E} = 1, 
$$
$$
c_{5A} = 1, c_{5C} = 1, c_{5D} = 1, c_{5F} = 1, 
$$
$$
c_{6A} = 1, c_{6E} = 1, c_{6F} = 1, 
$$
$$
c_{At} = 1, c_{Bt} = 1, c_{Ct} = 1, c_{Dt} = 1, c_{Et} = 1, c_{Ft} = 1
$$

$$
d_{s1} = 0, d_{s2} = 0, d_{s3} = 0, d_{s4} = 0, d_{s5} = 0, d_{s6} = 0, 
$$
$$
d_{1A} = 15, d_{1C} = 14, d_{1D} = 9, d_{1F} = 12, 
$$
$$
d_{2B} = 12, d_{2C} = 16, d_{2E} = 10, 
$$
$$
d_{3A} = 11, d_{3B} = 14, d_{3D} = 12, 
$$
$$
d_{4B} = 16, d_{4C} = 11, d_{4E} = 12, 
$$
$$
d_{5A} = 13, d_{5C} = 17, d_{5D} = 13, d_{5F} = 15, 
$$
$$
d_{6A} = 11, d_{6E} = 16, d_{6F} = 18, 
$$
$$
d_{At} = 0, d_{Bt} = 0, d_{Ct} = 0, d_{Dt} = 0, d_{Et} = 0, d_{Ft} = 0, 
$$

### Zmienne decyzyjne

- $f_{uv}\ dla (u, v) \in E$ - przepływ przez łuk rozpoczynający się w węźle $u$ i kończącego się w węźle $v$,
- $D$ - zmienna pomocnicza - całkowity czas realizacji.

### Funkcja oceny

- $min(D)$ - minimalizujemy całkowity całkowity czas realizacji.

### Ograniczenia

- Projekt w całości może być realizowany tylko przez jeden zespół - przepływ jest liczbą całkowitą z przedziału [0; 1]:
$$
\forall{(u, v) \in E} : f_{uv} \in \{0, 1\}
$$

- Całkowity czas realizacji jest większy lub równy poszczególnym czasom realizacji projektów:
$$
\forall{(u, v) \in E} : D \ge d_{uv} f_{uv}
$$

- Zespoły muszą zrealizować $F_{zadane}$ projektów - ze źródła $s$ wypływa $F_{zadane}$ jednostek:
$$
\sum_{z \in V} f_{sz} = F_{zadane}
$$

- Suma wpływających jednostek i wypływających z danego węzła powinna być równa (wyjątkiem jest źródło $s$ i ujście $t$):
$$
\forall{v \in U} : \sum_{z \in V} f_{vz} = \sum_{u \in V} f_{uv}
$$

- Przepływ przez dany łuk nie może przekroczyć maksymalnego przepływu:

$$
\forall{(u, v) \in E} : f_{uv} \le c_{uv}
$$

### Wynik

Rozwiązaniem algorytmicznym otrzymujemy przydział prowadzący do realizacji w przeciągu **14** miesięcy:

projekt / zespół | A | B | C | D | E | F
-----------------|---|---|---|---|---|--
1                | - | - | - | - | - | X
2                | - | - | - | - | X | -
3                | - | X | - | - | - | -
4                | - | - | X | - | - | -
5                | - | - | - | X | - | -
6                | X | - | - | - | - | -

projekt | zespół | czas realizacji
--------|--------|----------------
1       | F      | 12
2       | E      | 10
3       | B      | 14
4       | C      | 11
5       | D      | 13
6       | A      | 11

## Zadanie 3

Pewna firma FMCG planuje sprzedaż jednego produktu. Produkt jest dostarczany do 8 punktów
sprzedaży. Na podstawie danych historycznych (lub prognozowanych) utworzony tzw. plan bazowy
dostaw opisujący ilości produktu, które były (powinny być) dostarczane do każdego punktu. Jest on
następujący:

punkt | 1   | 2   | 3   | 4   | 5   | 6   | 7   | 8
------|-----|-----|-----|-----|-----|-----|-----|----
ilość | 240 | 385 | 138 | 224 | 144 | 460 | 198 | 200

Jednak ze względu na akcje marketingowe oraz różnego rodzaju umowy/ustalenia z handlowcami tego
produktu wprowadzono różnego rodzaju modyfikacje ww. planu bazowego w formie zagregowanych
ograniczeń eksperckich:
1. Suma towaru dostarczonego do punktów 1, 3, 8 ma być przynajmniej o 12% większa niż planie bazowym.
2. Suma towaru dostarczonego do punktów 3, 5 ma być przynajmniej o 7% mniejsza niż w planie bazowym.
3. Ilość towaru dostarczonego do punktu 3 ma stanowić przynajmniej 80% towaru
dostarczonego do punktu 7.

Zakładając, że sumaryczna wielkość sprzedaży produktu we wszystkich punktach nie może zostać
zmieniona, należy zaplanować wielkość sprzedaży w poszczególnych punktach minimalizującą
względne odchylenie (upewnij się, że dobrze rozumiesz „względne odchylenie”) od planu bazowego
(a dokładnie - wartość bezwzględną względnego odchylenia). Ponieważ jest 8 względnych odchyleń
(kryteriów), należy sformułować własną funkcję celu, która jest sumą ważoną dwóch składników: 1)
maksymalnego względnego odchylenia pośród 8 odchyleń, 2) sumy wszystkich względnych odchyleń.

### Należy zamodelować powyższy problem w postaci zadania programowania liniowego.

### Zbiory

- $P = \{1, 2, 3, 4, 5, 6, 7, 8\}$ - zbiór wszystkich punktów sprzedaży,
- $\mathbb{N}$ - zbiór liczb naturalnych.

### Parametry

- $b_{p}\ dla p \in P$ - plan bazowy dostaw opisujący ilość, która powinna być dostarczana do punktu $p$,
- $c_1$ - waga maksymalnego względnego odchylenia pośród 8 odchyleń,
- $c_2$ - waga sumy wszystkich względnych odchyleń.

$$
b_1 = 240, b_2 = 385, b_3 = 138, b_4 = 224,
$$
$$
b_5 = 144, b_6 = 460, b_7 = 198, b_8 = 200
$$

### Zmienne decyzyjne

- $x_{p}\ dla\ p \in P$ - planowana ilość do dostarczenia do punktu $p$,
- $y_{p}\ dla\ p \in P$ - odchylenie planowanej wartości od bazowej, która powinna być dostarczona do punktu $p$,
- $y_{p}^+\ dla\ p \in P$ - zmienna pomocnicza. Reprezentuje dodatnią część zmiennej $y_{p}$. Dla $y_{p} < 0$ $y_{p}^+ = 0$,
- $y_{p}^-\ dla\ p \in P$ - zmienna pomocnicza. Reprezentuje ujemną część zmiennej $y_{p}$. Dla $y_{p} > 0$ $y_{p}^- = 0$, 
- $y_{max}$ - zmienna pomocnicza. Wartość większa lub równa od wartości bezwzględnych odchyłek $|y_{p}|$ każdego z punktów $p \in P$,
- $y_{sum}$ - zmienna pomocnicza. Równa jest sumie względnych odchyleń od wszystkich planów bazowych punktów $p \in P$.

### Funkcja oceny

- $min(c_1 y_{max} + c_2 y_{sum})$ - minimalizujemy sumę ważoną dwóch składników: $y_{max}$ i $y_{sum}$.

### Ograniczenia

- Dostarczana ilość produktów nie może być ujemna:

$$
\forall{p \in P} : x_{p} \ge 0
$$

- Produkty są nie podzielne:

$$
\forall{p \in P} : x_{p} \in \mathbb{N}
$$

- Odchylenie od planowanej ilości bazowej to różnica ilości planowanej i bazowej:

$$
\forall{p \in P} : y_{p} = x_p - b_p
$$

- Odchyłka dodatnia nie może być ujemna:

$$
\forall{p \in P} : y_{p}^+ \ge 0
$$

- Odchyłka ujemna nie może być ujemna:

$$
\forall{p \in P} : y_{p}^- \ge 0
$$

- Odchylenie możemy zapisać jako różnicę odchyłek:

$$
\forall{p \in P} : y_{p} = y_{p}^+ - y_{p}^-
$$

- Maksymalne odchylenie jest większe równe wartości bezwzględnej każdego z odchyleń:

$$
\forall{p \in P} : y_{max} \ge y_{p}^+ + y_{p}^-
$$

- Suma względnych odchyleń jest równa sumie wartości bezwględnych każdego z odchyleń:

$$
y_{sum} = \sum_{p \in P} y_{p}^+ + y_{p}^-
$$

- Suma towaru dostarczonego do punktów $1, 3, 8$ ma być przynajmniej o $12\%$ większa niż w planie bazowym:

$$
x_1 + x_3 + x_8 \ge 1.2 (b_1 + b_3 + b_8)
$$

- Suma towaru dostarczonego do punktów $3, 5$ ma być przynajmniej o $7\%$ mniejsza niż w planie bazowym:

$$
x_3 + x_5 \le 0.93 (b_3 + b_5)
$$

- Ilość towaru dostarczonego do punktu $3$ ma stanowić przynajmniej $80\%$ towaru dostarczonego do punktu $7$:

$$
x_3 \ge 0.8 x_7
$$

- Sumaryczna wielkość sprzedaży produktu we wszystkich punktach nie może zostać zmieniona:

$$
\sum_{p \in P} x_p = \sum_{p \in P} b_p
$$

### Wyniki

Wyniki dla podanego zadania prawie nie zależą od przyjętych wag w funkcji oceny.

Dla przyjętego $c_1 = 1, c_2 = 0.001$ - preferujemy  minimalizację maksymalnego względnego odchylenia nad minimalizacją sumy odchyleń. Otrzymujemy w rezultacie plan o maksymalnym odchyleniu $y_{max} = 30$ i sumie odchyleń równej $y_{sum} = 140$.

punkt       | 1   | 2   | 3   | 4   | 5   | 6   | 7   | 8
------------|-----|-----|-----|-----|-----|-----|-----|----
bazowy plan | 240 | 385 | 138 | 224 | 144 | 460 | 198 | 200
plan        | 270 | 358 | 148 | 224 | 114 | 460 | 185 | 230
odchylenie  | 30  | -27 | 10  | 0   | -30 | 0   | -13 | 30

Dla przyjętego $c_1 = 0.001, c_2 = 1$ - preferujemy minimalizację sumy względnych odchyleń nad minimalizacją maksymalnego względnego odchylenia. Otrzymujemy w rezultacie taki sam plan - o maksymalnym odchyleniu $y_{max} = 30$ i sumie odchyleń równej $y_{sum} = 140$.

punkt       | 1   | 2   | 3   | 4   | 5   | 6   | 7   | 8
------------|-----|-----|-----|-----|-----|-----|-----|----
bazowy plan | 240 | 385 | 138 | 224 | 144 | 460 | 198 | 200
plan        | 270 | 358 | 148 | 224 | 114 | 460 | 185 | 230
odchylenie  | 30  | -27 | 10  | 0   | -30 | 0   | -13 | 30
