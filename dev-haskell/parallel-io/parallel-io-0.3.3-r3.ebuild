# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

CABAL_FEATURES="bin lib profile haddock hoogle hscolour"
inherit haskell-cabal

DESCRIPTION="Combinators for executing IO actions in parallel on a thread pool"
HOMEPAGE="http://batterseapower.github.com/parallel-io"
SRC_URI="https://hackage.haskell.org/package/${P}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE=""
#hackport: flags: -test -fuzz -benchmark

RDEPEND=">dev-haskell/extensible-exceptions-0.1.0.1:=[profile?]
	>=dev-haskell/random-1.0:=[profile?] <dev-haskell/random-1.2:=[profile?]
	>=dev-lang/ghc-7.4.1:=
"
DEPEND="${RDEPEND}
	>=dev-haskell/cabal-1.2
"

src_prepare() {
	# Hackage metadata revision -r1.
	cabal_chdeps \
		'random >= 1.0 && < 1.1' 'random >= 1.0 && < 1.2'

	# Hackage metadata revision -r2.
	cabal_chdeps \
		'containers >= 0.2 && < 0.6' 'containers >= 0.2 && < 0.7'

	default
}
