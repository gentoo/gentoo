# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-arcade/xboing/xboing-2.4-r2.ebuild,v 1.3 2013/02/02 19:19:26 dilfridge Exp $

EAPI=5

inherit eutils games

DESCRIPTION="blockout type game where you bounce a proton ball trying to destroy blocks"
HOMEPAGE="http://www.techrescue.org/xboing/"
SRC_URI="http://www.techrescue.org/xboing/${PN}${PV}.tar.gz
	mirror://gentoo/xboing-${PV}-debian.patch.bz2"

LICENSE="xboing"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE=""

RDEPEND="x11-libs/libXpm"
DEPEND="${RDEPEND}
	app-text/rman
	x11-misc/gccmakedep
	x11-misc/imake"

S=${WORKDIR}/${PN}

src_prepare() {
	epatch "${WORKDIR}"/xboing-${PV}-debian.patch
	epatch "${FILESDIR}"/xboing-${PV}-buffer.patch
	epatch "${FILESDIR}"/xboing-${PV}-sleep.patch
	sed -i '/^#include/s:xpm\.h:X11/xpm.h:' *.c
}

src_configure() {
	xmkmf -a || die
	sed -i \
		-e "s:GENTOO_VER:${PF/${PN}-/}:" \
		Imakefile
}

src_compile() {
	emake \
		CXXOPTIONS="${CXXFLAGS}" \
		CDEBUGFLAGS="${CFLAGS}" \
		LOCAL_LDFLAGS="${LDFLAGS}" \
		XBOING_DIR="${GAMES_DATADIR}/${PN}" \
		|| die
}

src_install() {
	make \
		PREFIX="${D}" \
		LOCAL_LDFLAGS="${LDFLAGS}" \
		XBOING_DIR="${GAMES_DATADIR}/${PN}" \
		install \
		|| die
	newman xboing.man xboing.6
	dodoc README docs/*.doc
	prepgamesdirs
	fperms 660 "${GAMES_STATEDIR}"/xboing.score
}
