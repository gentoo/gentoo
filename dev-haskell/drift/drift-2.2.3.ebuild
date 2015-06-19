# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-haskell/drift/drift-2.2.3.ebuild,v 1.7 2012/05/13 09:37:20 slyfox Exp $

EAPI=4

inherit base ghc-package

MY_PN="DrIFT"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Preprocessor for automatic derivation of Haskell class instances"
HOMEPAGE="http://repetae.net/john/computer/haskell/DrIFT/"
SRC_URI="http://repetae.net/john/computer/haskell/DrIFT/drop/${MY_P}.tar.gz"
LICENSE="MIT"
SLOT="0"

KEYWORDS="alpha amd64 ia64 ppc ppc64 sparc x86"

IUSE=""

DEPEND=">=dev-lang/ghc-6"
RDEPEND=""

S="${WORKDIR}/${MY_P}"

PATCHES=("${FILESDIR}"/${PN}-2.2.3-ghc-7.4.patch)

src_configure() {
	econf --with-hc="$(ghc-getghc)" --with-hcflags="${HCFLAGS} -package haskell98 -hide-package base"
}

src_compile() {
	# Makefile has no parallelism
	emake -j1
}
