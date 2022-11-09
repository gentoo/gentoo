# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8,9,10} )
ADA_COMPAT=( gnat_202{0,1} gcc_12_2_0 )

DISTUTILS_USE_SETUPTOOLS=no
inherit distutils-r1 ada multiprocessing

DESCRIPTION="A Python framework to generate language parsers"
HOMEPAGE="https://www.adacore.com/community"
SRC_URI="https://github.com/AdaCore/${PN}/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE="+shared static-libs static-pic"
REQUIRED_USE="${PYTHON_REQUIRED_USE}
	${ADA_REQUIRED_USE}
	|| ( shared static-libs static-pic )"

RDEPEND="${PYTHON_DEPS}
	${ADA_DEPS}
	dev-ada/gnatcoll-bindings[${ADA_USEDEP},gmp,iconv,shared?,static-libs?,static-pic?]
	dev-python/mako[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/funcy[${PYTHON_USEDEP}]
	dev-python/docutils[${PYTHON_USEDEP}]
	dev-ada/e3-core[${PYTHON_USEDEP}]"
BDEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}"/${P}-abc.patch )

python_prepare_all() {
	distutils-r1_python_prepare_all
	cd testsuite/tests

	# missing gprbuild option to build libraries static/relocatable
	rm -r {langkit_support,adalog,misc/link_two_libs} || die

	# require railroad-diagrams
	rm -r contrib/svg_railroad_diagrams || die
}

python_compile_all() {
	build () {
		gprbuild -j$(makeopts_jobs) -p -v \
			-XLIBRARY_TYPE=$1 -P support/langkit_support.gpr -XBUILD_MODE=dev \
			-cargs:Ada ${ADAFLAGS} -cargs:C ${CFLAGS} || die "gprbuild failed"
	}
	if use shared; then
		build relocatable
	fi
	if use static-libs; then
		build static
	fi
	if use static-pic; then
		build static-pic
	fi
}

python_test_all() {
	export GPR_PROJECT_PATH="${S}"/support
	${EPYTHON} ./manage.py make --no-langkit-support || die
	eval $(./manage.py setenv)
	${EPYTHON} ./manage.py test --verbose |& tee langkit.testOut
	grep -qw FAIL langkit.testOut && die
}

python_install_all() {
	build () {
		gprinstall -v -P support/langkit_support.gpr -p -XBUILD_MODE=dev \
			--prefix="${D}"/usr --build-var=LIBRARY_TYPE \
			--build-var=LANGKIT_SUPPORT_LIBRARY_TYPE \
			--sources-subdir=include/langkit_support \
			-XLIBRARY_TYPE=$1 --build-name=$1 || die
	}
	if use shared; then
		build relocatable
	fi
	if use static-libs; then
		build static
	fi
	if use static-pic; then
		build static-pic
	fi
}
