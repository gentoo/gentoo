SRC = FastCollector.c
OBJ = ${SRC:.c=.o}

LIBS = -lpcap

all: FastCollector

.c.o:
	$(CC) -c $(CFLAGS) $<

FastCollector: $(OBJ)
	$(CC) -o $@ $(CFLAGS) $(LDFLAGS) $(OBJ) $(LIBS)
