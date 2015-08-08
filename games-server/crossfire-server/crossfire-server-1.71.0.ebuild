# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils games

MY_P="${P/-server/}"
DESCRIPTION="server for the crossfire clients"
HOMEPAGE="http://crossfire.real-time.com/"
SRC_URI="mirror://sourceforge/crossfire/${PN}/${PV}/${MY_P}.tar.bz2
	mirror://sourceforge/crossfire/${PN}/${PV}/${MY_P}.maps.tar.bz2
	mirror://sourceforge/crossfire/${PN}/${PV}/${MY_P}.arch.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="X"
RESTRICT="test"

DEPEND="net-misc/curl
	X? (
		x11-libs/libXaw
		media-libs/libpng:0
	)"
RDEPEND=${DEPEND}

src_prepare() {
	rm -f "${WORKDIR}"/maps/Info/combine.pl # bug #236205
	ln -s "${WORKDIR}/arch" "${S}/lib" || die
}

src_configure() {
	egamesconf --disable-static
}

src_compile() {
	# work around the collect.pl locking
	emake -j1 -C lib
	emake
}

src_install() {
	default
	keepdir "${GAMES_STATEDIR}"/crossfire/{account,datafiles,maps,players,template-maps,unique-items}
	insinto "${GAMES_DATADIR}/crossfire"
	doins -r "${WORKDIR}/maps"
	prune_libtool_files --modules
	prepgamesdirs
}
