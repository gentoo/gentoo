# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_5,3_6} )

inherit distutils-r1 flag-o-matic fortran-2 toolchain-funcs

DESCRIPTION="Markov Chain Monte Carlo sampling toolkit"
HOMEPAGE="https://github.com/${PN}-devs/${PN} https://pypi.org/project/${PN}"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.zip"

SLOT=0
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
LICENSE=AFL-3.0
IUSE="test"

RDEPEND=">=dev-python/numpy-1.6[${PYTHON_USEDEP},lapack]
	>=dev-python/matplotlib-1.0[${PYTHON_USEDEP}]"
DEPEND="
	test? (
		${RDEPEND}
		dev-python/nose[${PYTHON_USEDEP}]
	)"

PATCHES=( "${FILESDIR}/${PN}-2.3.6-remove-hardcoded-blas.patch" )

# tests freeze at some point
#RESTRICT="test"

python_prepare_all() {
	# forcibly remove bundled libs, just to be sure...
	rm -r blas || die

	distutils-r1_python_prepare_all
}

python_configure_all() {
	append-fflags -fPIC
	append-ldflags -shared

	[[ $(tc-getFC) == *gfortran* ]] && mydistutilsargs=( config_fc --fcompiler=gnu95 )
}

python_test() {
	distutils_install_for_testing
	cd "${TEST_DIR}" || die
	# Use agg backend instead of gtk
	echo 'backend      : agg' > matplotlibrc || die

	${EPYTHON} -c "import pymc; pymc.test()" || die "Tests failed on ${EPYTHON}"
}
