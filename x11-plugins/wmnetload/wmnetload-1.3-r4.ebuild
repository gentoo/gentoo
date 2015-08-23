# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit autotools eutils

DESCRIPTION="Network interface monitor dockapp"
HOMEPAGE="http://freshmeat.net/projects/wmnetload/"
SRC_URI="ftp://truffula.com/pub/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE=""

DEPEND=">=x11-libs/libdockapp-0.7:="
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}/${PN}-${PVR}-configure.patch"
	sed -e 's#<dockapp.h>#<libdockapp/dockapp.h>#' -i src/*.c || die

	eautoreconf
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc AUTHORS README NEWS
}
