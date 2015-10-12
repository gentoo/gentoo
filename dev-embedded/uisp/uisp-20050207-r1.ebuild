# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

inherit eutils

DESCRIPTION="tool for AVR microcontrollers which can interface to many hardware in-system programmers"
HOMEPAGE="http://savannah.nongnu.org/projects/uisp"
SRC_URI="http://savannah.nongnu.org/download/uisp/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE=""

src_prepare() {
	sed -i -e "/^DOC_INST_DIR/s:/[^/]*$:/${PF}:" Makefile.in || die
	cd src
	epatch "${FILESDIR}"/mega-48-88-168.patch
	sed -i -e 's: -Werror::' Makefile.in || die
}

src_install() {
	default
	dodoc doc/*
	rm "${ED}"/usr/share/doc/${PF}/COPYING* || die
}
