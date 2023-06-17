# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1 pypi

DESCRIPTION="Improved build system generator for Python C/C++/Fortran/Cython extensions"
HOMEPAGE="
	https://github.com/scikit-build/scikit-build/
	https://pypi.org/project/scikit-build/
"

SLOT="0"
LICENSE="MIT"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ppc ppc64 ~riscv ~s390 sparc x86"

RDEPEND="
	dev-python/distro[${PYTHON_USEDEP}]
	dev-python/packaging[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/wheel[${PYTHON_USEDEP}]
"

BDEPEND="
	test? (
		dev-python/cython[${PYTHON_USEDEP}]
		dev-python/pytest-mock[${PYTHON_USEDEP}]
		dev-python/pytest-virtualenv[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
		dev-python/six[${PYTHON_USEDEP}]
		dev-python/virtualenv[${PYTHON_USEDEP}]
	)
"

distutils_enable_sphinx docs \
	dev-python/sphinx-rtd-theme \
	dev-python/sphinx-issues
distutils_enable_tests pytest

src_prepare() {
	# not packaged
	sed -i -e '/cmakedomain/d' docs/conf.py || die
	distutils-r1_src_prepare
}

python_test() {
	local EPYTEST_DESELECT=(
		# sandbox violations
		tests/test_hello_cpp.py::test_hello_develop
		tests/test_issue274_support_default_package_dir.py
		tests/test_issue274_support_one_package_without_package_dir.py
		tests/test_issue334_configure_cmakelists_non_cp1252_encoding.py
		tests/test_pep518.py
		# This fails because of additional item setup.py in sources
		tests/test_include_exclude_data.py::test_hello_sdist
		tests/test_include_exclude_data.py::test_hello_sdist_with_base
		tests/test_issue401_sdist_with_symlinks.py::test_sdist_with_symlinks
		tests/test_manifest_in.py::test_manifest_in_sdist
		# Wants internet to install things with pip
		tests/test_numpy.py::test_pep518_findpython
		# TODO
		"tests/test_command_line.py::test_hide_listing[True-bdist_wheel]"
	)
	epytest
}
