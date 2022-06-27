# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CHECKREQS_DISK_BUILD="3497M"
inherit desktop check-reqs unpacker wrapper xdg

DESCRIPTION="Sci-fi themed action RPG where you fight through a stunning futuristic city"
HOMEPAGE="https://supergiantgames.com/games/transistor/"
SRC_URI="${PN}_${PV//./_}.sh"
S="${WORKDIR}/data/noarch"

LICENSE="GOG-EULA"
SLOT="0"
# The game /should/ work on x86, but it always crashes with an error about
# libBink.so for some reason.
KEYWORDS="-* ~amd64"
RESTRICT="bindist fetch splitdebug"

DIR="/opt/${PN}"
QA_PREBUILT="${DIR#/}/*"

# This only seems to directly need SDL2. It also depends on Lua 5.2, but we no
# longer package that, and newer versions do not work.
RDEPEND="media-libs/libsdl2[joystick,opengl,sound,video]"
BDEPEND="app-arch/unzip"

pkg_nofetch() {
	einfo "Please buy and download ${SRC_URI} from:"
	einfo "  https://www.gog.com/en/game/${PN}"
	einfo "and move it to your distfiles directory."
}

src_unpack() {
	unpack_zip ${A}
}

src_prepare() {
	default
	rm -v game/lib*/libSDL2-2.0.so.0 || die
}

src_install() {
	local \
		arch=$(usex amd64 x86_64 x86) \
		libdir=lib$(usex amd64 64 "")

	insinto "${DIR}"
	doins -r game/{*.bmp,*.cfg,*.dll*,*.xml,*config,Transistor.exe,steam_appid.txt,Content/}

	exeinto "${DIR}"
	doexe game/Transistor.bin.${arch}

	exeinto "${DIR}"/${libdir}
	doexe game/${libdir}/*.so*

	dodoc game/Linux.README

	newicon -s 256 support/icon.png ${PN}.png
	make_wrapper ${PN} ./Transistor.bin.${arch} "${DIR}"
	make_desktop_entry ${PN} Transistor
}
