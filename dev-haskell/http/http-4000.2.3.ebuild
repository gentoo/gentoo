# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-haskell/http/http-4000.2.3.ebuild,v 1.8 2012/12/10 21:53:15 slyfox Exp $

EAPI="4"

CABAL_FEATURES="lib profile haddock hscolour hoogle"
inherit base haskell-cabal

MY_PN="HTTP"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="A library for client-side HTTP"
HOMEPAGE="https://github.com/haskell/HTTP"
SRC_URI="mirror://hackage/packages/archive/${MY_PN}/${PV}/${MY_P}.tar.gz
		http://dev.gentoo.org/~gienah/2big4tree/dev-haskell/http/${MY_P}-test-suite.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 ia64 ppc ppc64 sparc x86 ~x86-fbsd ~ppc-macos ~x86-macos"
IUSE="test"

RDEPEND=">=dev-haskell/mtl-2.0[profile?]
		<dev-haskell/mtl-2.2[profile?]
		dev-haskell/network[profile?]
		dev-haskell/parsec[profile?]
		>=dev-lang/ghc-6.8.2"
DEPEND="${RDEPEND}
		>=dev-haskell/cabal-1.8
		test? ( >=dev-haskell/cabal-1.10
			dev-haskell/hunit[profile?]
			dev-haskell/httpd-shed[profile?]
			=dev-haskell/split-0.1*[profile?]
			dev-haskell/test-framework[profile?]
			dev-haskell/test-framework-hunit[profile?]
		)
		"

S="${WORKDIR}/${MY_P}"

PATCHES=("${FILESDIR}/${PN}-4000.2.3-ghc-7.6.patch")

src_configure() {
	cabal_src_configure $(use test && use_enable test tests) #395351
}
