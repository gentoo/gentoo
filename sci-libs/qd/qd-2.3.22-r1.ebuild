# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

FORTRAN_NEEDED=fortran

inherit autotools fortran-2

DESCRIPTION="Quad-double and double-double float arithmetics"
HOMEPAGE="https://www.davidhbailey.com/dhbsoftware/"
SRC_URI="http://crd.lbl.gov/~dhbailey/mpdist/${P}.tar.gz"

SLOT="0"
LICENSE="BSD"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="cpu_flags_x86_fma3 cpu_flags_x86_fma4 doc fortran"

PATCHES=(
	"${FILESDIR}/0001-configure.ac-update-QD_PATCH_VERSION-to-2.3.22.patch"
	"${FILESDIR}/0002-configure.ac-replace-AM_CONFIG_HEADER-with-AC_CONFIG.patch"
	"${FILESDIR}/0003-configure.ac-replace-AC_PROG_LIBTOOL-with-LT_INIT.patch"
	"${FILESDIR}/0004-configure.ac-fix-syntax-of-all-AC_ARG_ENABLE-calls.patch"
	"${FILESDIR}/0005-fortran-Makefile.am-fix-underlinking-of-libqdmod-and.patch"
	"${FILESDIR}/0006-configure.ac-remove-enable-debug-flag.patch"
	"${FILESDIR}/0007-config.h.in-remove-QD_DEBUG-constant.patch"
	"${FILESDIR}/0008-configure.ac-don-t-assume-that-O2-is-a-valid-compile.patch"
	"${FILESDIR}/0009-configure.ac-don-t-set-CC-to-CXX.patch"
	"${FILESDIR}/0010-configure.ac-don-t-manually-search-for-compiler-name.patch"
	"${FILESDIR}/0011-qd-config.in-remove-REQ_CXXFLAGS.patch"
	"${FILESDIR}/0012-configure.ac-remove-the-enable-warnings-flag.patch"
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		--disable-static \
		--disable-ieee-add \
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
