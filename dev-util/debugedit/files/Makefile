CPPFLAGS += -I.
LDLIBS = -lelf -lpopt -lbeecrypt

all: debugedit

debugedit: debugedit.o hashtab.o

clean:
	rm -f *.o debugedit

.PHONY: clean
