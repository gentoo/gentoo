# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Convert CD images from b5i (BlindWrite) to iso"
HOMEPAGE="https://web.archive.org/web/20100116120705/b5i2iso.berlios.de"
SRC_URI="mirror://gentoo/${P}.tar.bz2"
S="${WORKDIR}/${PN}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux ~x64-macos"

PATCHES=( "${FILESDIR}"/${P}-segfault.patch )

src_compile() {
	tc-export CC
	emake -C src b5i2iso
}

src_install() {
	dobin src/b5i2iso
}
