# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit out-of-source

DESCRIPTION="Multiple precision interval arithmetic library based on MPFR"
HOMEPAGE="http://perso.ens-lyon.fr/nathalie.revol/software.html"
SRC_URI="https://gforge.inria.fr/frs/download.php/37331/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="static-libs"

DEPEND="
	>=dev-libs/gmp-4.1.2:0=
	>=dev-libs/mpfr-2.4:0="
RDEPEND="${DEPEND}"

my_src_configure() {
	ECONF_SOURCE="${S}" econf \
		$(use_enable static-libs static)
}

my_src_install() {
	default

	if ! use static-libs; then
		find "${D}" -name '*.la' -delete || die
	fi
}
