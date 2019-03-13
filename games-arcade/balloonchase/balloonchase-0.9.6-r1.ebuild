# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit desktop toolchain-funcs

DESCRIPTION="Fly a hot air balloon and try to blow the other player out of the screen"
HOMEPAGE="http://makegho.mbnet.fi/c/bchase/"
SRC_URI="http://makegho.mbnet.fi/c/bchase/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="media-libs/libsdl[video]"
RDEPEND="${DEPEND}"

src_prepare() {
	default
	eapply "${FILESDIR}"/${PV}-gentoo.patch
	sed -i "s:g++:$(tc-getCXX):" Makefile || die
	sed -i \
		-e "s:GENTOODIR:/usr/share/${PN}:" src/main.c || die
}

src_install() {
	dobin ${PN}
	insinto /usr/share/${PN}
	doins -r images
	newicon images/kp2b.bmp ${PN}.bmp
	make_desktop_entry ${PN} "Balloon Chase" /usr/share/pixmaps/${PN}.bmp
	einstalldocs
}
