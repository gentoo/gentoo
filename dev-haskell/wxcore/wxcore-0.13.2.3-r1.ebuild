# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

WX_GTK_VER="2.8"

CABAL_FEATURES="lib profile haddock hoogle hscolour"
inherit base haskell-cabal wxwidgets

DESCRIPTION="wxHaskell core"
HOMEPAGE="http://haskell.org/haskellwiki/WxHaskell"
SRC_URI="mirror://hackage/packages/archive/${PN}/${PV}/${P}.tar.gz"

LICENSE="wxWinLL-3.1"
SLOT="${WX_GTK_VER}/${PV}"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE=""

RDEPEND="dev-haskell/parsec:=[profile?]
		dev-haskell/stm:=[profile?]
		>dev-haskell/wxdirect-0.12.1.2:${WX_GTK_VER}=[profile?]
		<dev-haskell/wxdirect-0.90:${WX_GTK_VER}=[profile?]
		>=dev-lang/ghc-6.12.1:=
		x11-libs/wxGTK:${WX_GTK_VER}=[X,gstreamer,opengl]"
DEPEND="${RDEPEND}
		>=dev-haskell/cabal-1.2"

PATCHES=("${FILESDIR}/${PN}"-0.13.2.3-ghc-7.6.patch
	"${FILESDIR}/${PN}"-0.13.2.3-stdcpp.patch)

src_prepare() {
	base_src_prepare
	sed -e "s@wxdirect@wxdirect-${WX_GTK_VER}@g" \
		-i "${S}/Setup.hs" \
		|| die "Could not change Setup.hs for wxdirect slot ${WX_GTK_VER}"
	cabal_chdeps \
		'array >= 0.2 && < 0.5' 'array >= 0.2'
}

src_configure() {
	haskell-cabal_src_configure \
		--flag=splitbase
}
