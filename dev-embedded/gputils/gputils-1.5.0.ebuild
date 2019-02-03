# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="Tools including assembler, linker and librarian for PIC microcontrollers"
HOMEPAGE="https://gputils.sourceforge.io"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"
IUSE=""

src_configure() {
	tc-ld-disable-gold #369291
	# Their configure script tries to do funky things with default
	# compiler selection.  Force our own defaults instead.
	tc-export CC
	default
}

src_install() {
	default
	dodoc doc/gputils.pdf
}
