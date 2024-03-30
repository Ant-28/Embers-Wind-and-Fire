FC = gfortran
FFLAGS = -g -gdwarf-4 -Wall -Wextra -Wimplicit-interface -fmax-errors=5

OBJ = utility.o error_module.o output_module.o setup_module.o fire_module.o

fire_prop.ex: $(OBJ) fire_prop.o
	$(FC) $(FLAGS) -o $@ $^ 

test.ex: $(OBJ) test.o
	$(FC) $(FLAGS) -o $@ $^ 

%.o: %.f90
	$(FC) $(FFLAGS) -c $<

.PHONY: clean



clean:
	rm -f *.ex *.o *.mod *~
