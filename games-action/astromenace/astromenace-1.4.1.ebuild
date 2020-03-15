# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils desktop xdg-utils

DESCRIPTION="Hardcore 3D space scroll-shooter with spaceship upgrade possibilities"
HOMEPAGE="https://viewizard.com"
SRC_URI="https://github.com/viewizard/astromenace/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3 GPL-3+ CC-BY-SA-4.0 OFL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="media-libs/freealut
	media-libs/freetype:2
	media-libs/libogg
	media-libs/libsdl[joystick,video,X]
	media-libs/libvorbis
	media-libs/openal
	virtual/glu
	virtual/opengl
	x11-libs/libXinerama"
RDEPEND=${DEPEND}

src_prepare() {
	cmake-utils_src_prepare

	# no messing with CXXFLAGS please.
	sed -i -e '/-Os/d' CMakeLists.txt || die
}

src_configure() {
	local mycmakeargs=( -DDATADIR="${EPREFIX}/usr/share/${PN}" )

	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
}

src_install() {
	dobin "${BUILD_DIR}"/astromenace

	insinto /usr/share/${PN}
	doins "${BUILD_DIR}"/gamedata.vfs

	newicon -s 128 share/astromenace_128.png ${PN}.png
	newicon -s 64 share/astromenace_64.png ${PN}.png

	dodoc CHANGELOG.md README.md

	make_desktop_entry "${PN}" AstroMenace
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
