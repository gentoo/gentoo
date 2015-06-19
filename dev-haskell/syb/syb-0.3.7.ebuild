# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-haskell/syb/syb-0.3.7.ebuild,v 1.8 2013/03/31 10:08:39 ago Exp $

EAPI=4

# PDEPEND of ghc, so restrict depgraph
CABAL_FEATURES="lib profile haddock hoogle hscolour nocabaldep"
inherit haskell-cabal

DESCRIPTION="Scrap Your Boilerplate"
HOMEPAGE="http://www.cs.uu.nl/wiki/GenericProgramming/SYB"
SRC_URI="mirror://hackage/packages/archive/${PN}/${PV}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 ia64 ppc ppc64 sparc x86 ~x86-fbsd"
IUSE=""

RDEPEND=">=dev-lang/ghc-6.10.1"
DEPEND="${RDEPEND}"
