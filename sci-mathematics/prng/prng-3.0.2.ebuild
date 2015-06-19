# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-mathematics/prng/prng-3.0.2.ebuild,v 1.7 2012/07/06 23:46:37 bicatali Exp $

EAPI=4

AUTOTOOLS_AUTORECONF=yes

inherit autotools-utils

DESCRIPTION="Pseudo-Random Number Generator library"
HOMEPAGE="http://statmath.wu.ac.at/prng/"
SRC_URI="${HOMEPAGE}${P}.tar.gz"

LICENSE="GPL-2"
SLOT=0
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="doc examples static-libs"

PATCHES=( "${FILESDIR}"/${P}-shared.patch )

src_install() {
	autotools-utils_src_install
	use doc && dodoc doc/${PN}.pdf
	if use examples; then
		rm examples/Makefile*
		insinto /usr/share/doc/${PF}
		doins -r examples
	fi
}
