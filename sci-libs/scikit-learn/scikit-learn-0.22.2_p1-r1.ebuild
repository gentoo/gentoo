# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8} )
inherit distutils-r1

MY_PV="${PV//_p/.post}"

DESCRIPTION="Machine learning library for Python"
HOMEPAGE="https://scikit-learn.org/stable/"
SRC_URI="https://github.com/scikit-learn/scikit-learn/archive/${MY_PV}.tar.gz -> ${P}.tar.gz"
#ffhttps://github.com/scikit-learn/scikit-learn/archive/0.22.2.post1.tar.gz
S="${WORKDIR}/${PN}-${MY_PV}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~ppc64 x86"
IUSE="examples"

RDEPEND="
	dev-python/wheel[${PYTHON_USEDEP}]
	dev-python/cython[${PYTHON_USEDEP}]
	dev-python/joblib[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/scipy[${PYTHON_USEDEP}]
	virtual/blas:=
	virtual/cblas:=
"
DEPEND="
	virtual/blas:=
	virtual/cblas:=
"

distutils_enable_tests pytest

python_prepare_all() {
	# scikits-learn now uses the horrible numpy.distutils automagic
	export SCIPY_FCONFIG="config_fc --noopt --noarch"

	# remove bundled cblas
	rm -rf sklearn/src || die "failed to remove bundled cblas"

	distutils-r1_python_prepare_all
}

python_compile() {
	distutils-r1_python_compile ${SCIPY_FCONFIG}
}

python_test() {
	distutils_install_for_testing ${SCIPY_FCONFIG}
	pushd "${TEST_DIR}/lib" >/dev/null || die
	pytest -vv || die "testing failed with ${EPYTHON}"
	popd >/dev/null || die
}

python_install() {
	distutils-r1_python_install ${SCIPY_FCONFIG}
}

python_install_all() {
	find "${S}" -name \*LICENSE.txt -delete
	distutils-r1_python_install_all
	if use examples; then
		dodoc -r examples
		docompress -x /usr/share/doc/${PF}/examples
	fi

}
