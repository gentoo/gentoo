# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="An HTML preprocessor"
HOMEPAGE="http://htp.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="Clarified-Artistic"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~sparc ~x86"

RESTRICT="test"

QA_PRESTRIPPED="/usr/bin/htp"

src_compile() {
	emake \
		CCOPT="-c ${CFLAGS} ${CPPFLAGS} -DHAVE_SNPRINTF -DHAVE_VASPRINTF -DHAVE_ASPRINTF" \
		CC="$(tc-getCC)" \
		LINK='$(CC) $(LDFLAGS)'
}

src_install() {
	emake \
		DESTDIR="${D}" \
		prefix='$(DESTDIR)/usr' \
		pkgdocdir='$(DESTDIR)/usr/share/doc/${PF}/html' \
		install
}
