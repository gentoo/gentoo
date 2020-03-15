# this file builds lua-utf8

MY_USE_LUA?=luajit
PKG_CONFIG?=pkg-config
PREFIX?=/usr/local
DESTDIR?=/

LUA_LIBDIR      := $(shell $(PKG_CONFIG) --variable INSTALL_CMOD $(MY_USE_LUA))
LUA_INC         := $(shell $(PKG_CONFIG) --variable INSTALL_INC $(MY_USE_LUA))
LUA_SHARE       := $(shell $(PKG_CONFIG) --variable INSTALL_LMOD $(MY_USE_LUA))
CWARNS          := -Wall -pedantic
CFLAGS          += -I$(LUA_INC) -fPIC $(CWARNS)
LIB_OPTION      := -shared
LDFLAGS         += $(LIB_OPTION)

SONAME          := lua-utf8.so
SONAMEV         := $(SONAME).0
LIBRARY         := $(SONAMEV).1.1
SRC             := lutf8lib.c
OBJ             := $(patsubst %.c, %.o, $(SRC))

FILES           := parseucd.lua

all: $(LIBRARY) $(SONAMEV) $(SONAME)

$(SONAMEV):
	ln -s $(LIBRARY) $@

$(SONAME):
	ln -s $(SONAMEV) $@

$(LIBRARY): $(OBJ)
	$(CC) $(CFLAGS) $(LDFLAGS) -o $(LIBRARY) $(OBJ) -lc

install:
	install -d $(DESTDIR)$(LUA_LIBDIR)
	install $(SONAME) $(DESTDIR)$(LUA_LIBDIR)
	install -d $(DESTDIR)$(LUA_SHARE)
	install --mode=0444 $(FILES) $(DESTDIR)$(LUA_SHARE)

clean:
	rm -rf $(LIBRARY) $(SONAMEV) $(SONAME) *.o
