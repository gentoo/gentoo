# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit autotools flag-o-matic

DESCRIPTION="Pseudo-Random Number Generator library"
HOMEPAGE="http://statmath.wu.ac.at/prng/"
SRC_URI="${HOMEPAGE}${P}.tar.gz"

LICENSE="GPL-2"
SLOT=0
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc examples static-libs"

PATCHES=( "${FILESDIR}/${P}-shared.patch" )

src_prepare() {
	append-cflags -std=gnu89
	default
	eautoreconf
}

src_install() {
	default
	use doc && dodoc doc/${PN}.pdf
	if use examples; then
		rm examples/Makefile* || die
		insinto /usr/share/doc/${PF}
		doins -r examples
	fi
}
