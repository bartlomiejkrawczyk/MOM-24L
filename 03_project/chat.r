library(FuzzyLP)

# Definiowanie danych
products <- c("P1", "P2", "P3")
components <- c("S1", "S2", "S3")
product_income <- c(9, 21, 11)
emitted_pollutants <- c(1, 1, 3)
production_cost <- c(1, 3, 3)
product_components <- matrix(c(2, 10, 4, 8, 1, 4, 4, 0, 2), nrow = 3, byrow = TRUE)

# Limity i aspiracje
component_usage_hard_limit <- c(110, 55, 50)
minimal_production <- c(3, 0, 5)
min_income <- 130
max_emissions <- 35
max_cost <- 80
aspirations <- c(100, 50, 150, 30, 70)

# Definiowanie zmiennych decyzyjnych
fuzzy_model <- FuzzyLinearProgram()

# Dodanie zmiennych decyzyjnych
for (p in products) {
  addVariable(fuzzy_model, p)
}

# Dodanie ograniczeń związanych z komponentami
for (c in 1:length(components)) {
  component_constraint <- paste0("component_usage_", components[c])
  addConstraint(fuzzy_model, component_constraint, "<=", component_usage_hard_limit[c])
  
  usage <- paste0(product_components[c, ], "*", products)
  usage_constraint <- paste(usage, collapse = " + ")
  constraint <- paste0(component_constraint, " = ", usage_constraint)
  addConstraint(fuzzy_model, constraint)
}

# Dodanie ograniczeń dotyczących minimalnej produkcji
for (p in 1:length(products)) {
  addConstraint(fuzzy_model, paste0(products[p], " >= ", minimal_production[p]))
}

# Dodanie funkcji celu
# Maksymalizacja zysków
income <- paste0(product_income, "*", products)
income_function <- paste(income, collapse = " + ")
addObjective(fuzzy_model, income_function, "max")

# Minimalizacja emisji
emissions <- paste0(emitted_pollutants, "*", products)
emissions_function <- paste(emissions, collapse = " + ")
addObjective(fuzzy_model, emissions_function, "min")

# Minimalizacja kosztów
cost <- paste0(production_cost, "*", products)
cost_function <- paste(cost, collapse = " + ")
addObjective(fuzzy_model, cost_function, "min")

# Rozmyte cele
addFuzzyObjective(fuzzy_model, "income", "min", aspirations[3], min_income)
addFuzzyObjective(fuzzy_model, "emissions", "min", aspirations[4], max_emissions)
addFuzzyObjective(fuzzy_model, "cost", "min", aspirations[5], max_cost)

# Rozwiązywanie modelu
result <- solveFuzzyLP(fuzzy_model)

# Wyświetlanie wyników
print(result)
