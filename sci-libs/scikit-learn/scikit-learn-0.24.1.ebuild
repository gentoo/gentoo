# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6..9} )
DISTUTILS_USE_SETUPTOOLS=no
DISTUTILS_IN_SOURCE_BUILD=1
inherit distutils-r1

DESCRIPTION="Machine learning library for Python"
HOMEPAGE="https://scikit-learn.org/stable/"
SRC_URI="https://github.com/scikit-learn/scikit-learn/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"
IUSE="examples"

DEPEND="
	virtual/blas:=
	virtual/cblas:=
"
RDEPEND="
	${DEPEND}
	dev-python/wheel[${PYTHON_USEDEP}]
	dev-python/cython[${PYTHON_USEDEP}]
	dev-python/joblib[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/scipy[${PYTHON_USEDEP}]
	dev-python/threadpoolctl[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

PATCHES=( "${FILESDIR}"/${P}-no-O3.patch )

python_test() {
	distutils_install_for_testing
	# manually run tests as they need some weird thingies
	# skip tests which need data files that are not installed
	local tfile
	for tfile in sklearn/tests/test_*.py ; do
		if [[ "${tfile}" =~ "test_multiclass.py" ||
		      "${tfile}" =~ "test_multioutput.py" ||
		      "${tfile}" =~ "test_pipeline.py" ]]; then
			continue
		fi
		elog "Testing: ${tfile}"
		${EPYTHON} "${tfile}" || die "tests failed for ${tfile} with ${EPYTHON}"
	done
}

python_install_all() {
	find "${S}" -name \*LICENSE.txt -delete || die
	distutils-r1_python_install_all
	use examples && dodoc -r examples
}
