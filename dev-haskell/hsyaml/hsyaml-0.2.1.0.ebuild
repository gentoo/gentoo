# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CABAL_FEATURES="lib profile haddock hoogle hscolour test-suite"
inherit haskell-cabal

MY_PN="HsYAML"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Pure Haskell YAML 1.2 parser"
HOMEPAGE="https://github.com/haskell-hvr/HsYAML"
SRC_URI="https://hackage.haskell.org/package/${MY_P}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0/${PV}"
KEYWORDS="amd64 ~arm64 ~ppc64 ~riscv ~x86"
IUSE=""

RDEPEND=">=dev-haskell/fail-4.9.0.0:=[profile?] <dev-haskell/fail-4.10:=[profile?]
	>=dev-haskell/mtl-2.2.1:=[profile?] <dev-haskell/mtl-2.3:=[profile?]
	>=dev-haskell/nats-1.1.2:=[profile?] <dev-haskell/nats-1.2:=[profile?]
	>=dev-haskell/parsec-3.1.13.0:=[profile?] <dev-haskell/parsec-3.2:=[profile?]
	>=dev-haskell/text-1.2.3:=[profile?] <dev-haskell/text-1.3:=[profile?]
	>=dev-lang/ghc-7.4.1:=
"
DEPEND="${RDEPEND}
	>=dev-haskell/cabal-1.14
	test? ( >=dev-haskell/quickcheck-2.13:2=
		>=dev-haskell/tasty-1.2:=
		>=dev-haskell/tasty-quickcheck-0.10:= )
"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	default

	cabal_chdeps \
		'base         >=4.5   && <4.14' 'base         >=4.5' \
		'containers   >=0.4.2 && <0.7' 'containers   >=0.4.2' \
		'QuickCheck == 2.13.*' 'QuickCheck >= 2.13' \
		'tasty == 1.2.*' 'tasty >= 1.2' \
		'tasty-quickcheck == 0.10.*' 'tasty-quickcheck >= 0.10'
}
