# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/g-wrap/g-wrap-1.9.14.ebuild,v 1.3 2012/08/27 17:57:52 armin76 Exp $

EAPI=4

inherit autotools-utils

DESCRIPTION="A tool for exporting C libraries into Scheme"
HOMEPAGE="http://www.nongnu.org/g-wrap/"
SRC_URI="http://download.savannah.gnu.org/releases/g-wrap/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~hppa ~ppc ~ppc64 ~x86"
IUSE="static-libs"

# guile-lib for srfi-34, srfi-35
RDEPEND="
	dev-libs/glib:2
	dev-scheme/guile-lib
	dev-scheme/guile[deprecated]
	virtual/libffi"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	dev-util/indent"

MAKEOPTS+=" -j1"

src_configure() {
	local myeconfargs=( --disable-Werror --with-glib )
	autotools-utils_src_configure
}
