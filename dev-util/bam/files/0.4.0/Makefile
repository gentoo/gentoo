LIBS		+= -lm -lpthread -llua -ldl
TARGETS	= txt2c internal_base bam
BAM_OBJ	= $(patsubst %.c,%.o,$(wildcard src/*.c))
TXT2C_LUA	= $(wildcard src/*.lua)

all: $(TARGETS)

txt2c: src/tools/txt2c

internal_base: src/internal_base.h

src/internal_base.h:
	src/tools/txt2c $(TXT2C_LUA) > src/internal_base.h

bam: txt2c internal_base $(BAM_OBJ)
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $(BAM_OBJ) $(LIBS)

test: $(TARGETS)
	python scripts/test.py

clean:
	rm -f $(BAM_OBJ) $(TARGETS) src/internal_base.h src/tools/txt2c
