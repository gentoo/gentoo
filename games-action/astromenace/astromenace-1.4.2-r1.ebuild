# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake desktop xdg

DESCRIPTION="Hardcore 3D space scroll-shooter with spaceship upgrade possibilities"
HOMEPAGE="https://viewizard.com"
SRC_URI="https://github.com/viewizard/astromenace/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3 GPL-3+ CC-BY-SA-4.0 OFL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	media-libs/freealut
	media-libs/freetype:2
	media-libs/libogg
	media-libs/libsdl2[joystick,video]
	media-libs/libvorbis
	media-libs/openal
	virtual/glu
	virtual/opengl
	x11-libs/libXinerama
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-gcc13.patch
	"${FILESDIR}"/${P}-odr.patch
)

src_prepare() {
	cmake_src_prepare

	# no messing with CXXFLAGS please.
	sed -i -e '/-Os/d' CMakeLists.txt || die
}

src_configure() {
	local mycmakeargs=( -DDATADIR="${EPREFIX}/usr/share/${PN}" )

	cmake_src_configure
}

src_install() {
	# As of 1.4.2, the CMake install target is better, but still needs porting
	# to GNUInstallDirs.
	dobin "${BUILD_DIR}"/astromenace

	insinto /usr/share/${PN}
	doins "${BUILD_DIR}"/gamedata.vfs

	newicon -s 128 share/astromenace_128.png ${PN}.png
	newicon -s 64 share/astromenace_64.png ${PN}.png

	einstalldocs

	make_desktop_entry "${PN}" AstroMenace
}
