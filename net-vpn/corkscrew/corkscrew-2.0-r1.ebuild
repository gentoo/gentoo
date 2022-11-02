# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools

DESCRIPTION="a tool for tunneling SSH through HTTP proxies"
HOMEPAGE="https://github.com/patpadgett/corkscrew/"
# This is the old distfile URL; the github site does not have exact matching
# checksum, but the content is otherwise identical.
SRC_URI="http://www.agroman.net/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~ppc ~riscv ~sparc x86"
IUSE=""

DOCS="AUTHORS ChangeLog README TODO"

src_prepare() {
	# Fix \r\n per bug 652342
	eapply "${FILESDIR}/${P}-crlf-with-authfile.patch"

	# Christoph Mende <angelos@gentoo.org (23 Jun 2010)
	# Shipped configure doesn't work with some locales (bug #305771)
	# Shipped missing doesn't work with new configure, so we'll force
	# regeneration
	rm -f install-sh missing mkinstalldirs || die

	# Samuli Suominen <ssuominen@gentoo.org> (24 Jun 2012)
	# AC_HEADER_STDC is called separately and #include <string.h> is
	# without #ifdef in corkscrew.c. Instead of using AC_C_PROTOTYPES,
	# remove the call entirely as unused wrt bug #423193
	sed -i -e 's:AM_C_PROTOTYPES:dnl &:' configure.in || die

	mv configure.{in,ac} || die

	eautoreconf
	default
}
