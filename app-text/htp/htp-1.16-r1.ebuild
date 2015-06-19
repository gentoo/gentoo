# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/htp/htp-1.16-r1.ebuild,v 1.1 2014/08/18 20:47:27 creffett Exp $

EAPI=5

inherit eutils toolchain-funcs

DESCRIPTION="An HTML preprocessor"
HOMEPAGE="http://htp.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="Clarified-Artistic"
SLOT="0"
KEYWORDS="~alpha ~ppc ~sparc ~x86"
IUSE=""

# HTP does not use autoconf, have to set options defined in Makefile.config

src_prepare() {
	epatch "${FILESDIR}"/strip.patch #240110
	# let src_test take care of testing
	sed -i -e '/SUBDIRS /s:tests::' Makefile || die
	# don't install doc files with +x perms
	sed -i -e '$aINSTALL += -m644' homepage/ref/{*/,}Makefile || die
	# make src_test abort on failure
	sed -i -e '/DIFF.*FAILED/s/echo/exit 1; :/' tests/Makefile || die
	# the png file in this test isn't fetchable
	sed -i -e 's: width="630" height="331"::' tests/png.html.exp || die
}

src_compile() {
	emake \
		CCOPT="-c ${CFLAGS} ${CPPFLAGS} -DHAVE_SNPRINTF -DHAVE_VASPRINTF -DHAVE_ASPRINTF" \
		CC="$(tc-getCC)" \
		LINK='$(CC) $(LDFLAGS)' \
		|| die
}

src_test() {
	emake -C tests || die
}

src_install() {
	emake \
		DESTDIR="${D}" \
		prefix='$(DESTDIR)/usr' \
		pkgdocdir='$(DESTDIR)/usr/share/doc/${PF}/html' \
		install || die
}
