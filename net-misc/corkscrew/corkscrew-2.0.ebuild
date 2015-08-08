# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
inherit autotools

DESCRIPTION="a tool for tunneling SSH through HTTP proxies"
HOMEPAGE="http://www.agroman.net/corkscrew/"
SRC_URI="http://www.agroman.net/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~ppc ~sparc x86"
IUSE=""

DOCS="AUTHORS ChangeLog README TODO"

src_prepare() {
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

	eautoreconf
}
