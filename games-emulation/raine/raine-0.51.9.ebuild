# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit flag-o-matic eutils games

DESCRIPTION="R A I N E  M680x0 Arcade Emulation"
HOMEPAGE="http://rainemu.swishparty.co.uk/"
SRC_URI="http://rainemu.swishparty.co.uk/html/archive/raines-${PV}.tar.bz2"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="x86"
IUSE=""

RDEPEND="dev-cpp/muParser
	media-libs/libsdl[sound,joystick,video]
	sys-libs/zlib
	media-libs/sdl-image[png]
	media-libs/sdl-ttf"
DEPEND="${RDEPEND}
	dev-lang/nasm
	app-arch/unzip"

src_prepare() {
	echo > detect-cpu
	echo > cpuinfo
	sed -i \
		-e "/^NEO/s:^:#:" \
		-e "s:nasmw:nasm:" \
		-e "/bindir/s:=.*:=\$(DESTDIR)${GAMES_BINDIR}:" \
		-e "/sharedir =/s:=.*:=\$(DESTDIR)${GAMES_DATADIR}:" \
		-e "/mandir/s:=.*:=\$(DESTDIR)/usr/share/man/man6:" \
		makefile || die
	epatch "${FILESDIR}"/${P}-ldflags.patch \
		"${FILESDIR}"/${P}-underlink.patch \
		"${FILESDIR}"/${P}-libpng15.patch
	has_version '>=sys-libs/zlib-1.2.5.1-r1' && \
		sed -i -e '1i#define OF(x) x' source/mini-unzip/ioapi.h
	append-ldflags -Wl,-z,noexecstack
}

src_compile() {
	local myopts

	emake \
		_MARCH="${CFLAGS}" \
		VERBOSE=1 \
		${myopts}
}

src_install() {
	default
	keepdir "${GAMES_DATADIR}"/${PN}/{roms,artwork,emudx,scripts/raine}
	dodoc docs/readme.txt
	prepgamesdirs
}
