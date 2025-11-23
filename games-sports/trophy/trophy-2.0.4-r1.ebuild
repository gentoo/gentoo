# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit desktop flag-o-matic xdg

DESCRIPTION="2D Racing Game"
HOMEPAGE="https://trophy.sourceforge.io/"
SRC_URI="https://downloads.sourceforge.net/${PN}/${P}.tar.gz
	https://dev.gentoo.org/~pacho/${PN}/${PN}.png"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-games/clanlib:0.8[opengl]"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_configure() {
	append-cxxflags -Wno-template-body #941236
	default
}

src_install(){
	default
	doicon -s 256 "${DISTDIR}/${PN}.png"
}
