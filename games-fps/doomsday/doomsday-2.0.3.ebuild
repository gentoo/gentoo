# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 )

inherit python-r1 readme.gentoo-r1 cmake-utils

DESCRIPTION="A modern gaming engine for Doom, Heretic, and Hexen"
HOMEPAGE="http://www.dengine.net"
SRC_URI="https://downloads.sourceforge.net/project/deng/Doomsday%20Engine/${PV}/${P}.tar.gz"

LICENSE="GPL-3+ LGPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="fluidsynth openal +doom demo freedoom heretic hexen tools fmod"
REQUIRED_USE="${PYTHON_REQUIRED_USE}
	demo? ( doom ) freedoom? ( doom )
"

RDEPEND="
	dev-qt/qtnetwork:5
	dev-qt/qtopengl:5
	dev-qt/qtwidgets:5
	dev-qt/qtx11extras:5
	dev-qt/qtgui:5[-gles2]
	dev-qt/qtcore:5
	net-misc/curl
	sys-libs/zlib
	media-libs/assimp
	fmod? ( media-libs/fmod )
	fluidsynth? ( media-sound/fluidsynth )
	openal? ( media-libs/openal )
	tools? ( sys-libs/ncurses:0 )
"
DEPEND="${RDEPEND}
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

internal_src_configure() {
	export QT_SELECT=qt5
	local mycmakeargs=(
		-DPYTHON_EXECUTABLE="${PYTHON}"
		-DDENG_ASSIMP_EMBEDDED=off
	)
	cmake-utils_src_configure
}

src_configure() {
	python_foreach_impl internal_src_configure
}

src_install() {
	cmake-utils_src_install
	readme.gentoo_create_doc
}

pkg_postinst() {
	readme.gentoo_print_elog
}
