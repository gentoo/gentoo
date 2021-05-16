# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit desktop flag-o-matic

DESCRIPTION="A Boulderdash clone"
HOMEPAGE="https://www.artsoft.org/rocksndiamonds/"
SRC_URI="https://www.artsoft.org/RELEASES/unix/rocksndiamonds/${P}.tar.gz
	https://www.artsoft.org/RELEASES/rocksndiamonds/levels/Contributions-1.2.0.zip
	https://www.artsoft.org/RELEASES/rocksndiamonds/levels/BD2K3-1.0.0.zip
	https://www.artsoft.org/RELEASES/rocksndiamonds/levels/Boulder_Dash_Dream-1.0.0.zip
	https://www.artsoft.org/RELEASES/rocksndiamonds/levels/rnd-contrib-1.0.0.tar.gz
	https://www.artsoft.org/RELEASES/rocksndiamonds/levels/Snake_Bite-1.0.0.zip
	https://www.artsoft.org/RELEASES/rocksndiamonds/levels/Sokoban-1.0.0.zip
	https://www.artsoft.org/RELEASES/unix/rocksndiamonds/levels/rockslevels-emc-1.0.tar.gz
	https://www.artsoft.org/RELEASES/unix/rocksndiamonds/levels/rockslevels-sp-1.0.tar.gz
	https://www.artsoft.org/RELEASES/unix/rocksndiamonds/levels/rockslevels-dx-1.0.tar.gz
	mirror://gentoo/rnd_jue-v8.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	media-libs/libsdl2[joystick,video]
	media-libs/sdl2-mixer[mod,mp3,timidity]
	media-libs/sdl2-net
	media-libs/sdl2-image[gif]
	media-libs/smpeg
"
DEPEND="${RDEPEND}
	app-arch/unzip
"

PATCHES=(
	# From Fedora:
	"${FILESDIR}"/${PN}-4.1.0.0-YN.patch
	"${FILESDIR}"/${PN}-4.1.0.0-music-info-url.patch
	"${FILESDIR}"/${PN}-4.1.0.0-CVE-2011-4606.patch
)

src_unpack() {
	unpack ${P}.tar.gz
	cd "${S}"
	unpack \
		rockslevels-emc-1.0.tar.gz \
		rockslevels-sp-1.0.tar.gz \
		rockslevels-dx-1.0.tar.gz
	cd levels
	unpack \
		rnd_jue-v8.tar.bz2 \
		BD2K3-1.0.0.zip \
		rnd-contrib-1.0.0.tar.gz \
		Snake_Bite-1.0.0.zip \
		Contributions-1.2.0.zip \
		Boulder_Dash_Dream-1.0.0.zip \
		Sokoban-1.0.0.zip
}

src_prepare() {
	default
	sed -i \
		-e 's:\$(MAKE_CMD):$(MAKE) -C $(SRC_DIR):' \
		-e '/^MAKE/d' \
		-e '/^CC/d' \
		Makefile || die

	sed -i \
		-e '/^LDFLAGS/s/=/+=/' \
		src/Makefile || die
}

src_compile() {
	replace-cpu-flags k6 k6-1 k6-2 i586

	local makeopts="RO_GAME_DIR=/usr/share/${PN} RW_GAME_DIR=/usr/share/${PN}"
	emake -j1 clean
	emake ${makeopts} OPTIONS="${CFLAGS}" sdl2
}

src_install() {
	dobin rocksndiamonds
	insinto "/usr/share/${PN}"
	doins -r docs graphics levels music sounds

	einstalldocs
	newicon graphics/gfx_classic/RocksIcon32x32.png ${PN}.png
	make_desktop_entry rocksndiamonds "Rocks 'N' Diamonds" /usr/share/pixmaps/${PN}.png
}
