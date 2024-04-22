# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{10..12} )
PYTHON_REQ_USE="threads(+)"

inherit distutils-r1

DESCRIPTION="Fast numerical array expression evaluator for Python and NumPy"
HOMEPAGE="
	https://github.com/pydata/numexpr/
	https://pypi.org/project/numexpr/
"
SRC_URI="https://github.com/pydata/numexpr/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0"

DEPEND="
	>=dev-python/numpy-2.0.0_rc:=[${PYTHON_USEDEP}]
"
RDEPEND="
	${DEPEND}
	dev-python/packaging[${PYTHON_USEDEP}]
"

src_prepare() {
	# broken with > 8 CPU threads?
	# https://github.com/pydata/numexpr/issues/479
	sed -e 's:test_numexpr_max_threads_empty_string:_&:' \
		-e 's:test_omp_num_threads_empty_string:_&:' \
		-i numexpr/tests/test_numexpr.py || die

	distutils-r1_src_prepare
}

python_test() {
	pushd "${BUILD_DIR}/install/$(python_get_sitedir)" >/dev/null || die
	"${EPYTHON}" - <<-EOF || die "Tests failed with ${EPYTHON}"
		import sys,numexpr
		sys.exit(0 if numexpr.test(verbosity=2).wasSuccessful() else 1)
	EOF
	pushd >/dev/null || die
}
