# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-haskell/frown/frown-0.6.1-r1.ebuild,v 1.13 2012/07/13 20:42:04 qnikst Exp $

EAPI="4"

CABAL_FEATURES="bin"
inherit haskell-cabal

DESCRIPTION="A parser generator for Haskell"
HOMEPAGE="http://www.informatik.uni-bonn.de/~ralf/frown/"
SRC_URI="http://www.informatik.uni-bonn.de/~ralf/frown/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 sparc x86"
IUSE=""

DEPEND=">=dev-lang/ghc-6.2.2"
RDEPEND=""

S="${WORKDIR}/Frown-${PV}"

src_prepare() {
	# enabling optimisation is strongly recommended
	echo "ghc-options: -O" >> "${S}/frown.cabal"
	epatch "${FILESDIR}/${P}-ghc74.patch"
}

src_install() {
	cabal_src_install
	dohtml -r Manual/html
	dodoc COPYRIGHT Manual/Manual.ps
}
