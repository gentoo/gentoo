# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CABAL_FEATURES="lib profile haddock hoogle hscolour test-suite"
inherit haskell-cabal

DESCRIPTION="Law-abiding lenses for Aeson, using microlens"
HOMEPAGE="https://github.com/fosskers/microlens-aeson/"
SRC_URI="https://hackage.haskell.org/package/${P}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=dev-haskell/aeson-0.7:=[profile?]
	>=dev-haskell/attoparsec-0.10:=[profile?]
	>=dev-haskell/microlens-0.3:=[profile?]
	>=dev-haskell/scientific-0.3.2:=[profile?]
	>=dev-haskell/text-0.11:=[profile?]
	>=dev-haskell/unordered-containers-0.2.3:=[profile?]
	>=dev-haskell/vector-0.9:=[profile?]
	>=dev-lang/ghc-7.4.1:=
"
DEPEND="${RDEPEND}
	>=dev-haskell/cabal-2.2
	test? ( >=dev-haskell/tasty-0.10.1.2
		>=dev-haskell/tasty-hunit-0.9.2 )
"
