# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="A multi-player game of strategy and coordination"
HOMEPAGE="https://inf.ug.edu.pl/~piotao/xbattle/mirror/www.lysator.liu.se/XBattleAI/"
SRC_URI="https://inf.ug.edu.pl/~piotao/xbattle/mirror/www.lysator.liu.se/XBattleAI/${P}.tgz"

LICENSE="xbattle"
SLOT="0"
KEYWORDS="~amd64 ~x86"

# Since this uses similar code and the same binary name as the original XBattle,
# we want to make sure you can't install both at the same time
RDEPEND="
	dev-lang/tcl:0
	dev-lang/tk:0
	x11-libs/libX11
	x11-libs/libXext
	!games-strategy/xbattle
"
DEPEND="
	${RDEPEND}
	x11-base/xorg-proto
"
BDEPEND="
	app-text/rman
	x11-misc/imake
"

DOCS=( CONTRIBUTORS README README.AI TODO xbattle.dot )

PATCHES=(
	"${FILESDIR}"/${P}-sandbox.patch
)

src_prepare() {
	default
	rm -f xbcs/foo.xbc~ || die
	rm config.cache || die

	tc-export CC
}

src_install() {
	default
	mv "${ED}/usr/bin/"{,xb_}gauntletCampaign || die
}
