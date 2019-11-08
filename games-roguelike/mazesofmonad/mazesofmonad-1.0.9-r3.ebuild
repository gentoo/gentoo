# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
CABAL_FEATURES="bin"
inherit eutils haskell-cabal

MY_PN=MazesOfMonad
MY_P=${MY_PN}-${PV}

DESCRIPTION="Console-based roguelike Role Playing Game similar to nethack"
HOMEPAGE="https://github.com/JPMoresmau/MazesOfMonad
	http://hackage.haskell.org/package/MazesOfMonad"
SRC_URI="https://hackage.haskell.org/package/${MY_P}/${MY_P}.tar.gz"

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

PATCHES=(
	"${FILESDIR}"/${PN}-1.0.9-time-1.5.patch
)
