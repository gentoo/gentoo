# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

WX_GTK_VER="2.9"

CABAL_FEATURES="lib profile haddock hoogle hscolour"
inherit haskell-cabal

MY_PN=wx
MY_P=${MY_PN}-${PV}

DESCRIPTION="wxHaskell"
HOMEPAGE="http://haskell.org/haskellwiki/WxHaskell"
SRC_URI="mirror://hackage/packages/archive/${MY_PN}/${PV}/${MY_P}.tar.gz"

LICENSE="wxWinLL-3.1"
SLOT="${WX_GTK_VER}/${PV}"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE=""

RDEPEND="dev-haskell/stm:=[profile?]
	>=dev-haskell/wxcore-0.90.1.0:${WX_GTK_VER}=[profile?]
	>=dev-lang/ghc-6.10.4:=
"
DEPEND="${RDEPEND}
	>=dev-haskell/cabal-1.6.0.3
"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-0.13.2.3-ghc-7.10.patch
}

src_configure() {
	# ghc DCE bug: https://ghc.haskell.org/trac/ghc/ticket/9155
	[[ $(ghc-version) == 7.8.2 ]] && replace-hcflags -O[2-9] -O1
	# ghc DCE bug: https://ghc.haskell.org/trac/ghc/ticket/9303
	[[ $(ghc-version) == 7.8.3 ]] && replace-hcflags -O[2-9] -O1

	haskell-cabal_src_configure \
		--flag=newbase
}
