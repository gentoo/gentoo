# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-haskell/base64-bytestring/base64-bytestring-0.1.1.3.ebuild,v 1.2 2012/09/12 15:59:24 qnikst Exp $

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

src_configure() {
	cabal_src_configure $(use test && use_enable test tests) #395351
}
