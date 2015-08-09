# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

CABAL_FEATURES="lib profile haddock"
inherit haskell-cabal

DESCRIPTION="HUnit support for the test-framework package"
HOMEPAGE="http://batterseapower.github.com/test-framework/"
SRC_URI="mirror://hackage/packages/archive/${PN}/${PV}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 ia64 ppc ppc64 sparc x86 ~x86-fbsd"
IUSE=""

# works with ghc 6.8 too if we add this dependency
# >=dev-haskell/extensible-exceptions-0.1.1

DEPEND=">=dev-lang/ghc-6.10
		>=dev-haskell/cabal-1.2.3
		>=dev-haskell/hunit-1.2
		>=dev-haskell/test-framework-0.2.0"
