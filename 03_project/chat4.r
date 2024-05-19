library(FuzzyLP)

# Definicja funkcji celu (minimalizacja kosztów)
c <- c(9, 21, 11)  # Koszty produkcji dla P1, P2, P3
objective <- function(x) sum(c * x)

# Definicja macierzy współczynników ograniczeń
A <- matrix(c(2, 10, 4, 8, 1, 4, 4, 0, 2), nrow = 3, byrow = TRUE)
b <- c(100, 55, 50)  # Ograniczenia na zużycie składników

# Dodatkowe ograniczenia
constraints <- list(
  fuzzy_leq(3, 5, x = c(1, 0, 0)),  # Minimalna produkcja P1
  fuzzy_geq(3, 0, x = c(1, 0, 0)),  # Minimalna produkcja P1
  fuzzy_leq(5, 5, x = c(0, 0, 1)),  # Minimalna produkcja P3
  fuzzy_geq(5, 0, x = c(0, 0, 1)),  # Minimalna produkcja P3
  fuzzy_leq(35, 5, x = c(1, 1, 1)),  # Maksymalna emisja
  fuzzy_geq(35, 0, x = c(1, 1, 1))  # Maksymalna emisja
)

# Rozwiązanie problemu
result <- fuzzy_linear_prog(objective, A, b, constraints, tol = 1e-6)

# Wyświetlenie wyniku
result