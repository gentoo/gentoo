# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

FORTRAN_NEEDED=fortran

inherit autotools fortran-2

DESCRIPTION="Quad-double and double-double float arithmetics"
HOMEPAGE="http://crd-legacy.lbl.gov/~dhbailey/mpdist/"
SRC_URI="http://crd.lbl.gov/~dhbailey/mpdist/${P}.tar.gz"

SLOT="0"
LICENSE="BSD"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="cpu_flags_x86_fma3 cpu_flags_x86_fma4 doc fortran static-libs"

PATCHES=( "${FILESDIR}"/${P}-fix-build-system.patch )

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		--disable-ieee-add \
		--disable-sloppy-mul \
		--disable-sloppy-div \
		--enable-inline \
		--enable-shared \
		$(use_enable static-libs static) \
		$(use_enable cpu_flags_x86_fma$(usex cpu_flags_x86_fma3 3 4) fma) \
		$(use_enable fortran)
}

src_install() {
	default

	dosym qd_real.h /usr/include/qd/qd.h
	dosym dd_real.h /usr/include/qd/dd.h

	if ! use doc; then
		rm "${ED%/}"/usr/share/doc/${PF}/*.pdf || die
	fi

	if ! use static-libs; then
		find "${D}" -name '*.la' -delete || die
	fi
}
