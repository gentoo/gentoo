# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit epatch desktop versionator

MY_PV="$(delete_all_version_separators)"
MY_P="stransball2-v${MY_PV}"
FILE="${MY_P}-linux"

DESCRIPTION="Thrust clone"
HOMEPAGE="http://www.braingames.getput.com/stransball2/"
SRC_URI="http://braingames.bugreport.nl/stransball2/${FILE}.zip
	mirror://debian/pool/main/s/${PN}/${PN}_${PV}-8.debian.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	media-libs/libsdl[sound,video]
	media-libs/sdl-image
	media-libs/sdl-mixer
	media-libs/sdl-sound
	media-libs/sge
"
DEPEND="${RDEPEND}
	app-arch/unzip
"

S="${WORKDIR}/${P}/sources"

src_unpack() {
	unpack ${A}
	mv -f "${FILE}" ${P}
}

src_prepare() {
	default
	sed -i \
		-e "s:/usr/share/games:/usr/share:" \
		"${WORKDIR}"/debian/patches/0001-Fix-unix-paths-and-Makefile.patch || die

	epatch "${WORKDIR}"/debian/patches/*.patch

	sed -i \
		-e "s: -I/usr/local/include/SDL::" \
		-e "s:-g3 -O3:\$(CXXFLAGS):" \
		-e "s:c++:\$(CXX):" \
		Makefile || die "sed Makefile failed"
}

src_install() {
	cd ..
	dobin ${PN}

	doicon ../debian/${PN}.png
	make_desktop_entry ${PN} "Super Transball 2"
	dodoc readme.txt
	doman ../debian/supertransball2.6

	insinto "/usr/share/${PN}"
	doins -r demos graphics maps sound
}
