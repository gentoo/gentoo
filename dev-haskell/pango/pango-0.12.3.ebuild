# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-haskell/pango/pango-0.12.3.ebuild,v 1.9 2014/07/25 09:16:18 slyfox Exp $

EAPI=4

#nocabaldep is for the fancy cabal-detection feature at build-time
CABAL_FEATURES="lib profile haddock hscolour hoogle nocabaldep"
inherit haskell-cabal

DESCRIPTION="Binding to the Pango text rendering engine"
HOMEPAGE="http://projects.haskell.org/gtk2hs/"
SRC_URI="mirror://hackage/packages/archive/${PN}/${PV}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="=dev-haskell/cairo-0.12*:0[profile?]
		=dev-haskell/glib-0.12*:0[profile?]
		dev-haskell/mtl[profile?]
		>=dev-lang/ghc-6.10.1
		x11-libs/cairo
		x11-libs/pango"
DEPEND="${RDEPEND}
		>=dev-haskell/gtk2hs-buildtools-0.12.3-r3:0"
