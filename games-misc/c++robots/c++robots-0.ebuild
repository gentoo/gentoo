# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-misc/c++robots/c++robots-0.ebuild,v 1.10 2014/05/13 06:37:18 tupone Exp $

EAPI=4
inherit eutils games

DESCRIPTION="ongoing 'King of the Hill' (KotH) tournament"
HOMEPAGE="http://www.gamerz.net/c++robots/"
SRC_URI="http://www.gamerz.net/c++robots/c++robots.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="x86 ppc"
IUSE="static"

S=${WORKDIR}/${PN}

src_prepare() {
	epatch "${FILESDIR}/proper-coding.patch"
}

src_compile() {
	local myldflags="${LDFLAGS}"
	use static && myldflags="${myldflags} -static"
	emake CFLAGS="${CFLAGS}" LDFLAGS="${myldflags}"
}

src_install() {
	dogamesbin combat cylon target tracker
	dodoc README
	prepgamesdirs
}
