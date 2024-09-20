# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Fast, clean, modern Z-code interpreter for X"
HOMEPAGE="https://www.logicalshift.co.uk/unix/zoom/"
SRC_URI="https://www.logicalshift.co.uk/unix/zoom/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="!net-im/zoom[zoom-symlink(+)]
	media-libs/fontconfig
	media-libs/libpng:0
	>=media-libs/t1lib-5
	x11-libs/libSM
	x11-libs/libXft"
DEPEND="${RDEPEND}
	dev-lang/perl
	x11-base/xorg-proto"

PATCHES=( "${FILESDIR}"/${P}-gcc7.patch )

src_install() {
	default
	dodoc -r manual/*
}
