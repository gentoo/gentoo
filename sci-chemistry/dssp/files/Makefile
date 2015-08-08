#OBJ = AccSurf.o CalcAccSurf.o Contacts.o Date.o Dssp.o DsspCMBI.o p2clib.o Vector.o
OBJ = AccSurf.o CalcAccSurf.o Contacts.o Date.o DsspCMBI.o p2clib.o Vector.o

LIBS = -lm

dssp: $(OBJ)
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $(OBJ) $(LIBS)
