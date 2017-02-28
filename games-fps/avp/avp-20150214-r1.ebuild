# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit eutils cmake-utils

DESCRIPTION="Linux port of Aliens vs Predator"
HOMEPAGE="http://www.icculus.org/avp/"
SRC_URI="http://www.icculus.org/avp/files/${P}.tar.gz"

LICENSE="AvP"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	media-libs/libsdl[video,joystick,opengl]
	media-libs/openal"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

CMAKE_BUILD_TYPE=Release

src_configure() {
	local mycmakeargs=(
		"-DCMAKE_VERBOSE_MAKEFILE=TRUE"
		-DSDL_TYPE=SDL
		-DOPENGL_TYPE=OPENGL
	)

	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
}

src_install() {
	dobin "${BUILD_DIR}/${PN}"
	dodoc README
}

pkg_postinst() {
	elog "Please follow the instructions in /usr/share/doc/${PF}"
	elog "to install the rest of the game."
}
