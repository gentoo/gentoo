# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools fortran-2

DESCRIPTION="A library of exchange-correlation functionals for use in DFT"
HOMEPAGE="https://octopus-code.org/wiki/Libxc"
SRC_URI="https://gitlab.com/libxc/libxc/-/archive/${PV}/${P}.tar.gz"

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux"
IUSE="fortran test"
RESTRICT="!test? ( test )"

pkg_setup() {
	use fortran && fortran-2_pkg_setup
}

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		--enable-shared \
		--disable-static \
		$(use_enable fortran)
}

src_install() {
	default
	dodoc ChangeLog.md

	# no static archives
	find "${ED}" -name '*.la' -type f -delete || die
}
