# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop

DESCRIPTION="Tetanus On Drugs simulates playing Tetris under the influence of drugs"
HOMEPAGE="http://www.pineight.com/tod/"
SRC_URI="http://www.pineight.com/pc/win${PN}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="media-libs/allegro:0[X]"
DEPEND="${RDEPEND}
	app-arch/unzip"

S="${WORKDIR}"

src_prepare() {
	default
	eapply "${FILESDIR}"/${P}-makefile.patch
	eapply "${FILESDIR}"/${P}-allegro.patch
	sed -i \
		-e "s:idltd\.dat:/usr/share/${PN}/idltd.dat:" \
		rec.c || die
}

src_install() {
	newbin tod-debug.exe tod
	insinto /usr/share/${PN}
	doins idltd.dat
	dodoc readme.txt
	make_desktop_entry ${PN} "Tetanus On Drugs"
}
