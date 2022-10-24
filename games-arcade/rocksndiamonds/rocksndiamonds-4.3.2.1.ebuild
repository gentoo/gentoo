# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit desktop flag-o-matic unpacker

DESCRIPTION="A Boulderdash clone"
HOMEPAGE="https://www.artsoft.org/rocksndiamonds/"
# rocksndiamonds-distributable-music.tar.bz2 from Fedora
SRC_URI="https://www.artsoft.org/RELEASES/unix/rocksndiamonds/${P}.tar.gz
	https://dev.gentoo.org/~pacho/${PN}/rocksndiamonds-distributable-music.tar.bz2
	https://upload.wikimedia.org/wikipedia/commons/e/e2/Rocks%27n%27Diamonds.png -> ${PN}.png
	https://www.artsoft.org/RELEASES/rocksndiamonds/levels/Andreas_Buschbeck-1.0.0.zip
	https://www.artsoft.org/RELEASES/rocksndiamonds/levels/BD2K3-1.0.0.zip
	https://www.artsoft.org/RELEASES/rocksndiamonds/levels/Boulder_Dash_Dream-1.0.0.zip
	https://www.artsoft.org/RELEASES/rocksndiamonds/levels/Contributions-1.2.0.zip
	https://www.artsoft.org/RELEASES/rocksndiamonds/levels/Emerald_Mine_Club-3.1.3.7z
	https://www.artsoft.org/RELEASES/rocksndiamonds/levels/RS_MIX_01-needs_rnd_jue.zip
	https://www.artsoft.org/RELEASES/rocksndiamonds/levels/RS_MIX_01-standalone.zip
	https://www.artsoft.org/RELEASES/rocksndiamonds/levels/Snake_Bite-1.0.0.zip
	https://www.artsoft.org/RELEASES/rocksndiamonds/levels/Sokoban-1.0.0.zip
	https://www.artsoft.org/RELEASES/rocksndiamonds/levels/Supaplex-2.0.0.zip
	https://www.artsoft.org/RELEASES/rocksndiamonds/levels/Zelda-1.0.0.zip
	https://www.artsoft.org/RELEASES/rocksndiamonds/levels/ZeldaII-1.0.0.zip
	https://www.artsoft.org/RELEASES/rocksndiamonds/levels/rnd-contrib-1.0.0.tar.gz
	https://www.artsoft.org/RELEASES/unix/rocksndiamonds/levels/rockslevels-dx-1.0.tar.gz
	https://www.artsoft.org/RELEASES/unix/rocksndiamonds/levels/rockslevels-emc-1.0.tar.gz
	https://www.artsoft.org/RELEASES/unix/rocksndiamonds/levels/rockslevels-sp-1.0.tar.gz
	mirror://gentoo/rnd_jue-v8.tar.bz2
	https://www.artsoft.org/rocksndiamonds/levels/jamiecullen/zips/wg_v1-0.zip
	https://www.artsoft.org/rocksndiamonds/levels/jamiecullen/zips/wf_v1-3.zip
	https://www.artsoft.org/rocksndiamonds/levels/jamiecullen/zips/ese_v1-1.zip
	https://www.artsoft.org/rocksndiamonds/levels/jamiecullen/zips/es_b_v1-2.zip
	https://www.artsoft.org/rocksndiamonds/levels/jamiecullen/zips/ww_v1-0.zip
"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	media-libs/libmodplug
	media-libs/libsdl2[joystick,video]
	media-libs/sdl2-mixer[mod,mp3,timidity]
	media-libs/sdl2-net
	media-libs/sdl2-image[gif]
	media-libs/smpeg
"
DEPEND="${RDEPEND}"
BDEPEND="$(unpacker_src_uri_depends)"

PATCHES=(
	# From Fedora:
	"${FILESDIR}"/${PN}-4.3.2.0-music-info-url.patch
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
	unpacker \
		Andreas_Buschbeck-1.0.0.zip \
		rnd_jue-v8.tar.bz2 \
		BD2K3-1.0.0.zip \
		rnd-contrib-1.0.0.tar.gz \
		Snake_Bite-1.0.0.zip \
		Contributions-1.2.0.zip \
		Boulder_Dash_Dream-1.0.0.zip \
		Sokoban-1.0.0.zip \
		Zelda-1.0.0.zip \
		ZeldaII-1.0.0.zip \
		Emerald_Mine_Club-3.1.3.7z \
		RS_MIX_01-needs_rnd_jue.zip \
		RS_MIX_01-standalone.zip \
		Supaplex-2.0.0.zip \
		wg_v1-0.zip \
		wf_v1-3.zip \
		ese_v1-1.zip \
		es_b_v1-2.zip \
		ww_v1-0.zip
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

	local makeopts="BASE_PATH=/usr/share/${PN} RO_GAME_DIR=/usr/share/${PN} RW_GAME_DIR=/usr/share/${PN} EXTRA_CFLAGS=-DUSE_USERDATADIR_FOR_COMMONDATA"
	emake -j1 clean
	emake ${makeopts} OPTIONS="${CFLAGS}"
}

src_install() {
	dobin rocksndiamonds
	insinto "/usr/share/${PN}"
	doins -r docs graphics levels music sounds

	einstalldocs
	doicon "${DISTDIR}/${PN}.png"
	make_desktop_entry ${PN} "Rocks 'N' Diamonds" ${PN}
}
