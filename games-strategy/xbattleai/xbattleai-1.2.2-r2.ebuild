# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit eutils

DESCRIPTION="A multi-player game of strategy and coordination"
HOMEPAGE="https://inf.ug.edu.pl/~piotao/xbattle/mirror/www.lysator.liu.se/XBattleAI/"
SRC_URI="https://inf.ug.edu.pl/~piotao/xbattle/mirror/www.lysator.liu.se/XBattleAI/${P}.tgz"

LICENSE="xbattle"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

# Since this uses similar code and the same binary name as the original XBattle,
# we want to make sure you can't install both at the same time
RDEPEND="
	dev-lang/tcl:0
	dev-lang/tk:0
	x11-libs/libX11
	x11-libs/libXext
	!games-strategy/xbattle"
DEPEND="${RDEPEND}
	app-text/rman
	x11-misc/imake
	x11-proto/xproto"

PATCHES=(
	"${FILESDIR}"/${P}-sandbox.patch
)

src_prepare() {
	default
	rm -f xbcs/foo.xbc~ || die
}

src_install() {
	DOCS="CONTRIBUTORS README README.AI TODO xbattle.dot" \
		default
	mv "${D}/usr/bin/"{,xb_}gauntletCampaign || die
}
