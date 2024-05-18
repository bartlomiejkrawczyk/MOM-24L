library(FuzzyLP)
obj <- c (2, 1)
A <- matrix (c (1.0, 1.0, 1.0, 0.0, 1.0, 5.0), nrow = 3)
dir <- c ("<=", "<=", "<=")
b <- c (3, 4, 15)
t <- c (6, 4, 10)
max <- TRUE
# Zadanie Liniowe
result <- crispLP(obj, A, dir, b, maximum = max, verbose = TRUE)
print(result)
# Zadanie Zimmermana
result <- FCLP.fuzzyObjective(obj, A, dir, b, t, z0 = 16, t0 = 16, maximum = max, verbose = TRUE)
print(result)
# Zadanie Werners
result <- FCLP.fuzzyUndefinedObjective(obj, A, dir, b, t, maximum = max, verbose = TRUE)
print(result)
