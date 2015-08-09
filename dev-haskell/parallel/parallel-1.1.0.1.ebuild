# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

CABAL_FEATURES="lib profile haddock"
inherit haskell-cabal

DESCRIPTION="parallel programming library"
HOMEPAGE="http://hackage.haskell.org/cgi-bin/hackage-scripts/package/parallel"
SRC_URI="mirror://hackage/packages/archive/${PN}/${PV}/${P}.tar.gz"

LICENSE="BSD"
SLOT="1"
KEYWORDS="amd64 ~sparc x86 ~amd64-linux ~x86-linux ~x86-macos"
IUSE=""

RDEPEND=">=dev-lang/ghc-6.10.1"
DEPEND="${RDEPEND}
		>=dev-haskell/cabal-1.2"
