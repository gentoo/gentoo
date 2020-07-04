# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Expose the functionality of cbraid as a shared library"
HOMEPAGE="https://github.com/miguelmarco/libbraiding"

# The github release is missing the generated autotools files, like the
# ./configure script. Rather than involve autotools.eclass, let's just
# get it from sage.
SRC_URI="http://files.sagemath.org/spkg/upstream/${PN}/${P}.tar.gz"

# A few source headers still say GPLv2, but I believe that to be an
# oversight: https://github.com/jeanluct/cbraid/issues/4
LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64"
IUSE="static-libs"

src_configure() {
	econf $(use_enable static-libs static)
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
