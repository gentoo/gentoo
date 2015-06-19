# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-haskell/mersenne-random-pure64/mersenne-random-pure64-0.2.0.3.ebuild,v 1.1 2013/08/25 06:20:28 qnikst Exp $

EAPI="3"

CABAL_FEATURES="lib profile haddock hscolour hoogle"
inherit haskell-cabal eutils

DESCRIPTION="Generate high quality pseudorandom numbers purely using a Mersenne Twister"
HOMEPAGE="http://code.haskell.org/~dons/code/mersenne-random-pure64/"
SRC_URI="mirror://hackage/packages/archive/${PN}/${PV}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=dev-lang/ghc-6.8.2
	dev-haskell/random"
DEPEND="${RDEPEND}
		>=dev-haskell/cabal-1.2.0"

src_prepare() {
	if use x86; then
		# int-e's patch to improve 32-bit performance.
		# this might be applicable to other arches as well, not sure
		epatch "${FILESDIR}/${P}-double-for-32bits.patch"
	fi
}
