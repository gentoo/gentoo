# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-puzzle/wakkabox/wakkabox-1.1.0.ebuild,v 1.9 2015/02/26 23:07:52 tupone Exp $

EAPI=5
inherit eutils autotools games

DESCRIPTION="A simple block-pushing game"
HOMEPAGE="http://kenn.frap.net/wakkabox/"
SRC_URI="http://kenn.frap.net/wakkabox/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="ppc x86"
IUSE=""

DEPEND=">=media-libs/libsdl-1.0.1"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-gentoo.patch
	rm aclocal.m4
	eautoreconf
}

src_install() {
	default
	prepgamesdirs
}
