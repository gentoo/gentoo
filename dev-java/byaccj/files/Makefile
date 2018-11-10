#################################################
## Makefile for Byacc/Java
## Date: 06 Aug 00
## Author: Bob Jamison
#################################################

CC      = gcc
CFLAGS  = -O
LDFLAGS = -static
TAR     = tar
GZIP    = gzip
VERS    = byaccj1.15
JAVA    = /usr/java
ZIP     = zip

INC     = -I.

OBJ 	= closure.o \
	error.o \
	lalr.o \
	lr0.o \
	main.o \
	mkpar.o \
	output.o \
	reader.o \
	skeleton.o \
	symtab.o \
	verbose.o \
	warshall.o

irix: yacc
	mv yacc yacc.irix
linux: yacc
	mv yacc yacc.linux
solaris: yacc
	mv yacc yacc.solaris

all: yacc

dist:
	( \
	cd .. ; \
	/bin/rm -rf $(VERS) ; \
	/bin/mkdir -p $(VERS) ; \
	/bin/mkdir -p dist ; \
        /bin/cp -r docs $(VERS) ; \
	/bin/mkdir -p $(VERS)/src ; \
        /bin/cp src/*.c $(VERS)/src ; \
        /bin/cp src/*.h $(VERS)/src ; \
        /bin/cp src/Makefile $(VERS)/src ; \
        /bin/cp src/Makefile.bcc $(VERS)/src ; \
        /bin/cp -f src/yacc.irix $(VERS) ; \
        /bin/cp -f src/yacc.solaris $(VERS) ; \
        /bin/cp -f src/yacc.linux $(VERS) ; \
        /bin/cp -f src/yacc.exe $(VERS) ; \
        /bin/cp src/README $(VERS) ; \
	$(TAR) -cvf - $(VERS) | $(GZIP) > dist/$(VERS).tar.gz ;\
	$(ZIP) dist/$(VERS).zip $(VERS) \
	)

SRCS   = closure.c \
	error.c \
	lalr.c \
	lr0.c \
	main.c \
	mkpar.c \
	output.c \
	reader.c \
	skeleton.c \
	symtab.c \
	verbose.c \
	warshall.c

%.o : %.c
	$(CC) -c $(CFLAGS) $(INC) $< -o $@

yacc: $(OBJ)
	$(CC) $(LDFLAGS) -o yacc $(OBJ)
	@echo "done"

clean:
	/bin/rm -rf *.o  *.obj yacc y.tab.c *.java *.class
	/bin/rm -rf yacc.linux yacc.irix yacc.solaris yacc.exe
	(cd .. ; /bin/rm -rf $(VERS) ; /bin/rm -rf dist )

### Dependencies
closure.o:  closure.c defs.h
error.o:    error.c defs.h
lalr.o:     lalr.c defs.h
lr0.o:      lr0.c defs.h
main.o:     main.c defs.h
mkpar.o:    mkpar.c defs.h
output.o:   output.c defs.h
reader.o:   reader.c defs.h
skeleton.o: skeleton.c defs.h
symtab.o:   symtab.c defs.h
verbose.o:  verbose.c defs.h
warshall.o: warshall.c defs.h

