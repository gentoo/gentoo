# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

CABAL_FEATURES="lib profile haddock hoogle hscolour"
inherit haskell-cabal

DESCRIPTION="Fast base64 encoding and deconding for ByteStrings"
HOMEPAGE="https://github.com/bos/base64-bytestring"
SRC_URI="mirror://hackage/packages/archive/${PN}/${PV}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND=">=dev-lang/ghc-6.10.1"
DEPEND="${RDEPEND}
		>=dev-haskell/cabal-1.8
		test? (
			dev-haskell/hunit
			>=dev-haskell/quickcheck-2.4.0.1
			dev-haskell/test-framework
			dev-haskell/test-framework-hunit
			dev-haskell/test-framework-quickcheck2
		)
		"

src_prepare() {
	cp "${FILESDIR}/Tests.hs" tests \
		|| die "Could not copy missing Tests.hs"
	sed -e "s@bytestring == 0.9.*@bytestring < 0.11@"\
		-i "${PN}.cabal"
}

src_configure() {
	cabal_src_configure $(use test && use_enable test tests) #395351
}
