# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{12..13} )
ADA_COMPAT=( gcc_{12..16} )

DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1 ada multiprocessing

DESCRIPTION="A Python framework to generate language parsers"
HOMEPAGE="https://www.adacore.com/community"
SRC_URI="https://github.com/AdaCore/${PN}/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0/${PV}"
KEYWORDS="amd64 ~arm64 x86"
IUSE="static-libs static-pic"
REQUIRED_USE="${PYTHON_REQUIRED_USE}
	${ADA_REQUIRED_USE}"
RESTRICT="test"

RDEPEND="${PYTHON_DEPS}
	${ADA_DEPS}
	dev-ada/AdaSAT[${ADA_USEDEP},shared(+),static-libs?,static-pic?]
	dev-ada/gnatcoll-bindings:=[${ADA_USEDEP},gmp,iconv(+)]
	dev-ada/gnatcoll-bindings[shared,static-libs?,static-pic?]
	dev-ada/gnatcoll-core:=[${ADA_USEDEP},shared,static-libs?,static-pic?]
	dev-ada/prettier-ada:=[${ADA_USEDEP},shared,static-libs?,static-pic?]
	dev-ada/vss-text:=[${ADA_USEDEP},shared(+),static-libs?,static-pic?]
	dev-python/docutils[${PYTHON_USEDEP}]
	dev-python/funcy[${PYTHON_USEDEP}]
	dev-python/mako[${PYTHON_USEDEP}]
	dev-python/mypy[${PYTHON_USEDEP}]"
BDEPEND="${RDEPEND}
	dev-ada/gprbuild[${ADA_USEDEP}]"

PATCHES=( "${FILESDIR}"/${P}-python3_13.patch )

distutils_enable_sphinx doc

python_compile_all() {
	build () {
		rm -f langkit/support/obj/dev/*lexch
		gprbuild -v -p -j$(makeopts_jobs) \
			-P langkit/support/langkit_support.gpr -XLIBRARY_TYPE=$1 \
			-cargs:Ada ${ADAFLAGS} -cargs:C ${CFLAGS} || die
	}
	build relocatable
	use static-libs && build static
	use static-pic  && build static-pic
	gprbuild -v -p -j$(makeopts_jobs) \
		-P sigsegv_handler/langkit_sigsegv_handler.gpr \
		-cargs:Ada ${ADAFLAGS} -cargs:C ${CFLAGS} || die
	sphinx_compile_all
}

python_install_all() {
	build () {
		gprinstall -v -P langkit/support/langkit_support.gpr -p \
			--prefix="${D}"/usr --build-var=LIBRARY_TYPE \
			--build-var=LANGKIT_SUPPORT_LIBRARY_TYPE \
			--sources-subdir=include/langkit_support \
			-XLIBRARY_TYPE=$1 --build-name=$1 || die
	}
	build relocatable
	use static-libs && build static
	use static-pic  && build static-pic
	gprinstall -v -P sigsegv_handler/langkit_sigsegv_handler.gpr -p \
		--prefix="${D}"/usr || die
	einstalldocs
}
