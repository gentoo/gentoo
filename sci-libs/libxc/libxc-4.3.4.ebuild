# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools fortran-2

DESCRIPTION="A library of exchange-correlation functionals for use in DFT"
HOMEPAGE="http://octopus-code.org/wiki/Libxc"
SRC_URI="https://gitlab.com/libxc/libxc/-/archive/${PV}/${P}.tar.gz"

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux"
IUSE="fortran static-libs -test"

pkg_setup() {
	use fortran && fortran-2_pkg_setup
}

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf --enable-shared \
		$(use_enable fortran) \
		$(use_enable static-libs static)
}

## Upstream recommends not running the test suite because it requires
## human expert interpretation to determine whether output is an error or
## expected under certain circumstances. Nevertheless, experts might want the option.
# The autotools src_test function modified not to die. Runs emake check in build directory.
src_test() {
	debug-print-function ${FUNCNAME} "$@"

	_check_build_dir
	pushd "${BUILD_DIR}" > /dev/null || die
	make check || ewarn "Make check failed. See above for details."
	einfo "emake check done"
	popd > /dev/null || die
}

src_install() {
	default
	find "${ED}" -name '*.la' -type f -delete || die
	if ! use fortran; then
		rm "${ED}"/usr/$(get_libdir)/pkgconfig/libxcf{03,90}.pc || die
	fi
}
