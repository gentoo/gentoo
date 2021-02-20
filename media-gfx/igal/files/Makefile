NAME=igal2
PREFIX=/usr/local
BINDIR=$(PREFIX)/bin
DATADIR=$(PREFIX)/share
MANDIR=$(DATADIR)/man/man1
IGALDIR=$(DATADIR)/$(NAME)

OLDLIBDIR=$(PREFIX)/lib/igal

all:

uninstall:
	rm -rf $(DESTDIR)$(IGALDIR)
	rm -f $(DESTDIR)$(BINDIR)/$(NAME)
	rm -f $(DESTDIR)$(BINDIR)/igal
	rm -f $(DESTDIR)$(MANDIR)/$(NAME).1
	rm -f $(DESTDIR)$(BINDIR)/$(NAME).sh

old-clean:
	rm -rf $(DESTDIR)$(OLDLIBDIR)
	rm -f $(DESTDIR)$(BINDIR)/igal
	rm -f $(DESTDIR)$(MANDIR)/igal.1

install:
	install -d $(DESTDIR)$(BINDIR)
	install -m 0755 $(NAME) $(DESTDIR)$(BINDIR)
	ln -si $(NAME) $(DESTDIR)$(BINDIR)/igal
	install -m 0755 utilities/$(NAME).sh $(DESTDIR)$(BINDIR)
	install -d $(DESTDIR)$(MANDIR)
	install -m 0644 $(NAME).1 $(DESTDIR)$(MANDIR)
	install -d $(DESTDIR)$(IGALDIR)
	install -m 0644 README ChangeLog COPYING indextemplate2.html slidetemplate2.html tile.png $(NAME).css directoryline2.html $(DESTDIR)$(IGALDIR)
	sed -i 's_/usr/local_$(PREFIX)_' $(DESTDIR)$(BINDIR)/$(NAME) $(DESTDIR)$(BINDIR)/$(NAME).sh $(DESTDIR)$(MANDIR)/$(NAME).1



VERSION=$(shell grep "VERSION" $(NAME) |head -1|cut -d '"' -f 2)

dist:
	git archive --prefix=$(NAME)-$(VERSION)/ HEAD --format=tar.gz -o $(NAME)-$(VERSION).tar.gz
