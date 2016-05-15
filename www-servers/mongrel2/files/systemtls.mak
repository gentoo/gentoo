CFLAGS?=-g -O2
CFLAGS += -Wall -Wextra -I./src -DNDEBUG -D_FILE_OFFSET_BITS=64 -pthread
LIBS+=-lzmq -ldl -lsqlite3 -lmbedtls -lmbedx509 -lmbedcrypto
PREFIX?=/usr/local

get_objs = $(addsuffix .o,$(basename $(wildcard $(1))))

ASM=$(wildcard src/**/*.S src/*.S)
RAGEL_TARGETS=src/state.c src/http11/http11_parser.c
SOURCES=$(wildcard src/**/*.c src/*.c) $(RAGEL_TARGETS)
OBJECTS=$(patsubst %.c,%.o,${SOURCES}) $(patsubst %.S,%.o,${ASM})
OBJECTS_NOEXT=$(filter-out ${OBJECTS_EXTERNAL},${OBJECTS})
LIB_SRC=$(filter-out src/mongrel2.c,${SOURCES})
LIB_OBJ=$(filter-out src/mongrel2.o,${OBJECTS})
TEST_SRC=$(wildcard tests/*_tests.c)
TESTS=$(patsubst %.c,%,${TEST_SRC})
MAKEOPTS=OPTFLAGS="${NOEXTCFLAGS} ${OPTFLAGS}" LIBS="${LIBS}" DESTDIR="${DESTDIR}" PREFIX="${PREFIX}"

all: builddirs bin/mongrel2 tests m2sh procer

${OBJECTS_NOEXT}: CFLAGS += ${NOEXTCFLAGS}
${OBJECTS}:

# 
# CFLAGS_DEFS: The $(CC) flags required to obtain C pre-processor #defines, per:
# 
#   http://nadeausoftware.com/articles/2011/12/c_c_tip_how_list_compiler_predefined_macros
# 
# It may be appropriate to copy some of these platform-specific CFLAGS_DEFS assignments into the
# appropriate platform target at the end of this file, eg:
# 
#   solaris: CFLAGS_DEF=...
#   solaris: all

#CFLAGS_DEFS=-dM -E		# Portland Group PGCC
#CFLAGS_DEFS=-xdumpmacros -E	# Oracle Solaris Studio
#CFLAGS_DEFS=-qshowmacros -E	# IBM XL C
CFLAGS_DEFS=-dM -E -x c 	# clang, gcc, HP C, Intel icc

.PHONY: builddirs
builddirs:
	@mkdir -p build
	@mkdir -p bin

bin/mongrel2: build/libm2.a src/mongrel2.o
	$(CC) $(CFLAGS) $(LDFLAGS) src/mongrel2.o -o $@ $< $(LIBS)

build/libm2.a: CFLAGS += -fPIC
build/libm2.a: ${LIB_OBJ}
	ar rcs $@ ${LIB_OBJ}
	ranlib $@

clean:
	rm -rf build bin lib ${OBJECTS} ${TESTS} tests/config.sqlite
	rm -f tests/perf.log 
	rm -f tests/test.pid 
	rm -f tests/tests.log 
	rm -f tests/empty.sqlite 
	rm -f tools/lemon/lemon
	rm -f tools/m2sh/tests/tests.log 
	rm -rf release-scripts/output
	find . \( -name "*.gcno" -o -name "*.gcda" \) -exec rm {} \;
	${MAKE} -C tools/m2sh OPTLIB=${OPTLIB} clean
	${MAKE} -C tools/filters OPTLIB=${OPTLIB} clean
	${MAKE} -C tests/filters OPTLIB=${OPTLIB} clean
	${MAKE} -C tools/config_modules OPTLIB=${OPTLIB} clean
	${MAKE} -C tools/procer OPTLIB=${OPTLIB} clean

pristine: clean
	sudo rm -rf examples/python/build examples/python/dist examples/python/m2py.egg-info
	sudo find . -name "*.pyc" -exec rm {} \;
	${MAKE} -C docs/manual clean
	cd docs/ && ${MAKE} clean
	${MAKE} -C examples/kegogi clean
	rm -f logs/*
	rm -f run/*
	${MAKE} -C tools/m2sh pristine
	${MAKE} -C tools/procer pristine
	git submodule deinit -f src/mbedtls

.PHONY: tests
tests: tests/config.sqlite ${TESTS} test_filters filters config_modules
	sh ./tests/runtests.sh

tests/config.sqlite: src/config/config.sql src/config/example.sql src/config/mimetypes.sql
	sqlite3 $@ < src/config/config.sql
	sqlite3 $@ < src/config/example.sql
	sqlite3 $@ < src/config/mimetypes.sql

$(TESTS): %: %.c build/libm2.a
	$(CC) $(CFLAGS) -o $@ $< build/libm2.a $(LIBS)

src/state.c: src/state.rl src/state_machine.rl
src/http11/http11_parser.c: src/http11/http11_parser.rl
src/http11/httpclient_parser.c: src/http11/httpclient_parser.rl

check:
	@echo Files with potentially dangerous functions.
	@egrep '[^_.>a-zA-Z0-9](str(n?cpy|n?cat|xfrm|n?dup|str|pbrk|tok|_)|stpn?cpy|a?sn?printf|byte_)' $(filter-out src/bstr/bsafe.c,${SOURCES})

m2sh: build/libm2.a
	${MAKE} ${MAKEOPTS} -C tools/m2sh all

procer: build/libm2.a
	${MAKE} ${MAKEOPTS} -C tools/procer all

test_filters: build/libm2.a
	${MAKE} ${MAKEOPTS} -C tests/filters all

filters: build/libm2.a
	${MAKE} ${MAKEOPTS} -C tools/filters all

config_modules: build/libm2.a
	${MAKE} ${MAKEOPTS} -C tools/config_modules all

# Try to install first before creating target directory and trying again
install: all
	install bin/mongrel2 $(DESTDIR)/$(PREFIX)/bin/ \
	    || ( install -d $(DESTDIR)/$(PREFIX)/bin/ \
	        && install bin/mongrel2 $(DESTDIR)/$(PREFIX)/bin/ )
	${MAKE} ${MAKEOPTS} -C tools/m2sh install
	${MAKE} ${MAKEOPTS} -C tools/config_modules install
	${MAKE} ${MAKEOPTS} -C tools/filters install
	${MAKE} ${MAKEOPTS} -C tools/procer install

examples/python/mongrel2/sql/config.sql: src/config/config.sql src/config/mimetypes.sql
	cat src/config/config.sql src/config/mimetypes.sql > $@

ragel:
	ragel -G2 src/state.rl
	ragel -G2 src/http11/http11_parser.rl
	ragel -G2 src/handler_parser.rl
	ragel -G2 src/http11/httpclient_parser.rl

%.o: %.S
	$(CC) $(CFLAGS) -c $< -o $@
