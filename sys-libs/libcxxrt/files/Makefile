LIB=cxxrt
MAJ=1
OBJS=dynamic_cast.o exception.o guard.o stdexcept.o typeinfo.o memory.o auxhelper.o libelftc_dem_gnu3.o
SOBJS=${OBJS:.o=.So}

static: lib$(LIB).a

shared: lib$(LIB).so

%.So: %.cc
	$(CXX) -fPIC $(CXXFLAGS) $(CPPFLAGS) -c -o $@ $<

%.So: %.c
	$(CC) -fPIC $(CFLAGS) $(CPPFLAGS) -c -o $@ $<

lib$(LIB).a: $(OBJS)
	$(AR) cr $@ $^

lib$(LIB).so.$(MAJ): $(SOBJS)
	$(CXX) -fPIC -nodefaultlibs $(CXXFLAGS) $(LDFLAGS) -shared -Wl,-soname,$@ -o $@ $^ $(LIBS)

lib$(LIB).so: lib$(LIB).so.$(MAJ)
	ln -s $< $@
