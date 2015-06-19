# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-board/goatee-gtk/goatee-gtk-0.2.0-r1.ebuild,v 1.2 2014/11/24 08:38:22 slyfox Exp $

EAPI=5

CABAL_FEATURES="bin lib profile haddock hoogle hscolour test-suite"
inherit haskell-cabal eutils games

DESCRIPTION="A monadic take on a 2,500-year-old board game - GTK+ UI"
HOMEPAGE="http://khumba.net/projects/goatee"
SRC_URI="mirror://hackage/packages/archive/${PN}/${PV}/${P}.tar.gz"

LICENSE="AGPL-3"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=dev-games/goatee-0.2:=[profile?] <dev-games/goatee-0.3:=[profile?]
	>=dev-haskell/cairo-0.12:=[profile?] <dev-haskell/cairo-0.13:=[profile?]
	>=dev-haskell/gtk-0.12:2=[profile?] <dev-haskell/gtk-0.13:2=[profile?]
	>=dev-haskell/mtl-2.1:=[profile?] <dev-haskell/mtl-2.3:=[profile?]
	>=dev-haskell/parsec-3.1:=[profile?] <dev-haskell/parsec-3.2:=[profile?]
	>=dev-lang/ghc-7.4.1:=
	>=dev-libs/gmp-5:=
	virtual/libffi:=
"
DEPEND="${RDEPEND}
	>=dev-haskell/cabal-1.8
	test? ( >=dev-haskell/hunit-1.2 <dev-haskell/hunit-1.3 )
"

pkg_setup() {
	games_pkg_setup
	haskell-cabal_pkg_setup
}

src_configure() {
	haskell-cabal_src_configure \
		--bindir="${GAMES_BINDIR}"
}

src_compile() {
	haskell-cabal_src_compile
}

src_install() {
	haskell-cabal_src_install
	prepgamesdirs
}

pkg_postinst() {
	ghc-package_pkg_postinst
	games_pkg_postinst
}
