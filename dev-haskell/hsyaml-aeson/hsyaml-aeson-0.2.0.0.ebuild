# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CABAL_FEATURES="lib profile haddock hoogle hscolour"
inherit haskell-cabal

MY_PN="HsYAML-aeson"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="JSON to YAML Adapter"
HOMEPAGE="https://github.com/hvr/HsYAML"
SRC_URI="https://hackage.haskell.org/package/${MY_P}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=dev-haskell/aeson-0.7:=[profile?] <dev-haskell/aeson-1.5:=[profile?]
	>=dev-haskell/mtl-2.2.1:=[profile?] <dev-haskell/mtl-2.3:=[profile?]
	>=dev-haskell/scientific-0.3:=[profile?] <dev-haskell/scientific-0.4:=[profile?]
	>=dev-haskell/text-1.2.3:=[profile?] <dev-haskell/text-1.3:=[profile?]
	>=dev-haskell/vector-0.10:=[profile?] <dev-haskell/vector-0.13:=[profile?]
	>=dev-lang/ghc-7.4.1:=
"
DEPEND="${RDEPEND}
	>=dev-haskell/cabal-1.14
"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	default

	cabal_chdeps \
		'base         >= 4.5 && < 4.14' 'base         >= 4.5' \
		'containers   >=0.4.2 && <0.7' 'containers   >=0.4.2'
}
