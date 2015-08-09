# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

inherit eutils toolchain-funcs

MY_PN="DFBSee"
MY_P=${MY_PN}-${PV}

DESCRIPTION="an image viewer and video player based on DirectFB"
HOMEPAGE="http://directfb.org/index.php?path=Projects%2FDFBSee"
SRC_URI="http://www.directfb.org/download/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 -sparc x86"
IUSE=""

RDEPEND=">=dev-libs/DirectFB-0.9.24[png]"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S=${WORKDIR}/${MY_P}

src_prepare() {
	epatch "${FILESDIR}/${P}-direcfb-0.9.24.patch"
	epatch "${FILESDIR}/${P}-gcc4.patch"
	epatch "${FILESDIR}/${P}-standardtypes.patch"
}

src_configure() {
	tc-export CC
	default
}
