# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-roguelike/mazesofmonad/mazesofmonad-1.0.9-r2.ebuild,v 1.4 2015/08/04 06:39:39 slyfox Exp $

EAPI=5
CABAL_FEATURES="bin"
inherit eutils haskell-cabal games

MY_PN=MazesOfMonad
MY_P=${MY_PN}-${PV}

DESCRIPTION="Console-based roguelike Role Playing Game similar to nethack"
HOMEPAGE="https://github.com/JPMoresmau/MazesOfMonad
	http://hackage.haskell.org/package/MazesOfMonad"
SRC_URI="mirror://hackage/packages/archive/${MY_PN}/${PV}/${MY_P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=dev-libs/gmp-5:0=
	virtual/libffi:="
DEPEND="${RDEPEND}
	>=dev-lang/ghc-7.4.1
	>=dev-haskell/cabal-1.6
	dev-haskell/hunit
	dev-haskell/mtl
	dev-haskell/random
	dev-haskell/regex-posix
	dev-haskell/time-locale-compat
"

S=${WORKDIR}/${MY_P}

pkg_setup() {
	games_pkg_setup
	haskell-cabal_pkg_setup
}

src_prepare() {
	epatch "${FILESDIR}"/${PN}-1.0.9-time-1.5.patch
}

src_configure() {
	haskell-cabal_src_configure \
		--prefix="${GAMES_PREFIX}"
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
