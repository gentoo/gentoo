# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Multiple precision interval arithmetic library based on MPFR"
HOMEPAGE="http://perso.ens-lyon.fr/nathalie.revol/software.html"
SRC_URI="https://gforge.inria.fr/frs/download.php/file/38111/${P}.tgz"

# COPYING is GPL-3, COPYING.LESSER is LGPL-3, source file headers
# are LGPL-2.1+
LICENSE="GPL-3 LGPL-3 LGPL-2.1+"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~x86 ~amd64-linux ~x86-linux"

DEPEND="
	dev-libs/gmp:0=
	dev-libs/mpfr:0="
RDEPEND="${DEPEND}"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf --disable-static
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
