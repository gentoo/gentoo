# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-haskell/test-framework/test-framework-0.2.4.ebuild,v 1.10 2012/09/12 15:31:31 qnikst Exp $

CABAL_FEATURES="bin lib profile haddock"
inherit base haskell-cabal

DESCRIPTION="Framework for running and organising tests, with HUnit and QuickCheck support"
HOMEPAGE="http://batterseapower.github.com/test-framework/"
SRC_URI="mirror://hackage/packages/archive/${PN}/${PV}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 ia64 ppc ppc64 sparc x86 ~x86-fbsd"
IUSE=""

DEPEND=">=dev-lang/ghc-6.10
		>=dev-haskell/ansi-terminal-0.4.0
		>=dev-haskell/ansi-wl-pprint-0.4.0
		>=dev-haskell/cabal-1.2.3
		>=dev-haskell/regex-posix-0.72"

# works with ghc 6.8 too if we add this dependency
# >=dev-haskell/extensible-exceptions-0.1.1

src_unpack() {
	base_src_unpack

	# fix what seems to be a cabal bug.
	# dependency of an executable with Buildable:False are still required
	sed -e 's/HUnit >= 1.2,//' -i "${S}/${PN}.cabal"
}
