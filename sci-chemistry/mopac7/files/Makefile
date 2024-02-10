VERSION = GENTOOVERSION
MAJOR = 1

LIBS = -lgfortran -lf2c

objects := $(patsubst %.f,%.o,$(wildcard *.f))

all: libgmxmopac7

clean:
	 rm -f moldat.*f deriv.* mopac7*.* compfg.* dcart.*

%.o: %.f
	$(FC) $(FFLAGS) -fPIC -c $<

libgmxmopac7: $(objects)
	$(FC) -shared $(LDFLAGS) -Wl,-soname,libgmxmopac7.so.$(MAJOR) -o $@.so.$(VERSION) $^ $(LIBS)
	ln -sf $@.so.$(VERSION) libgmxmopac7.so
