# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit cmake

DESCRIPTION="Linux port of Aliens vs Predator"
HOMEPAGE="http://www.icculus.org/avp/"
SRC_URI="http://www.icculus.org/avp/files/${P}-a1.tar.gz"

LICENSE="AvP"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	media-libs/libsdl[video,joystick,opengl]
	media-libs/openal"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}/${P}_gcc10.patch"
	"${FILESDIR}/${P}_aggressive-loop-optimizations.patch"
)

src_configure() {
	local mycmakeargs=(
		-DSDL_TYPE=SDL	# SDL2 backend is broken
		-DOPENGL_TYPE=OPENGL
	)

	cmake_src_configure
}

src_install() {
	dobin "${BUILD_DIR}/${PN}"
	dodoc README
}

pkg_postinst() {
	elog "Please follow the instructions in /usr/share/doc/${PF}"
	elog "to install the rest of the game."
}
