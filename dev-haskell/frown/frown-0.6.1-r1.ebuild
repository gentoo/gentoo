# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-haskell/frown/frown-0.6.1-r1.ebuild,v 1.14 2015/08/01 15:45:57 slyfox Exp $

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
	epatch "${FILESDIR}/${P}-ghc74.patch"
	epatch "${FILESDIR}"/${P}-ghc-7.10.patch
}

src_install() {
	cabal_src_install
	dohtml -r Manual/html
	dodoc COPYRIGHT Manual/Manual.ps
}
