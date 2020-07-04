# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit desktop

DESCRIPTION="A X11 sfcave clone"
HOMEPAGE="http://xsfcave.idios.org"
SRC_URI="mirror://sourceforge/scrap/${P}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="x11-libs/libXext
	x11-libs/libSM"
RDEPEND="${DEPEND}"

src_install() {
	default
	make_desktop_entry "${PN}"
}
