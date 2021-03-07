# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools desktop git-r3

DESCRIPTION="Displays information about users currently logged on in real time"
HOMEPAGE="http://wizard.ae.krakow.pl/~mike/ https://github.com/mtsuszycki/whowatch/"
EGIT_REPO_URI="https://github.com/mtsuszycki/${PN}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""

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
	dodoc AUTHORS ChangeLog.old NEWS PLUGINS.readme README.md TODO
	domenu ${PN}.desktop
}
