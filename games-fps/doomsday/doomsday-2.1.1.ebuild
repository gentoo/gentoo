# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{6,7} )

inherit cmake-utils python-any-r1 readme.gentoo-r1

DESCRIPTION="A modern gaming engine for Doom, Heretic, and Hexen"
HOMEPAGE="https://www.dengine.net"
SRC_URI="https://downloads.sourceforge.net/project/deng/Doomsday%20Engine/${PV}/${P}.tar.gz"
LICENSE="GPL-3+ LGPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="demo fmod freedoom fluidsynth openal tools"

RDEPEND="
	dev-qt/qtcore:5=
	dev-qt/qtgui:5=[-gles2]
	dev-qt/qtnetwork:5=
	dev-qt/qtopengl:5=
	dev-qt/qtwidgets:5=
	dev-qt/qtx11extras:5=
	media-libs/assimp
	net-misc/curl
	sys-libs/zlib
	fmod? ( media-libs/fmod:1 )
	fluidsynth? ( media-sound/fluidsynth:= )
	openal? ( media-libs/openal )
	tools? ( sys-libs/ncurses:0= )
"
DEPEND="
	${RDEPEND}
	${PYTHON_DEPS}
	virtual/pkgconfig
"
PDEPEND="
	demo? ( games-fps/doom-data )
	freedoom? ( games-fps/freedoom )
"

S="${WORKDIR}/${P}/${PN}"

DISABLE_AUTOFORMATTING="yes"

DOC_CONTENTS="
You need to copy Doom, Doom 2, Chex Quest, Heretic, Hexen, HexenDD,
and Doom64 wads to a folder of your choice. Then configure in game
engine where that folder is. This is different than old versions,
which had centralized launchers for each game, and required the
files to be in a specific place
"

src_prepare() {
	default

	# Fix QA warning for "installing to one or more unexpected paths"
	sed -e "10s:/texc:/${PF}:" -i tools/texc/CMakeLists.txt || die
}

src_configure() {
	export QT_SELECT=qt5
	local mycmakeargs=(
		-DDENG_ASSIMP_EMBEDDED="OFF"
		-DDENG_ENABLE_TOOLS="$(usex tools)"
		-DPYTHON_EXECUTABLE="${PYTHON}"
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	if use tools; then
		mv "${ED%/}"/usr/bin/md2tool "${ED%/}"/usr/bin/md2tool.doomsday || die
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
