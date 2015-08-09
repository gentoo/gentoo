# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# Author:  Martin Schlemmer <azarah@gentoo.org>
# $Id$

CC ?= gcc
LD = $(CC)

MAJORVER = 0
MINORVER = 0.1

AWKINCDIR = /usr/include/awk
DESTDIR =

TARGET = filefuncs
TARGET_LIB = $(TARGET).so.$(MAJORVER).$(MINORVER)

LIBDIR = lib

# Gentoo specific cruft, you like it dont ya idiot
ifdef D
DESTDIR = $(D)
endif
ifdef S
AWKINCDIR = $(S)
endif

DOIT = yes
ifeq ($(USERLAND),Darwin)
DOIT = no
endif

ifeq ($(DOIT),yes)

all: $(TARGET_LIB)

$(TARGET).o: $(TARGET).c
	$(CC) $(CFLAGS) $(CPPFLAGS) -shared -Wall -DHAVE_CONFIG_H -c -O2 -fPIC -I$(AWKINCDIR) $^

$(TARGET_LIB): $(TARGET).o
	$(LD) $(LDFLAGS) -o $@ -shared -Wl,-soname -Wl,$(TARGET).so.$(MAJORVER) $^

install: $(TARGET_LIB)
	install -m 0755 -d $(DESTDIR)/$(LIBDIR)/rcscripts
	install -m 0755 $(TARGET_LIB) $(DESTDIR)/$(LIBDIR)/rcscripts
	ln -s $(TARGET_LIB) $(DESTDIR)/$(LIBDIR)/rcscripts/$(TARGET).so.$(MAJORVER)
	ln -s $(TARGET_LIB) $(DESTDIR)/$(LIBDIR)/rcscripts/$(TARGET).so

clean:
	rm -f $(TARGET)
	rm -f *.o *~ core

else

all install clean:

endif
