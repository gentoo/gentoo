# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="An HTML preprocessor"
HOMEPAGE="http://htp.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="Clarified-Artistic"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~sparc ~x86"

PATCHES=(
	"${FILESDIR}"/${PN}-1.19-no-prestrip.patch
	"${FILESDIR}"/${PN}-1.19-parallel-make.patch
	"${FILESDIR}"/${PN}-1.19-fix-perl-5.26.patch
)

src_compile() {
	# TOOD: Tests are always run by the Makefile right now
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
