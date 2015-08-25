# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit toolchain-funcs

DESCRIPTION="sexyPSF is an open-source PSF1 (Playstation music) file player"
HOMEPAGE="http://projects.raphnet.net/#sexypsf"
SRC_URI="http://projects.raphnet.net/sexypsf/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"

KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

DEPEND="sys-libs/zlib"

src_compile() {
	tc-export CC
	cd "${S}"/Linux
	emake
}

src_install() {
	dobin Linux/sexypsf
	dodoc Docs/*
}
