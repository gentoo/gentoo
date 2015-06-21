# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/shellcheck/shellcheck-0.3.8.ebuild,v 1.1 2015/06/21 10:41:49 jlec Exp $

EAPI=5

CABAL_FEATURES="bin lib profile haddock hoogle hscolour test-suite"

inherit haskell-cabal

MY_PN="ShellCheck"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Shell script analysis tool"
HOMEPAGE="http://www.shellcheck.net/"
SRC_URI="mirror://hackage/packages/archive/${MY_PN}/${PV}/${MY_P}.tar.gz"

LICENSE="GPL-3"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-haskell/json:=[profile?]
	dev-haskell/mtl:=[profile?]
	dev-haskell/parsec:=[profile?]
	>=dev-haskell/quickcheck-2.7.4:2=[profile?]
	dev-haskell/regex-tdfa:=[profile?]
	dev-haskell/transformers:=[profile?]
	>=dev-lang/ghc-7.8.4:=
"
DEPEND="${RDEPEND}
	>=dev-haskell/cabal-1.8
	test? ( >=dev-haskell/cabal-1.20 )
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
