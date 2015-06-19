# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-misc/wumpus/wumpus-1.4.ebuild,v 1.17 2015/02/06 13:41:04 ago Exp $

EAPI=5
inherit toolchain-funcs games

DESCRIPTION="Classic Hunt the Wumpus Adventure Game"
HOMEPAGE="http://cvsweb.netbsd.org/bsdweb.cgi/src/games/wump/"
SRC_URI="ftp://ftp.netbsd.org/pub/NetBSD/NetBSD-release-1-6/src/games/wump/wump.c
	ftp://ftp.netbsd.org/pub/NetBSD/NetBSD-release-1-6/src/games/wump/wump.6
	ftp://ftp.netbsd.org/pub/NetBSD/NetBSD-release-1-6/src/games/wump/wump.info"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

DEPEND="sys-apps/less"
RDEPEND=${DEPEND}

S=${WORKDIR}

src_unpack() {
	local i

	for i in wump.{info,c,6} ; do
		cp "${DISTDIR}"/${i} "${S}/"
	done
}

src_compile() {
	touch pathnames.h
	[ -z "${PAGER}" ] && PAGER=/usr/bin/less
	$(tc-getCC) ${LDFLAGS} -Dlint -D_PATH_PAGER=\"${PAGER}\" \
		-D_PATH_WUMPINFO=\""${GAMES_DATADIR}"/${PN}/wump.info\" ${CFLAGS} \
		-o wump wump.c || die
}

src_install() {
	dogamesbin wump
	doman wump.6
	insinto "${GAMES_DATADIR}/${PN}"
	doins wump.info
	prepgamesdirs
}
