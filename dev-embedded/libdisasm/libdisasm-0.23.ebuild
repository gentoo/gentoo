# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Provides basic disassembly of Intel x86 instructions from a binary stream"
HOMEPAGE="http://bastard.sourceforge.net/libdisasm.html"
SRC_URI="mirror://sourceforge/project/bastard/${PN}/${PV}/${P}.tar.gz"

LICENSE="Clarified-Artistic"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"

PATCHES=( "${FILESDIR}"/${P}-user-AS-OBJDUMP.patch )

src_configure() {
	# bug 722606
	tc-export AS OBJDUMP

	econf --disable-static
}

src_install() {
	default

	# no static archives
	find "${ED}" -name '*.la' -delete || die
}
