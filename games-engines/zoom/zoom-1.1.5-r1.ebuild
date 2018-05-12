# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="A fast, clean, modern Z-code interpreter for X"
HOMEPAGE="http://www.logicalshift.co.uk/unix/zoom/"
SRC_URI="http://www.logicalshift.co.uk/unix/zoom/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	media-libs/fontconfig
	media-libs/libpng:0
	>=media-libs/t1lib-5
	x11-libs/libSM
	x11-libs/libXft"
DEPEND="${RDEPEND}
	dev-lang/perl
	x11-proto/xextproto"

PATCHES=( "${FILESDIR}"/${P}-gcc7.patch )

src_install() {
	default
	dodoc -r manual/*
}
