# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

AUTOTOOLS_AUTORECONF=true

inherit autotools-utils flag-o-matic fortran-2 multilib

MY_P=${P//_/-}

DESCRIPTION="A library of exchange-correlation functionals for use in DFT"
HOMEPAGE="https://octopus-code.org/wiki/Libxc"
SRC_URI="https://www.tddft.org/programs/octopus/download/${PN}/${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux"
IUSE="fortran static-libs -test"

S="${WORKDIR}"/${MY_P}

pkg_setup() {
	use fortran && fortran-2_pkg_setup
}

src_prepare() {
	sed \
		-e "s:${PN}.f90:${PN}.F90:g" \
		-i src/Makefile.am || die
	autotools-utils_src_prepare
}

src_configure() {
	local myeconfargs=( $(use_enable fortran) )
	autotools-utils_src_configure
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
	autotools-utils_src_install

}
