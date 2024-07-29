# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="UTF-8 to postscript converter"
HOMEPAGE="http://www.pps.jussieu.fr/~jch/software/cedilla/
	https://github.com/jech/cedilla"
SRC_URI="http://www.pps.jussieu.fr/~jch/software/files/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 x86"

DEPEND="dev-lisp/clisp"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}"/cedilla-gentoo-r1.patch )

src_compile() {
	./compile-cedilla || die "Compile failed."
}

src_install() {
	sed "s#${ED}##g" -i cedilla || die "sed failed"
	dodir /usr/share/man/man1/

	./install-cedilla || die "Install failed."

	einstalldocs
}
