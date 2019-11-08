# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="4"

CABAL_FEATURES="lib profile haddock hoogle hscolour"
inherit haskell-cabal

DESCRIPTION="HUnit support for the test-framework package"
HOMEPAGE="https://batterseapower.github.com/test-framework/"
SRC_URI="https://hackage.haskell.org/package/${P}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 ia64 ppc ppc64 sparc x86"
IUSE=""

HASKELLDEPS=">=dev-haskell/hunit-1.2[profile?]
		>=dev-haskell/test-framework-0.2.0[profile?]"
RDEPEND=">=dev-lang/ghc-6.10
		${HASKELLDEPS}"
DEPEND=">=dev-haskell/cabal-1.2.3
		${RDEPEND}"
