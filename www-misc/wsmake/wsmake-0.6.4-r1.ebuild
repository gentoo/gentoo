# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Website pre-processor features tag substitution and page ordering"
HOMEPAGE="https://sourceforge.net/projects/wsmake/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2+ Artistic"
SLOT="0"
KEYWORDS="~amd64 ~x86"
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

src_configure() {
	tc-export CXX
	default
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
