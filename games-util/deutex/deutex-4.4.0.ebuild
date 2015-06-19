# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-util/deutex/deutex-4.4.0.ebuild,v 1.10 2015/03/15 04:20:14 mr_bones_ Exp $

EAPI=5
inherit toolchain-funcs eutils

DESCRIPTION="A wad composer for Doom, Heretic, Hexen and Strife"
HOMEPAGE="http://www.teaser.fr/~amajorel/deutex/"
SRC_URI="http://www.teaser.fr/~amajorel/deutex/${P}.tar.gz"

LICENSE="GPL-2+ LGPL-2+ HPND"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

RDEPEND=""
DEPEND=""

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-makefile.patch \
		"${FILESDIR}"/${P}-64bit.patch \
		"${FILESDIR}"/${P}-ovflfix.patch
	tc-export CC
}

src_install() {
	dobin deusf deutex
	doman deutex.6
	dodoc CHANGES README TODO
}
