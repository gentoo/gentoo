# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-misc/bsod/bsod-0.1.ebuild,v 1.6 2014/10/27 15:46:54 mr_bones_ Exp $

EAPI=5
inherit eutils toolchain-funcs games

DESCRIPTION="This program will let you UNIX user experience the authentic microsoft windows experience"
HOMEPAGE="http://www.vanheusden.com/bsod/"
SRC_URI="http://www.vanheusden.com/${PN}/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="sys-libs/ncurses"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	epatch "${FILESDIR}"/${P}-Makefile.patch
	tc-export PKG_CONFIG
}

src_install() {
	dogamesbin ${PN}
	dodoc Changes

	prepgamesdirs
}
