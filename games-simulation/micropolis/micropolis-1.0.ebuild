# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils games

DESCRIPTION="Free version of the well-known city building simulation"
HOMEPAGE="http://www.donhopkins.com/home/micropolis/"
SRC_URI="http://www.donhopkins.com/home/micropolis/${PN}-activity-source.tgz
	http://rmdir.de/~michael/${PN}_git.patch"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="x11-libs/libX11
	x11-libs/libXpm
	media-libs/libsdl
	media-libs/sdl-mixer"
DEPEND="${RDEPEND}
	sys-devel/bison"

S=${WORKDIR}/${PN}-activity/

src_unpack() {
	unpack ${PN}-activity-source.tgz
}

src_prepare() {
	epatch "${DISTDIR}"/${PN}_git.patch
	sed -i -e "s:-O3:${CFLAGS}:" \
		src/tclx/config.mk src/{sim,tcl,tk}/makefile || die
	sed -i -e "s:XLDFLAGS=:&${LDFLAGS}:" \
		src/tclx/config.mk || die
}

src_compile() {
	emake -C src LDFLAGS="${LDFLAGS}"
}

src_install() {
	local dir=${GAMES_DATADIR}/${PN}

	exeinto "${dir}/res"
	doexe src/sim/sim
	insinto "${dir}"
	doins -r activity cities images manual res

	games_make_wrapper micropolis res/sim "${dir}"
	doicon Micropolis.png
	make_desktop_entry micropolis "Micropolis" Micropolis

	prepgamesdirs
}
