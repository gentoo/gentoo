ASFLAGS+=-Wa,--noexecstack
CXXFLAGS+=-std=c++11
CPPFLAGS+=-I../include
LDFLAGS+=-Wl,-z,noexecstack
LIBS+=-lc

LIB=libunwind
MAJOR=1
MINOR=0
SONAME=$(LIB).so.$(MAJOR)
SHLIB=$(LIB).so.$(MAJOR).$(MINOR)

C_SRCS=$(wildcard *.c)
ASM_SRCS=$(wildcard *.S)
CXX_SRCS=$(filter-out Unwind_AppleExtras.cpp,$(wildcard *.cpp))
OBJS=$(C_SRCS:%.c=%.o) $(ASM_SRCS:%.S=%.o) $(CXX_SRCS:%.cpp=%.o)
SOBJS=$(OBJS:%.o=%.So)

%.So: %.c
	$(CC) $(CPPFLAGS) $(CFLAGS) -fPIC -c -o $@ $<

%.So: %.S
	$(CC) $(CPPFLAGS) -fPIC -c -o $@ $<

%.So: %.cpp
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -fPIC -c -o $@ $<

$(SHLIB): $(SOBJS)
	$(CXX) $(CXXFLAGS) $(LDFLAGS) -fPIC -shared -nodefaultlibs \
		-Wl,-soname,$(SONAME) -o $@ $^ $(LIBS)

$(SONAME): $(SHLIB)
	ln -s $< $@

$(LIB).so: $(SONAME)
	ln -s $< $@

$(LIB).a: $(OBJS)
	$(AR) cr $@ $^

shared: $(LIB).so

static: $(LIB).a
