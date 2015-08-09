# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils scons-utils games

DESCRIPTION="a World War II German submarine simulation"
HOMEPAGE="http://dangerdeep.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz
	mirror://sourceforge/${PN}/${PN}-data-${PV}.zip"

LICENSE="GPL-2 CC-BY-NC-ND-2.0"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="cpu_flags_x86_sse debug"

RDEPEND="virtual/opengl
	virtual/glu
	sci-libs/fftw:3.0
	media-libs/libsdl[joystick,opengl,video]
	media-libs/sdl-mixer[vorbis]
	media-libs/sdl-image[jpeg,png]
	media-libs/sdl-net"
DEPEND="${RDEPEND}
	app-arch/unzip"

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-build.patch \
		"${FILESDIR}"/${P}-gcc43.patch \
		"${FILESDIR}"/${P}-gcc47.patch \
		"${FILESDIR}"/${P}-gcc44.patch
	sed -i -e "/console_log.txt/ s:fopen.*:stderr;:" src/system.cpp || die
}

src_compile() {
	local sse=-1

	if use cpu_flags_x86_sse ; then
		use amd64 && sse=3 || sse=1
	fi

	escons \
		usex86sse=${sse} \
		datadir="${GAMES_DATADIR}"/${PN} \
		$(use_scons debug)
}

src_install() {
	dogamesbin build/linux/${PN}

	insinto "${GAMES_DATADIR}"/${PN}
	doins -r ../data/*

	newicon dftd_icon.png ${PN}.png
	make_desktop_entry ${PN} "Danger from the Deep"

	dodoc ChangeLog CREDITS README
	doman doc/man/${PN}.6

	prepgamesdirs
}
