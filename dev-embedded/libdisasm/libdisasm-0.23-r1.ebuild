# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Provides basic disassembly of Intel x86 instructions from a binary stream"
HOMEPAGE="https://bastard.sourceforge.net/libdisasm.html"
SRC_URI="https://downloads.sourceforge.net/project/bastard/${PN}/${PV}/${P}.tar.gz"

LICENSE="Clarified-Artistic"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"

PATCHES=( "${FILESDIR}"/${P}-user-AS-OBJDUMP.patch )

src_configure() {
	# bug 722606
	tc-export AS OBJDUMP

	econf
}

src_install() {
	default

	# no static archives
	find "${ED}" -name '*.la' -delete || die
}
