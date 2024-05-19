# Instalacja i załadowanie pakietu FuzzyLP
if (!require(FuzzyLP)) install.packages("FuzzyLP")
library(FuzzyLP)

# Definicja parametrów
PRODUCTS <- c("P1", "P2", "P3")
COMPONENTS <- c("S1", "S2", "S3")
PRODUCT_INCOME <- c(9, 21, 11)
EMITTED_POLLUTANTS <- c(1, 1, 3)
PRODUCTION_COST <- c(1, 3, 3)
PRODUCT_COMPONENTS <- matrix(c(2, 8, 4, 10, 1, 0, 4, 4, 2), nrow=3, byrow=TRUE)

# Definicja ograniczeń
constraints <- list(
  "S1" = fuzzy_constraint(type="trapezoid", a=100, b=110, min=0, max=110),
  "S2" = fuzzy_constraint(type="trapezoid", a=50, b=55, min=0, max=100),
  "S3" = fuzzy_constraint(type="trapezoid", a=0, b=50, min=0, max=50),
  "P1" = fuzzy_constraint(type="trapezoid", a=3, b=Inf, min=0, max=100),
  "P3" = fuzzy_constraint(type="trapezoid", a=5, b=Inf, min=0, max=100)
)

# Definicja celów
objectives <- list(
  "income" = fuzzy_objective(type="trapezoid", a=130, b=150, min=0, max=200, direction="max"),
  "emissions" = fuzzy_objective(type="trapezoid", a=30, b=35, min=0, max=50, direction="min"),
  "cost" = fuzzy_objective(type="trapezoid", a=70, b=80, min=0, max=100, direction="min")
)

# Rozwiązanie problemu
solution <- fuzzy_lp(PRODUCTS, COMPONENTS, PRODUCT_INCOME, EMITTED_POLLUTANTS, PRODUCTION_COST, PRODUCT_COMPONENTS, constraints, objectives)

# Wyświetlenie wyników
print(solution)