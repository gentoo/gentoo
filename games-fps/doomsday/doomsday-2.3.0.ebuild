# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )

inherit cmake python-any-r1 qmake-utils readme.gentoo-r1

DESCRIPTION="A modern gaming engine for Doom, Heretic, and Hexen"
HOMEPAGE="https://www.dengine.net"
SRC_URI="https://downloads.sourceforge.net/project/deng/Doomsday%20Engine/${PV}/${P}.tar.gz"

LICENSE="GPL-3+ LGPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="demo freedoom fluidsynth openal tools"

RDEPEND="
	dev-qt/qtcore:5=
	dev-qt/qtgui:5=[-gles2-only]
	dev-qt/qtnetwork:5=
	dev-qt/qtopengl:5=
	dev-qt/qtwidgets:5=
	dev-qt/qtx11extras:5=
	media-libs/assimp
	net-misc/curl
	sys-libs/zlib
	fluidsynth? ( media-sound/fluidsynth:= )
	openal? ( media-libs/openal )
	tools? ( sys-libs/ncurses:0= )
"
DEPEND="${RDEPEND}"
BDEPEND="${PYTHON_DEPS}
	virtual/pkgconfig
"
PDEPEND="
	demo? ( games-fps/doom-data )
	freedoom? ( games-fps/freedoom )
"

S="${WORKDIR}/${P}/${PN}"

DOC_CONTENTS="You need to copy Doom, Doom 2, Chex Quest, Heretic, Hexen, HexenDD, or Doom64 wads to a folder of your choice and then tell the game engine where that folder is. This is different to older versions, which had separate launchers for each game and required the files to be in a specific place."

src_prepare() {
	cmake_src_prepare

	# Fix QA warning for "installing to one or more unexpected paths"
	sed -e "10s:/texc:/${PF}:" -i tools/texc/CMakeLists.txt || die
}

src_configure() {
	local mycmakeargs=(
		-DDENG_ASSIMP_EMBEDDED="OFF"
		-DDENG_ENABLE_TOOLS="$(usex tools)"
		-DPYTHON_EXECUTABLE="${PYTHON}"
		-DQMAKE=$(qt5_get_bindir)/qmake
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install

	if use tools; then
		mv -v "${ED}"/usr/bin/md2tool{,.${PN}} || die
	fi

	readme.gentoo_create_doc
}

pkg_postinst() {
	readme.gentoo_print_elog

	if use tools; then
		einfo "In order to prevent a file collision with games-fps/eduke32[tools],"
		einfo "the utility md2tool has been renamed to md2tool.doomsday."
	fi
}
