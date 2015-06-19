#
# Makefile for a Video Disk Recorder plugin
#
# $Id: music.mk,v 1.1 2013/06/30 10:30:01 hd_brummy Exp $

# The official name of this plugin.
# This name will be used in the '-P...' option of VDR to load the plugin.
# By default the main source file also carries this name.

PLUGIN = music

### The version number of this plugin (taken from the main source file):

VERSION = $(shell grep 'static const char \*VERSION *=' $(PLUGIN).c | awk '{ print $$6 }' | sed -e 's/[";]//g')

### The directory environment:

# Use package data if installed...otherwise assume we're under the VDR source directory:
PKGCFG = $(if $(VDRDIR),$(shell pkg-config --variable=$(1) $(VDRDIR)/vdr.pc),$(shell pkg-config --variable=$(1) vdr || pkg-config --variable=$(1) ../../../vdr.pc))
LIBDIR = $(call PKGCFG,libdir)
LOCDIR = $(call PKGCFG,locdir)
PLGCFG = $(call PKGCFG,plgcfg)
#
TMPDIR ?= /tmp

### The compiler options:

export CFLAGS   = $(call PKGCFG,cflags)
export CXXFLAGS = $(call PKGCFG,cxxflags)

### The version number of VDR's plugin API:

APIVERSION = $(call PKGCFG,apiversion)

### Allow user defined options to overwrite defaults:

-include $(PLGCFG)

### The name of the distribution archive:

ARCHIVE = $(PLUGIN)-$(VERSION)
PACKAGE = vdr-$(ARCHIVE)

### The name of the shared object file:

SOFILE = libvdr-$(PLUGIN).so

### Includes and Defines (add further entries here):

# (Default) DO NOT UNCOMMENT IT IN DEVELOPER-VERSIONS
HAVE_IMAGEMAGICK=1
# Uncomment the following line, if you don't have libsndfile installed
#WITHOUT_LIBSNDFILE=1

# Uncomment the following line, if you don't have libvorbisfile installed
#WITHOUT_LIBVORBISFILE=1

#BROKEN_PCM=1
# Uncomment if you want debug output on stdout
##DEBUG=1

# internal use
# BUGHUNT
#BUGHUNT=1

# internal use
# DEBUG_COVER
#DEBUG_COVER=1

###INCLUDES +=

###DEFINES += -DPLUGIN_NAME_I18N='"$(PLUGIN)"'
INCLUDES += -I$(VDRINCDIR)

DEFINES += -D_GNU_SOURCE -DPLUGIN_NAME_I18N='"$(PLUGIN)"'

ifdef BROKEN_PCM
	DEFINES += -DBROKEN_PCM
endif

ifeq ($(shell test -f $(VDRDIR)/fontsym.h ; echo $$?),0)
	DEFINES += -DHAVE_BEAUTYPATCH
endif

ifdef DBG
	CXXFLAGS += -g
endif

ifdef DEBUG
	DEFINES += -DDEBUG
else
	DEFINES += -DNO_DEBUG
endif

ifdef BUGHUNT
	DEFINES += -DBUGHUNT
endif

ifdef DEBUG_COVER
	DEFINES += -DDEBUG_COVER
endif

### The object files (add further files here):

OBJS = $(PLUGIN).o config.o vars.o bitmap.o \
		commands.o options.o lyrics.o funct.o cover.o skin.o visual.o tracklist.o \
		search.o mp3id3.o mp3id3tag.o rating.o menubrowse.o mp3control.o \
		icons.o data.o menu.o \
		data-mp3.o setup-mp3.o player-mp3.o stream.o network.o \
		decoder.o decoder-mp3.o decoder-mp3-stream.o decoder-snd.o \
		decoder-ogg.o

LIBS	+= -lasound -lmad -lid3tag

ifdef HAVE_IMAGEMAGICK
	INCLUDES += $(shell pkg-config --cflags MagickCore)
	LIBS += $(shell pkg-config --libs Magick++)
	DEFINES += -DHAVE_IMAGEMAGICK
else
	INCLUDES += -I$(IMLIB)/src
	LIBS += $(shell imlib2-config --libs)
	DEFINES += -DHAVE_IMLIB2
endif

ifndef WITHOUT_LIBSNDFILE
	LIBS    += -lsndfile
	DEFINES += -DHAVE_SNDFILE
endif

ifndef WITHOUT_LIBVORBISFILE
	LIBS    += -lvorbisfile -lvorbis
	DEFINES += -DHAVE_VORBISFILE
endif

### The main target:

all: $(SOFILE) i18n

### Implicit rules:

%.o: %.c
	$(CXX) $(CXXFLAGS) -c $(DEFINES) $(INCLUDES) -o $@ $<

### Dependencies:

MAKEDEP = $(CXX) -MM -MG
DEPFILE = .dependencies
$(DEPFILE): Makefile
	@$(MAKEDEP) $(CXXFLAGS) $(DEFINES) $(INCLUDES) $(OBJS:%.o=%.c) > $@

-include $(DEPFILE)

### Internationalization (I18N):

PODIR     = po
I18Npo    = $(wildcard $(PODIR)/*.po)
I18Nmo    = $(addsuffix .mo, $(foreach file, $(I18Npo), $(basename $(file))))
I18Nmsgs  = $(addprefix $(DESTDIR)$(LOCDIR)/, $(addsuffix /LC_MESSAGES/vdr-$(PLUGIN).mo, $(notdir $(foreach file, $(I18Npo), $(basename $(file))))))
I18Npot   = $(PODIR)/$(PLUGIN).pot

%.mo: %.po
	msgfmt -c -o $@ $<

$(I18Npot): $(wildcard *.c)
	xgettext -C -cTRANSLATORS --no-wrap --no-location -k -ktr -ktrNOOP --package-name=vdr-$(PLUGIN) --package-version=$(VERSION) --msgid-bugs-address='<see README>' -o $@ `ls $^`

%.po: $(I18Npot)
	msgmerge -U --no-wrap --no-location --backup=none -q -N $@ $<
	@touch $@

$(I18Nmsgs): $(DESTDIR)$(LOCDIR)/%/LC_MESSAGES/vdr-$(PLUGIN).mo: $(PODIR)/%.mo
	install -D -m644 $< $@

.PHONY: i18n
i18n: $(I18Nmo) $(I18Npot)

install-i18n: $(I18Nmsgs)

### Targets:

$(SOFILE): $(OBJS)
	$(CXX) $(CXXFLAGS) $(LDFLAGS) -shared $(OBJS) -o $@

install-lib: $(SOFILE)
	install -D $^ $(DESTDIR)$(LIBDIR)/$^.$(APIVERSION)

install: install-lib install-i18n

dist: $(I18Npo) clean
	@-rm -rf $(TMPDIR)/$(ARCHIVE)
	@mkdir $(TMPDIR)/$(ARCHIVE)
	@cp -a * $(TMPDIR)/$(ARCHIVE)
	@tar czf $(PACKAGE).tgz -C $(TMPDIR) $(ARCHIVE)
	@-rm -rf $(TMPDIR)/$(ARCHIVE)
	@echo Distribution package created as $(PACKAGE).tgz

clean:
	@-rm -f $(PODIR)/*.mo $(PODIR)/*.pot
	@-rm -f $(OBJS) $(DEPFILE) *.so *.tgz core* *~
