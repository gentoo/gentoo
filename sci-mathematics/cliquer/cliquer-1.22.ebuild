# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="C routines for finding cliques in an arbitrary weighted graph"

# autocliquer is a fork of cliquer (whose last release was in 2010) by
# one of the SageMath developers with an autotools build system.
HOMEPAGE="https://users.aalto.fi/~pat/cliquer.html
	https://github.com/dimpase/autocliquer"

# The github tarball doesn't contain the generated autotools files (like
# the ./configure script).
SRC_URI="http://files.sagemath.org/spkg/upstream/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static-libs"

src_configure() {
	econf $(use_enable static-libs static)
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
