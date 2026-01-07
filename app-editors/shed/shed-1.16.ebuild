# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

inherit autotools

DESCRIPTION="Simple Hex EDitor"
HOMEPAGE="https://shed.sourceforge.net/"
SRC_URI="https://downloads.sourceforge.net/${PN}/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ppc ~riscv x86"

RDEPEND="sys-libs/ncurses:0="
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=( "${FILESDIR}"/${P}-tinfo.patch )

src_prepare() {
	default

	eautoreconf
}
