library(lpSolve)
library(FuzzyR)

# Parametry
PRODUCTS <- c("P1", "P2", "P3")
COMPONENTS <- c("S1", "S2", "S3")

PRODUCT_INCOME <- c(P1 = 9, P2 = 21, P3 = 11)
EMITTED_POLLUTANTS <- c(P1 = 1, P2 = 1, P3 = 3)
PRODUCTION_COST <- c(P1 = 1, P2 = 3, P3 = 3)

PRODUCT_COMPONENTS <- matrix(c(
  2, 8, 4,  # P1
  10, 1, 0, # P2
  4, 4, 2   # P3
), nrow = 3, byrow = TRUE, dimnames = list(PRODUCTS, COMPONENTS))

COMPONENT_USAGE_HARD_LIMIT <- c(S1 = 110, S2 = 55, S3 = 50)
MINIMAL_PRODUCTION <- c(P1 = 3, P2 = 0, P3 = 5)

MIN_INCOME <- 130
MAX_EMISSIONS <- 35
MAX_COST <- 80

ASPIRATIONS <- c(S1 = 100, S2 = 50, income = 150, emissions = 30, cost = 70)

# Tolerancje dla celów
TOLERANCE <- COMPONENT_USAGE_HARD_LIMIT[c("S1", "S2")] - ASPIRATIONS[c("S1", "S2")]
TOLERANCE["income"] <- ASPIRATIONS["income"] - MIN_INCOME
TOLERANCE["emissions"] <- MAX_EMISSIONS - ASPIRATIONS["emissions"]
TOLERANCE["cost"] <- MAX_COST - ASPIRATIONS["cost"]

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

# Rozwiązywanie problemu
lp_solution <- lp("max", obj_fun, A_full, dir_full, b_full)

# Wyświetlanie rozwiązania
solution <- lp_solution$solution
names(solution) <- PRODUCTS
print(solution)

# Rozmyte ograniczenia
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