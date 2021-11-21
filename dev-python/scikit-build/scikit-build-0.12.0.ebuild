# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

DESCRIPTION="Improved build system generator for Python C/C++/Fortran/Cython extensions"
HOMEPAGE="https://github.com/scikit-build/scikit-build"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="MIT"
KEYWORDS="amd64 arm arm64 ~hppa ~ia64 ppc ppc64 ~riscv ~s390 ~sparc x86"

RDEPEND="
	dev-python/distro[${PYTHON_USEDEP}]
	dev-python/packaging[${PYTHON_USEDEP}]
	dev-python/wheel[${PYTHON_USEDEP}]"

DEPEND="
	test? (
		dev-python/cython[${PYTHON_USEDEP}]
		dev-python/path-py[${PYTHON_USEDEP}]
		dev-python/pytest-mock[${PYTHON_USEDEP}]
		dev-python/pytest-virtualenv[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
		dev-python/six[${PYTHON_USEDEP}]
		dev-python/virtualenv[${PYTHON_USEDEP}]
	)"

PATCHES=(
	"${FILESDIR}"/${PN}-0.12.0-tests-no-coverage.patch
)

distutils_enable_sphinx docs \
	dev-python/sphinx_rtd_theme \
	dev-python/sphinx-issues
distutils_enable_tests pytest

src_prepare() {
	# not packaged
	sed -i -e '/cmakedomain/d' docs/conf.py || die
	distutils-r1_src_prepare
}

python_test() {
	local deselect=(
		# sandbox violations
		tests/test_hello_cpp.py::test_hello_develop
		tests/test_issue274_support_default_package_dir.py
		tests/test_issue274_support_one_package_without_package_dir.py
		tests/test_issue334_configure_cmakelists_non_cp1252_encoding.py
	)
	epytest ${deselect[@]/#/--deselect }
}
