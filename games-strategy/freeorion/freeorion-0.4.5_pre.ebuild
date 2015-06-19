# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-strategy/freeorion/freeorion-0.4.5_pre.ebuild,v 1.3 2015/05/26 07:49:18 tomka Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )
inherit cmake-utils python-any-r1 games

DESCRIPTION="A free turn-based space empire and galactic conquest game"
HOMEPAGE="http://www.freeorion.org"
SRC_URI="http://dev.gentoo.org/~tomka/files/${P}.tar.bz2"

LICENSE="GPL-2 LGPL-2.1 CC-BY-SA-3.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="cg"

# Needs it's own version of GG(dev-games/gigi) which it ships.
# The split version dev-games/gigi is not used anymore as of 0.4.3
RDEPEND="
	!dev-games/gigi
	media-libs/libsdl2
	>=dev-libs/boost-1.47[python]
	media-libs/freealut
	media-libs/glew
	media-libs/libogg
	media-libs/libsdl[X,opengl,video]
	media-libs/libvorbis
	media-libs/openal
	sci-physics/bullet
	sys-libs/zlib
	virtual/opengl"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	virtual/pkgconfig"

CMAKE_USE_DIR="${S}"
CMAKE_VERBOSE="1"

pkg_setup() {
	# build system is using FindPythonLibs.cmake which needs python:2
	python-any-r1_pkg_setup
	games_pkg_setup
}

src_prepare() {
	# parse subdir sets -O3
	sed -e "s:-O3::" -i parse/CMakeLists.txt

	# set revision for display in game -- update on bump!
	sed -i -e 's/???/8051/' CMakeLists.txt
}

src_configure() {
	local mycmakeargs=(
		-DRELEASE_COMPILE_FLAGS=""
		-DCMAKE_SKIP_RPATH=ON
		)

	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
}

src_install() {
	# data files
	rm "${CMAKE_USE_DIR}"/default/COPYING || die
	insinto "${GAMES_DATADIR}"/${PN}
	doins -r "${CMAKE_USE_DIR}"/default || die

	# bin
	dogamesbin "${CMAKE_BUILD_DIR}"/${PN}{ca,d} || die
	newgamesbin "${CMAKE_BUILD_DIR}"/${PN} ${PN}.bin || die
	games_make_wrapper ${PN} \
		"${GAMES_BINDIR}/${PN}.bin --resource-dir ${GAMES_DATADIR}/${PN}/default" \
		"${GAMES_DATADIR}/${PN}"

	# lib
	dogameslib "${CMAKE_BUILD_DIR}"/libfreeorion{common,parse}.so || die
	dogameslib "${CMAKE_BUILD_DIR}"/libGiGi*.so || die

	# other
	dodoc "${CMAKE_USE_DIR}"/changelog.txt || die
	newicon "${CMAKE_USE_DIR}"/default/data/art/icons/FO_Icon_32x32.png \
		${PN}.png || die
	make_desktop_entry ${PN} ${PN} ${PN}

	# permissions
	prepgamesdirs
}
