library(FuzzyLP)

# Funkcje oceny
objective_income <- c(9, 19, 9)
objective_emissions <- c(1, 1, 3)
objective_cost <- c(1, 3, 3)

# Ograniczenia
constraints <- matrix(
    c(
    #   P1  P2  P3
        2,  10, 4, # S1 <= 100 tolerance 10  
        8,  1,  4, # S2 <= 50 tolerance 5
        4,  0,  2, # S3 <= 50 tolerance 0
        1,  0,  0, # P1 >= 3 tolerance 0
        0,  0,  1, # P3 >= 5 tolerance 0
        9,  19, 9, # income >= 170 tolerance 20
        1,  1,  3, # emissions <= 30 tolerance 5
        1,  3,  3  # cost <= 70 tolerance 10
    ),
    nrow = 8, 
    byrow = TRUE
)
directions <- c("<=", "<=", "<=", ">=", ">=", ">=", "<=", "<=")
aspiration <- c(100,  50,   50,   3,    5,    150,  30,   70)
tolerance  <- c(10,   5,    0,    0,    0,    20,   5,    10)

result <- FCLP.fuzzyObjective(
    objective_income, 
    constraints, 
    directions, 
    aspiration, 
    tolerance, 
    z0=1000, 
    t0=1000, 
    maximum=TRUE, 
    verbose=TRUE
)

print(result)

result <- FCLP.fuzzyObjective(
    objective_emissions, 
    constraints, 
    directions, 
    aspiration, 
    tolerance, 
    z0=0, 
    t0=35, 
    maximum=FALSE,
    verbose=TRUE
)

print(result)

result <- FCLP.fuzzyObjective(
    objective_cost, 
    constraints, 
    directions, 
    aspiration, 
    tolerance, 
    z0=0, 
    t0=80,
    maximum=FALSE,
    verbose=TRUE
)

print(result)
