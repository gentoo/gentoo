# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-fps/glxquake-bin/glxquake-bin-0-r2.ebuild,v 1.4 2015/06/14 19:43:34 ulm Exp $

EAPI=5
inherit games

DESCRIPTION="a binary that works with every 3D-graphics-card that supports the glx X-extension"
HOMEPAGE="http://mfcn.ilo.de/glxquake/"
SRC_URI="http://www.wh-hms.uni-ulm.de/~mfcn/shared/glxquake/glxquake.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-* amd64 x86"
RESTRICT="strip"
IUSE=""

RDEPEND="sys-libs/glibc
	amd64? ( sys-libs/glibc[multilib] )
	virtual/opengl[abi_x86_32(-)]
	x11-libs/libX11[abi_x86_32(-)]
	x11-libs/libXext[abi_x86_32(-)]
	x11-libs/libXxf86vm[abi_x86_32(-)]
	x11-libs/libXxf86dga[abi_x86_32(-)]"

S=${WORKDIR}/glxquake

QA_PREBUILT="${GAMES_BINDIR:1}/glquake"

src_install() {
	dogamesbin glquake
	dodoc README
	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst
	elog "To play with it, create a subdirectory called id1"
	elog "Copy the pak0.pak, and eventually pak1.pak into this subdirectory"
	elog "You can eventually get pak0.pak emerging games-fps/quake1-demodata"
	elog "The file pak0.pak will be on the ${GAMES_DATADIR}/quake1/demo/"
	elog "You can now run glxquake by executing glquake"
}
