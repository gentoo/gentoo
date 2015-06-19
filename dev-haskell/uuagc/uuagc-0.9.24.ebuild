# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-haskell/uuagc/uuagc-0.9.24.ebuild,v 1.6 2015/05/05 20:45:51 slyfox Exp $

CABAL_FEATURES="bin lib profile haddock"
inherit eutils haskell-cabal

DESCRIPTION="Attribute Grammar System of Universiteit Utrecht"
HOMEPAGE="http://www.cs.uu.nl/wiki/HUT/WebHome"
SRC_URI="mirror://hackage/packages/archive/${PN}/${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 sparc x86"
IUSE=""

HASKELLDEPS="dev-haskell/cabal
		>=dev-haskell/uulib-0.9.12"
RDEPEND=">=dev-lang/ghc-6.10
		${HASKELLDEPS}"
DEPEND=">=dev-haskell/cabal-1.2
		${RDEPEND}"

src_unpack() {
	unpack "${A}"
	cd "${S}"
	epatch "${FILESDIR}"/${P}-ghc-7.8.patch

	sed \
		-e 's/{-# LINE/{- # LINE/g' \
		-i "${S}"/src-derived/*.hs
}
