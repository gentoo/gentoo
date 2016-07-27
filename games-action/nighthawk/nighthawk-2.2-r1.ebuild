# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="A tribute to Paradroid by Andrew Braybrook"
HOMEPAGE="http://night-hawk.sourceforge.net/nighthawk.html"
SRC_URI="ftp://metalab.unc.edu/pub/Linux/games/arcade/${P}-1.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

DEPEND="x11-libs/libXpm"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/nighthawk.patch
	"${FILESDIR}"/${P}-gcc42.patch
)

src_prepare() {
	default

	sed -i -e 's:AC_FD_MSG:6:g' configure || die #218936
	sed -i -e '/LDFLAGS = /d' src/Makefile.in || die
}
