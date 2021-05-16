# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="UTF-8 to postscript converter"
HOMEPAGE="http://www.pps.jussieu.fr/~jch/software/cedilla/"
SRC_URI="http://www.pps.jussieu.fr/~jch/software/files/${P}.tar.gz"

KEYWORDS="amd64 x86"
SLOT="0"
LICENSE="GPL-2"

DEPEND="dev-lisp/clisp"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}"/cedilla-gentoo-r1.patch )

src_compile() {
	./compile-cedilla || die "Compile failed."
}

src_install() {
	sed "s#${ED%/}##g" -i cedilla || die "sed failed"
	dodir /usr/share/man/man1/

	./install-cedilla || die "Install failed."

	einstalldocs
}
