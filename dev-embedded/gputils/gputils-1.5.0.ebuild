# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools toolchain-funcs

DESCRIPTION="Tools including assembler, linker and librarian for PIC microcontrollers"
HOMEPAGE="https://gputils.sourceforge.io"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"

PATCHES=(
	"${FILESDIR}/flags.patch"
)

src_prepare() {
	default

	eautoreconf
}

src_compile() {
	# bug #369291, bug #818802
	tc-ld-disable-gold

	# Their configure script tries to do funky things with default
	# compiler selection.  Force our own defaults instead.
	tc-export CC

	econf
}

src_install() {
	default

	dodoc doc/gputils.pdf
}
