# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

FORTRAN_NEEDED=fortran

inherit fortran-2

DESCRIPTION="Quad-double and double-double float arithmetics"
HOMEPAGE="https://www.davidhbailey.com/dhbsoftware/"
SRC_URI="https://www.davidhbailey.com/dhbsoftware/${P}.tar.gz"

SLOT="0"
LICENSE="BSD"
KEYWORDS="amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="cpu_flags_x86_fma3 cpu_flags_x86_fma4 doc fortran"

src_configure() {
	econf \
		--disable-static \
		--enable-ieee-add \
		--disable-sloppy-mul \
		--disable-sloppy-div \
		--enable-inline \
		$(use_enable cpu_flags_x86_fma$(usex cpu_flags_x86_fma3 3 4) fma) \
		$(use_enable fortran)
}

src_install() {
	default

	dosym qd_real.h /usr/include/qd/qd.h
	dosym dd_real.h /usr/include/qd/dd.h

	if ! use doc; then
		rm "${ED}"/usr/share/doc/${PF}/*.pdf || die
	fi

	find "${D}" -name '*.la' -delete || die
}
