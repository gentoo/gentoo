# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils desktop gnome2-utils

DESCRIPTION="Hardcore 3D space scroll-shooter with spaceship upgrade possibilities"
HOMEPAGE="https://viewizard.com"
SRC_URI="https://github.com/viewizard/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3 GPL-3+ CC-BY-SA-3.0 UbuntuFontLicense-1.0 OFL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	media-libs/freealut
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
	local mycmakeargs=("-DDATADIR=/usr/share/${PN}")

	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile

	"${CMAKE_BUILD_DIR}"/AstroMenace --pack \
		--rawdata="${S}"/RAW_VFS_DATA \
		--dir=$(dirname "${CMAKE_BUILD_DIR}") || die
}

src_install() {
	newbin "${CMAKE_BUILD_DIR}"/AstroMenace "${PN}"

	insinto /usr/share/${PN}
	doins ../*.vfs

	newicon -s 128 astromenace_128.png ${PN}.png
	newicon -s 64 astromenace_64.png ${PN}.png

	dodoc ChangeLog.txt ReadMe.txt

	make_desktop_entry "${PN}" AstroMenace
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
