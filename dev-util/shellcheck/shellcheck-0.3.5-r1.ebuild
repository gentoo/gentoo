# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

CABAL_FEATURES="bin lib profile haddock hoogle hscolour test-suite"

inherit haskell-cabal

MY_PN="ShellCheck"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Shell script analysis tool"
HOMEPAGE="http://www.shellcheck.net/"
SRC_URI="
	mirror://hackage/packages/archive/${MY_PN}/${PV}/${MY_P}.tar.gz
	https://dev.gentoo.org/~mjo/distfiles/${PN}-man-${PV}.tar.xz"

LICENSE="AGPL-3"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-haskell/json:=[profile?]
	dev-haskell/mtl:=[profile?]
	dev-haskell/parsec:=[profile?]
	>=dev-haskell/quickcheck-2.7.4:2=[profile?]
	dev-haskell/regex-compat:=[profile?]
	dev-haskell/transformers:=[profile?]
	>=dev-lang/ghc-7.4.1:=
"
DEPEND="${RDEPEND}
	>=dev-haskell/cabal-1.8
"

S="${WORKDIR}/${MY_P}"

src_test() {
	# See bug #537500 for this beauty.
	runghc Setup.hs test || die 'test suite failed'
}

src_install() {
	cabal_src_install
	doman "${PN}.1"
}
