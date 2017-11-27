# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Website Pre-processor"
HOMEPAGE="http://www.wsmake.org/"
SRC_URI="http://ftp.wsmake.org/pub/wsmake6/stable/${P}.tar.bz2"

LICENSE="GPL-2 Artistic"
SLOT="0"
KEYWORDS="x86"
IUSE="examples"

PATCHES=(
	"${FILESDIR}"/${P}-bv.diff
	"${FILESDIR}"/${P}-gcc43.patch	# 251745
	"${FILESDIR}"/${P}-fix-const-va_list.patch
)

src_unpack() {
	default

	cd "${S}"/doc || die
	tar -cf examples.tar examples || die
}

src_install() {
	default
	dodoc doc/manual.txt

	if use examples; then
		rm -r doc/examples/CVS || die
		dodoc -r doc/examples
		docompress -x /usr/share/doc/${PF}/examples
	fi
}
