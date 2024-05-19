# # AMPL Specyfikacja modelu
# param z0 := 7;
# param z1 := 16 ;
# param t0 := 16;
# param t1 := 6;
# param t2 := 4;
# param t3 := 10;
# # Deklaracja zmiennych ( variables )
# var x >= 0;
# var y >= 0;
# var alpha ;
# # Funkcja celu ( Objective )
# maximize obj : alpha ;
# # Ograniczenia
# subject to o0 : 2* x+y >= z1 -(z1 - z0 )*(1 - alpha );
# subject to o1 : x <= 3+ t1 *(1 - alpha );
# subject to o2 : x + y <= 4+ t2 *(1 - alpha );
# subject to o3 : x + 5*y <= 15 + t3 *(1 - alpha );
# subject to o4 : alpha >=0;
# subject to o5 : alpha <=1;
# solve ;
# display : x , y , alpha , o0 , o1 , o2 , o3 ;
# display : "2* x+y =" , 2* x+ y;
# display : " x =" , x;
# display : " x+y =" , x +y;
# display : " x +5 y =" , x +5* y ;
# end ;
library(FuzzyLP)
objective <- c (2, 1)
A <- matrix (c (
#   P1   P2   P3
    1.0, 1.0, 
    1.0, 0.0, 
    1.0, 5.0
    ), nrow = 3)
direction <- c ("<=", "<=", "<=")
aspiration <- c (3, 4, 15)
tolerance <- c (6, 4, 10)
max <- TRUE
# Zadanie Liniowe
result <- crispLP(objective, A, direction, aspiration, maximum = max, verbose = TRUE)
print(result)
# Zadanie Zimmermana
result <- FCLP.fuzzyObjective(objective, A, direction, aspiration, tolerance, z0 = 16, t0 = 16, maximum = max, verbose = TRUE)
print(result)
# Zadanie Werners
result <- FCLP.fuzzyUndefinedObjective(objective, A, direction, aspiration, tolerance, maximum = max, verbose = TRUE)
print(result)
