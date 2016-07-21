CXXFLAGS+=-std=c++11 -fstrict-aliasing -Wall -Wextra -Wshadow -Wconversion \
	  -Wpadded -Wstrict-aliasing=2 -Wstrict-overflow=4

SRCDIR=..
LIB=libc++
STATIC=libc++.a
MAJOR=1
MINOR=0
SHEXT?=.so
SHLIB=$(LIB)$(SHEXT).$(MAJOR).$(MINOR)
SONAME=$(LIB)$(SHEXT).$(MAJOR)

SRC=$(wildcard $(SRCDIR)/src/*.cpp)
OBJ=$(SRC:$(SRCDIR)/src/%.cpp=%.o)
SOBJ=$(SRC:$(SRCDIR)/src/%.cpp=%.So)


%.So: $(SRCDIR)/src/%.cpp
	$(CXX) -I$(SRCDIR)/include $(CPPFLAGS) $(CXXFLAGS) -fPIC -nostdinc++ -c $< -o $@

%.o: $(SRCDIR)/src/%.cpp
	$(CXX) -I$(SRCDIR)/include $(CPPFLAGS) $(CXXFLAGS) -nostdinc++ -c $< -o $@

$(STATIC): $(OBJ)
	$(AR) cr $@ $^

static: $(STATIC)

$(SHLIB): $(SOBJ)
	$(CXX) -fPIC -nodefaultlibs $(CXXFLAGS) $(LDFLAGS) -shared -Wl,-soname,$(SONAME) -o $@ $^ $(LIBS)

$(SONAME): $(SHLIB)
	ln -s $< $@

$(LIB)$(SHEXT): $(SONAME)
	ln -s $< $@

shared: $(SHLIB) $(SONAME) $(LIB)$(SHEXT)
