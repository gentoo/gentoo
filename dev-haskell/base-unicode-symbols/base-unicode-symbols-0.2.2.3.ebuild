# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

CABAL_FEATURES="lib profile haddock hoogle hscolour"
inherit haskell-cabal

DESCRIPTION="Unicode alternatives for common functions and operators"
HOMEPAGE="http://haskell.org/haskellwiki/Unicode-symbols"
SRC_URI="mirror://hackage/packages/archive/${PN}/${PV}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=dev-lang/ghc-6.8.2"
DEPEND="${RDEPEND}
		>=dev-haskell/cabal-1.6"

src_prepare() {
	if has_version ">=dev-lang/ghc-7.5.20120511"; then
		# change the unicode -> to ascii ->
		epatch "${FILESDIR}/${PN}-0.2.2.3-ghc-7.5.patch"
	fi
	cabal_chdeps \
		'base >= 3.0.3.1 && < 4.6' 'base >= 3.0.3.1 && < 5'
}
