# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-fps/avp/avp-20150214.ebuild,v 1.3 2015/03/27 10:16:59 ago Exp $

EAPI=5
inherit eutils cmake-utils games

DESCRIPTION="Linux port of Aliens vs Predator"
HOMEPAGE="http://www.icculus.org/avp/"
SRC_URI="http://www.icculus.org/avp/files/${P}.tar.gz"

LICENSE="AvP"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="media-libs/openal
	media-libs/libsdl[video,joystick,opengl]"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

CMAKE_BUILD_TYPE=Release

src_configure() {
	local mycmakeargs=(
		"-DCMAKE_VERBOSE_MAKEFILE=TRUE"
		-DSDL_TYPE=SDL
		-DOPENGL_TYPE=OPENGL
		"-DINSTALL_PREFIX=${GAMES_PREFIX}"
		"-DINSTALL_DATADIR=${GAMES_DATADIR}/${PN}"
		"-DINSTALL_BINDIR=${GAMES_BINDIR}"
	)

	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
}

src_install() {
	dogamesbin "${BUILD_DIR}/${PN}"
	dodoc README
	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst
	elog "Please follow the instructions in /usr/share/doc/${PF}"
	elog "to install the rest of the game."
}
