# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CABAL_FEATURES="lib hoogle hscolour profile test-suite" # haddock
inherit haskell-cabal

DESCRIPTION="A documentation-generation tool for Haskell libraries"
HOMEPAGE="https://www.haskell.org/haddock/"
SRC_URI="https://hackage.haskell.org/package/${P}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0/${PV}"
# keep in sync with ghc-8.10
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND=">=dev-haskell/ghc-paths-0.1.0.9:=[profile?] <dev-haskell/ghc-paths-0.2:=[profile?]
	>=dev-haskell/haddock-library-1.9.0:=[profile?] <dev-haskell/haddock-library-1.10:=[profile?]
	>=dev-haskell/xhtml-3000.2.2:=[profile?] <dev-haskell/xhtml-3000.3:=[profile?]
	>=dev-lang/ghc-8.10.1:=
"
DEPEND="${RDEPEND}
	>=dev-haskell/cabal-3.0.0.0
	test? ( >=dev-haskell/ghc-paths-0.1.0.12 <dev-haskell/ghc-paths-0.2
		>=dev-haskell/hspec-2.4.4 <dev-haskell/hspec-2.8
		>=dev-haskell/quickcheck-2.11
		)
"

PATCHES=("${FILESDIR}"/${P}-ghc-8.10.2.patch )

src_prepare () {
	default

	cabal_chdeps \
		'QuickCheck      >= 2.11  && < 2.14' 'QuickCheck >= 2.11'
}
