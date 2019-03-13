# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit desktop vcs-clean

DESCRIPTION="Swap and match 3 or more jewels in a line in order to score points"
HOMEPAGE="http://www.linuxmotors.com/gljewel/"
SRC_URI="http://www.linuxmotors.com/gljewel/downloads/SDL_jewels-${PV}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="test"

RDEPEND="
	media-libs/libsdl[opengl,video]
	virtual/opengl
"
DEPEND="${RDEPEND}"

S="${WORKDIR}/SDL_jewels-${PV}"

src_prepare() {
	default
	eapply "${FILESDIR}/${P}-Makefile.patch"

	# fix the data dir locations as it looks to be intended to run from src dir
	sed -i -e "s|\"data\"|\"/usr/share/${PN}\"|" sound.c || die
	sed -i -e "s|data/bigfont.ppm|/usr/share/${PN}/bigfont.ppm|" gljewel.c || die
	ecvs_clean
}

src_install() {
	dobin gljewel

	insinto "/usr/share/${PN}"
	doins -r data/*

	einstalldocs
	make_desktop_entry gljewel SDL_jewels
}
