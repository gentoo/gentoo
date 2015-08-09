# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit fortran-2 autotools-utils

DESCRIPTION="Guile-based library for scientific simulations"
HOMEPAGE="http://ab-initio.mit.edu/libctl/"
SRC_URI="http://ab-initio.mit.edu/libctl/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="amd64 x86"
IUSE="doc examples static-libs"

DEPEND="
	dev-scheme/guile[deprecated]
	sci-libs/nlopt"
RDEPEND="${DEPEND}"

src_install() {
	autotools-utils_src_install
	use doc && dohtml doc/*
	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins "${AUTOTOOLS_BUILD_DIR}"/examples/{*.c,*.h,example.scm,Makefile}
		doins "${S}"/examples/{README,example.c,run.ctl}
	fi
}
