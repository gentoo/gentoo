# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="C routines for finding cliques in an arbitrary weighted graph"

# autocliquer is a fork of cliquer (whose last release was in 2010) by
# one of the SageMath developers with an autotools build system.
HOMEPAGE="https://users.aalto.fi/~pat/cliquer.html
	https://github.com/dimpase/autocliquer"

# The default github tarball doesn't contain the generated autotools files (like
# the ./configure script), but this is a manual upload
SRC_URI="https://github.com/dimpase/autocliquer/releases/download/v${PV}/${P}.tar.gz"

# The README has "or (at your option) any later version"
LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~riscv ~x86"
IUSE="static-libs"

src_configure() {
	econf $(use_enable static-libs static)
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
