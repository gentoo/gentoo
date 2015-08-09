# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

inherit eutils

DESCRIPTION="UTF-8 to postscript converter"
HOMEPAGE="http://www.pps.jussieu.fr/~jch/software/cedilla/"
SRC_URI="http://www.pps.jussieu.fr/~jch/software/files/${P}.tar.gz"

KEYWORDS="amd64 x86"
SLOT="0"
LICENSE="GPL-2"
IUSE=""

DEPEND="dev-lisp/clisp"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/cedilla-gentoo-r1.patch
}

src_compile() {
	./compile-cedilla || die "Compile failed."
}

src_install() {
	sed -i "s#${ED%/}##g" cedilla || die "sed failed"
	newman cedilla.man cedilla.1
	./install-cedilla || die "Install failed."
	dodoc NEWS README
}
