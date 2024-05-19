library(lpSolve)

# Funkcja celu dla maksymalizacji zysku
obj_fun <- c(9, 21, 11)

# Ograniczenia na składniki
A <- rbind(
  c(2, 10, 4),   # S1
  c(8, 1, 4),    # S2
  c(4, 0, 2)     # S3
)

b <- c(110, 55, 50)

# Ograniczenia na produkcję (minimalna produkcja)
A2 <- diag(3)
b2 <- c(3, 0, 5)

# Pełna macierz ograniczeń i wektor prawych stron ograniczeń
A_full <- rbind(A, A2)
b_full <- c(b, b2)
dir_full <- c(rep("<=", 3), rep(">=", 3))

# Rozwiązanie problemu
lp_solution <- lp("max", obj_fun, A_full, dir_full, b_full, int.vec = 1:3)

# Zaokrąglanie wyników do najbliższych liczb całkowitych
rounded_solution <- round(lp_solution$solution)

# Wyświetlanie rozwiązania
solution <- rounded_solution
names(solution) <- PRODUCTS
print(solution)

# Ocena satysfakcji rozmytych ograniczeń
fuzzy_satisfaction <- function(solution, ASPIRATIONS, TOLERANCE) {
  # Sprawdzanie czy ograniczenia są spełnione
  income <- sum(PRODUCT_INCOME * solution)
  emissions <- sum(EMITTED_POLLUTANTS * solution)
  cost <- sum(PRODUCTION_COST * solution)
  
  S1_usage <- sum(PRODUCT_COMPONENTS[, "S1"] * solution)
  S2_usage <- sum(PRODUCT_COMPONENTS[, "S2"] * solution)
  
  satisfaction <- list(
    income = income >= ASPIRATIONS["income"] - TOLERANCE["income"],
    emissions = emissions <= ASPIRATIONS["emissions"] + TOLERANCE["emissions"],
    cost = cost <= ASPIRATIONS["cost"] + TOLERANCE["cost"],
    S1 = S1_usage <= ASPIRATIONS["S1"] + TOLERANCE["S1"],
    S2 = S2_usage <= ASPIRATIONS["S2"] + TOLERANCE["S2"]
  )
  
  return(satisfaction)
}

# Sprawdzenie satysfakcji rozmytych ograniczeń
satisfaction <- fuzzy_satisfaction(solution, ASPIRATIONS, TOLERANCE)
print(satisfaction)