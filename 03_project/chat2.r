library(FuzzyLP)

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
TOLERANCE <- COMPONENT_USAGE_HARD_LIMIT - ASPIRATIONS[c("S1", "S2")]
TOLERANCE["income"] <- ASPIRATIONS["income"] - MIN_INCOME
TOLERANCE["emissions"] <- MAX_EMISSIONS - ASPIRATIONS["emissions"]
TOLERANCE["cost"] <- MAX_COST - ASPIRATIONS["cost"]

# Funkcja celu dla każdego kryterium
income <- c(9, 21, 11)
emissions <- c(1, 1, 3)
cost <- c(1, 3, 3)

# Ograniczenia na komponenty
A <- rbind(
  c(2, 10, 4),   # S1
  c(8, 1, 4),    # S2
  c(4, 0, 2)     # S3
)

b <- c(110, 55, 50)

# Ograniczenia na produkcję
lower_bounds <- c(3, 0, 5)
upper_bounds <- rep(Inf, length(PRODUCTS))

# Model rozmyty
fuzzy_model <- FuzzyLP::fuzzy.obj.linprog(
  a = A, 
  b = b, 
  c = income, 
  relation = rep("<=", length(b)), 
  minimum = FALSE, 
  f.obj.target = ASPIRATIONS["income"], 
  f.obj.max.deviation = TOLERANCE["income"], 
  int.sol = FALSE
)

# Dodaj ograniczenia
fuzzy_model <- FuzzyLP::add.fuzzy.constraint(
  fuzzy_model, 
  f.obj = emissions, 
  f.obj.target = ASPIRATIONS["emissions"], 
  f.obj.max.deviation = TOLERANCE["emissions"], 
  minimum = TRUE
)

fuzzy_model <- FuzzyLP::add.fuzzy.constraint(
  fuzzy_model, 
  f.obj = cost, 
  f.obj.target = ASPIRATIONS["cost"], 
  f.obj.max.deviation = TOLERANCE["cost"], 
  minimum = TRUE
)

# Dodaj ograniczenia twarde
fuzzy_model <- FuzzyLP::add.constraint(
  fuzzy_model, 
  A = diag(length(PRODUCTS)), 
  b = lower_bounds, 
  relation = rep(">=", length(lower_bounds))
)

fuzzy_model <- FuzzyLP::add.constraint(
  fuzzy_model, 
  A = diag(length(PRODUCTS)), 
  b = upper_bounds, 
  relation = rep("<=", length(upper_bounds))
)

# Rozwiąż model
solution <- FuzzyLP::solve(fuzzy_model)

# Wyświetl wyniki
solution$solution
solution$fuzziness
