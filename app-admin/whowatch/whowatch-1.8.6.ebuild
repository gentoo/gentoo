# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools

DESCRIPTION="Displays information about users currently logged on in real time"
HOMEPAGE="http://wizard.ae.krakow.pl/~mike/ https://github.com/mtsuszycki/whowatch/"
SRC_URI="https://github.com/mtsuszycki/${PN}/releases/download/${P}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~hppa ~mips ppc x86"

RDEPEND="
	sys-libs/ncurses:0=
"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
"
PATCHES=(
	"${FILESDIR}"/${PN}-1.8.4-tinfo.patch
)

src_prepare() {
	default
	eautoreconf
}

src_install() {
	dobin src/${PN}
	doman ${PN}.1
	dodoc AUTHORS ChangeLog README TODO
}
