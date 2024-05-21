library(FuzzyLP)

constraints <- matrix(
    c(
    #   P1  P2  P3
        2,  10, 4, # S1 <= 100 tolerance 10  
        8,  1,  4, # S2 <= 50 tolerance 5
        4,  0,  2, # S3 <= 50 tolerance 0
        1,  0,  0, # P1 >= 3 tolerance 0
        0,  0,  1, # P3 >= 5 tolerance 0
        9,  19, 9, # income >= 150 tolerance 20
        1,  1,  3, # emissions <= 30 tolerance 5
        1,  3,  3  # cost <= 70 tolerance 10
    ),
    nrow = 8, 
    byrow = TRUE
)
directions <- c("<=", "<=", "<=", ">=", ">=", ">=", "<=", "<=")
aspiration <- c(100,  50,   50,   3,    5,    150,  30,   70)
tolerance  <- c(10,   5,    0,    0,    0,    20,   5,    10)

calculate <- function(objective, target, target_tolerance, maximum) {
    result <- FCLP.fuzzyObjective(
        objective, 
        constraints, 
        directions, 
        aspiration, 
        tolerance, 
        z0=target,
        t0=target_tolerance, 
        maximum=maximum, 
        verbose=TRUE
    )
    return(result)
}

show_results <- function(result, name) {
    income    <- sum(objective_income * result[, c("x1", "x2", "x3")])
    emissions <- sum(objective_emissions * result[, c("x1", "x2", "x3")])
    cost      <- sum(objective_cost * result[, c("x1", "x2", "x3")])

    S1_component_usage <- 2 * result[, "x1"] + 10 * result[, "x2"] + 4 * result[, "x3"]
    S2_component_usage <- 8 * result[, "x1"] + 1  * result[, "x2"] + 4 * result[, "x3"]
    S3_component_usage <- 4 * result[, "x1"] + 0  * result[, "x2"] + 2 * result[, "x3"]
    
    cat("objective =", name, "\n")
    cat("income =", income, "\n")
    cat("emissions =", emissions, "\n")
    cat("cost =", cost, "\n")
    cat("S1_component_usage =", S1_component_usage, "\n")
    cat("S2_component_usage =", S2_component_usage, "\n")
    cat("S3_component_usage =", S3_component_usage, "\n\n")
}

objective_income <- c(9, 19, 9)
objective_emissions <- c(1, 1, 3)
objective_cost <- c(1, 3, 3)

cat("Maximizing/Minimizing only the objective\n\n")

result <- calculate(objective_income, 250, 20, TRUE)
show_results(result, "income")

result <- calculate(objective_emissions, 20, 2, FALSE)
show_results(result, "emissions")

result <- calculate(objective_cost, 26, 2, FALSE)
show_results(result, "cost")

cat("\n\nTrying only to reach the aspirations\n\n")

result <- calculate(objective_income, 150, 20, TRUE)
show_results(result, "income")

result <- calculate(objective_emissions, 30, 5, FALSE)
show_results(result, "emissions")

result <- calculate(objective_cost, 70, 10, FALSE)
show_results(result, "cost")
