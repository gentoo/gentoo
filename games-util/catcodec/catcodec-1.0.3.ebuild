# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils toolchain-funcs

DESCRIPTION="Decodes and encodes sample catalogues for OpenTTD"
HOMEPAGE="http://www.openttd.org/en/download-catcodec"
SRC_URI="http://binaries.openttd.org/extra/catcodec/${PV}/${P}-source.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ppc ppc64 x86"
IUSE=""

src_prepare() {
	tc-export CXX
	epatch "${FILESDIR}"/${P}-gcc47.patch
}

src_compile() {
	emake VERBOSE=1
}

src_install() {
	dobin catcodec
	dodoc changelog.txt docs/readme.txt
	doman docs/catcodec.1
}
