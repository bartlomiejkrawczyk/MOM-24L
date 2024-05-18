# install.packages('FuzzyLP')
library(FuzzyLP)

# Funkcje celu
objective_profit <- c(9, 19, 9)
objective_pollution <- c(1, 1, 3)
objective_cost <- c(1, 3, 3)

# Ograniczenia twarde i rozmyte
constraints <- matrix(c(4, 0, 2,   # S3 <= 50
                        1, 0, 0,   # P1 >= 3
                        0, 0, 1,   # P3 >= 5
                        2, 10, 4,  # S1 <= 100 (fuzzy)
                        8, 1, 4),  # S2 <= 50 (fuzzy)
                      nrow = 5, byrow = TRUE)
rhs_constraints <- c(50, 3, 5, 100, 50)
directions <- c("<=", ">=", ">=", "<=", "<=")
rhs_fuzzy <- c(10, 5)

result <- FCLP.fuzzyObjective(objective_profit, constraints, directions, rhs_constraints, rhs_fuzzy, z0=150, t0=20, maximum=TRUE, verbose=TRUE)

print(result)
