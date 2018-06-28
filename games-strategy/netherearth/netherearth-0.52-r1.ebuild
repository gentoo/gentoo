# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit desktop

MY_PV="${PV/./}"
DESCRIPTION="A remake of the SPECTRUM game Nether Earth"
HOMEPAGE="http://www.braingames.getput.com/nether/"
SRC_URI="http://www.braingames.getput.com/nether/sources.zip
	http://www.braingames.getput.com/nether/${PN}${MY_PV}.zip"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror bindist"

RDEPEND="
	>=media-libs/libsdl-1.2.6-r3
	>=media-libs/sdl-mixer-1.2.5-r1
	media-libs/freeglut
"
DEPEND="${RDEPEND}
	app-arch/unzip
"

S="${WORKDIR}/sources"

data="../nether earth v${PV}"

src_unpack() {
	unzip -LL "${DISTDIR}/${PN}${MY_PV}.zip" >/dev/null || die
	unzip -LL "${DISTDIR}/sources.zip" >/dev/null || die
}

src_prepare() {
	default

	DATA_DIR=/usr/share/${PN}

	cp "${FILESDIR}/Makefile" . || die

	# Fix compilation errors/warnings
	eapply "${FILESDIR}"/${P}-linux.patch

	eapply "${FILESDIR}"/${P}-freeglut.patch \
		"${FILESDIR}"/${P}-glibc-212.patch \
		"${FILESDIR}"/${P}-ldflags.patch

	# Modify dirs and some fopen() permissions
	eapply "${FILESDIR}/${P}-gentoo-paths.patch"
	sed -i \
		-e "s:models:${DATA_DIR}/models:" \
		-e "s:textures:${DATA_DIR}/textures:" \
		-e "s:maps/\*:${DATA_DIR}/maps/\*:" \
		-e "s:\./maps:${DATA_DIR}/maps:" \
		mainmenu.cpp || die
	sed -i \
		-e "s:models:${DATA_DIR}/models:g" \
		-e "s:textures:${DATA_DIR}/textures:" \
		-e "s:sound/:${DATA_DIR}/sound/:" \
		nether.cpp || die
	sed -i -e "s:maps:${DATA_DIR}/maps:" \
		main.cpp || die
	sed -i -e "s:textures/:${DATA_DIR}/textures/:" \
		myglutaux.cpp || die

	cd "${data}"
	rm textures/thumbs.db
}

src_install() {
	dobin nether_earth

	cd "${data}"

	# Install all game data
	insinto "${DATA_DIR}"
	doins -r maps models sound textures

	dodoc readme.txt

	newicon textures/nuclear.bmp ${PN}.bmp
	make_desktop_entry nether_earth "Nether Earth" /usr/share/pixmaps/${PN}.bmp
}
