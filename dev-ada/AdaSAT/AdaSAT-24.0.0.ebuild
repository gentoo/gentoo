# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
ADA_COMPAT=( gcc_12 gcc_13 )

inherit ada multiprocessing

DESCRIPTION="Implementation of a DPLL-based SAT solver in Ada"
HOMEPAGE="https://github.com/AdaCore/AdaSAT"
SRC_URI="https://github.com/AdaCore/${PN}/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+shared static-libs static-pic test"

DEPEND="dev-ada/gprbuild[${ADA_USEDEP}]"
REQUIRED_USE="${ADA_REQUIRED_USE}
	|| ( shared static-libs static-pic )
	test? ( static-libs )"
RESTRICT="!test? ( test )"

src_compile() {
	build () {
		gprbuild -P adasat.gpr -p -v -j$(makeopts_jobs) \
			--relocate-build-tree="." -XLIBRARY_TYPE=$1 \
			-XBUILD_MODE=dev -cargs:Ada ${ADAFLAGS} || die
	}

	use shared && build relocatable
	use static-libs && build static
	use static-pic && build static-pic
}

src_install() {
	build () {
		gprinstall -P adasat.gpr -p -f -XLIBRARY_TYPE=$1 -XBUILD_MODE=dev -v \
			--relocate-build-tree="." --prefix="${ED}"/usr --build-name=$1 \
			--build-var=LIBRARY_TYPE || die
	}
	use shared && build relocatable
	use static-libs && build static
	use static-pic && build static-pic

	rm -r "${D}"/usr/share/gpr/manifests || die
	einstalldocs
}

src_test() {
	export ADA_PROJECT_PATH="${S}"
	python3 testsuite/testsuite.py || die
}
