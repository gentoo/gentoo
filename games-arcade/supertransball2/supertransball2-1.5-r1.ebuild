# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop

MY_PV="$(ver_rs 1- '')"
MY_P="stransball2-v${MY_PV}"
FILE="${MY_P}-linux"

DESCRIPTION="Thrust clone"
HOMEPAGE="http://www.braingames.getput.com/stransball2/"
SRC_URI="http://braingames.bugreport.nl/stransball2/${FILE}.zip
	mirror://debian/pool/main/s/${PN}/${PN}_${PV}-8.debian.tar.xz"
S="${WORKDIR}/${P}/sources"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="app-arch/unzip"
RDEPEND="
	media-libs/libsdl[sound,video]
	media-libs/sdl-image
	media-libs/sdl-mixer
	media-libs/sdl-sound
	media-libs/sge
"
DEPEND="${RDEPEND}"

src_unpack() {
	unpack ${A}
	mv -f "${FILE}" ${P} || die
}

src_prepare() {
	default

	sed -i \
		-e "s:/usr/share/games:/usr/share:" \
		"${WORKDIR}"/debian/patches/0001-Fix-unix-paths-and-Makefile.patch || die

	eapply -p2 "${WORKDIR}"/debian/patches/*.patch

	sed -i \
		-e "s: -I/usr/local/include/SDL::" \
		-e "s:-g3 -O3:\$(CXXFLAGS):" \
		-e "s:c++:\$(CXX):" \
		Makefile || die "sed Makefile failed"
}

src_install() {
	cd .. || die
	dobin ${PN}

	doicon ../debian/${PN}.png
	make_desktop_entry ${PN} "Super Transball 2"
	dodoc readme.txt
	doman ../debian/supertransball2.6

	insinto "/usr/share/${PN}"
	doins -r demos graphics maps sound
}
