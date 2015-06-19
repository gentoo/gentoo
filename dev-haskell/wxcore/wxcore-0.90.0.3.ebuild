# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-haskell/wxcore/wxcore-0.90.0.3.ebuild,v 1.2 2013/01/13 11:57:38 gienah Exp $

EAPI=5

WX_GTK_VER="2.9"

CABAL_FEATURES="lib profile haddock hoogle hscolour"
inherit base haskell-cabal

DESCRIPTION="wxHaskell core"
HOMEPAGE="http://haskell.org/haskellwiki/WxHaskell"
SRC_URI="mirror://hackage/packages/archive/${PN}/${PV}/${P}.tar.gz"

LICENSE="wxWinLL-3.1"
SLOT="${WX_GTK_VER}/${PV}"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE=""

RDEPEND="dev-haskell/parsec:=[profile?]
		dev-haskell/stm:=[profile?]
		>=dev-haskell/wxc-0.90.0.4:${WX_GTK_VER}=[profile?]
		>=dev-haskell/wxdirect-0.90:${WX_GTK_VER}=[profile?]
		>=dev-lang/ghc-6.12.1:="
DEPEND="${RDEPEND}
		>=dev-haskell/cabal-1.2"

PATCHES=("${FILESDIR}/${PN}-0.90.0.1-ghc-7.5.patch")

src_prepare() {
	base_src_prepare
	sed -e "s@wxdirect@wxdirect-${WX_GTK_VER}@g" \
		-i "${S}/Setup.hs" \
		|| die "Could not change Setup.hs for wxdirect slot ${WX_GTK_VER}"
}

src_configure() {
	haskell-cabal_src_configure \
		--flag=splitbase
}
