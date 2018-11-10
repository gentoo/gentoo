BINDIR = /usr/bin
DESTDIR = /usr/share/sgml/docbook/dsssl-stylesheets-1.76

all: install

install:
	mkdir -p $(BINDIR)
	mkdir -p $(DESTDIR)/dtds/decls
	mkdir -p $(DESTDIR)/lib
	mkdir -p $(DESTDIR)/common
	mkdir -p $(DESTDIR)/html
	mkdir -p $(DESTDIR)/print
	mkdir -p $(DESTDIR)/test
	mkdir -p $(DESTDIR)/images
	install bin/collateindex.pl $(BINDIR)
	cp catalog $(DESTDIR)
	cp VERSION $(DESTDIR)
	cp dtds/decls/docbook.dcl $(DESTDIR)/dtds/decls
	cp lib/dblib.dsl $(DESTDIR)/lib
	cp common/*.dsl $(DESTDIR)/common
	cp common/*.ent $(DESTDIR)/common
	cp html/*.dsl $(DESTDIR)/html
	cp lib/*.dsl $(DESTDIR)/lib
	cp print/*.dsl $(DESTDIR)/print
	cp images/*.gif $(DESTDIR)/images
