# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

CABAL_FEATURES="lib profile haddock hscolour hoogle"
inherit base haskell-cabal

DESCRIPTION="Replaces/Enhances Text.Regex"
HOMEPAGE="https://sourceforge.net/projects/lazy-regex"
SRC_URI="mirror://hackage/packages/archive/${PN}/${PV}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 ia64 ppc ppc64 sparc x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x86-solaris"
IUSE=""

RDEPEND=">=dev-haskell/regex-base-0.93[profile?]
		>=dev-lang/ghc-6.8.2"
DEPEND="${RDEPEND}
		>=dev-haskell/cabal-1.2"

PATCHES=("${FILESDIR}/${PN}-0.95.1-ghc-7.5.patch")
