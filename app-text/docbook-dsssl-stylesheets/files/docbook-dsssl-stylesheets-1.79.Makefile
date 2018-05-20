BINDIR = /usr/bin
DESTDIR = /usr/share/sgml/docbook/dsssl-stylesheets-1.79

INSTALL = install -c -m 0644

all: install

install:
	mkdir -p $(BINDIR)
	mkdir -p $(DESTDIR){/,/dtds/decls,/lib,/common,/html,/print,/images}
	install -c -m 0755 bin/collateindex.pl $(BINDIR)
	$(INSTALL) catalog $(DESTDIR)
	$(INSTALL) VERSION $(DESTDIR)
	$(INSTALL) dtds/decls/docbook.dcl $(DESTDIR)/dtds/decls
	$(INSTALL) lib/dblib.dsl $(DESTDIR)/lib
	$(INSTALL) common/*.dsl $(DESTDIR)/common
	$(INSTALL) common/*.ent $(DESTDIR)/common
	$(INSTALL) html/*.dsl $(DESTDIR)/html
	$(INSTALL) lib/*.dsl $(DESTDIR)/lib
	$(INSTALL) print/*.dsl $(DESTDIR)/print
	$(INSTALL) images/*.gif $(DESTDIR)/images
