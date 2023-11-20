# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( pypy3 python3_{10..12} )

inherit distutils-r1 pypi

DESCRIPTION="Improved build system generator for Python C/C++/Fortran/Cython extensions"
HOMEPAGE="
	https://github.com/scikit-build/scikit-build/
	https://pypi.org/project/scikit-build/
"

SLOT="0"
LICENSE="MIT"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ppc ppc64 ~riscv ~s390 sparc x86"

RDEPEND="
	dev-python/distro[${PYTHON_USEDEP}]
	dev-python/packaging[${PYTHON_USEDEP}]
	>=dev-python/setuptools-42.0.0[${PYTHON_USEDEP}]
	$(python_gen_cond_dep '
		dev-python/tomli[${PYTHON_USEDEP}]
	' 3.{9..10})
	>=dev-python/wheel-0.32.0[${PYTHON_USEDEP}]
"

BDEPEND="
	dev-python/hatch-fancy-pypi-readme[${PYTHON_USEDEP}]
	dev-python/hatch-vcs[${PYTHON_USEDEP}]
	test? (
		>=dev-python/build-0.7[${PYTHON_USEDEP}]
		>=dev-python/cython-0.25.1[${PYTHON_USEDEP}]
		>=dev-python/pytest-mock-1.10.4[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
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
	local EPYTEST_DESELECT=()

	case ${EPYTHON} in
		pypy3)
			EPYTEST_DESELECT+=(
				# no "library" in (our install of) pypy3
				tests/test_cmaker.py::test_get_python_library
			)
			;;
	esac

	epytest -m "not isolated and not nosetuptoolsscm"
	rm -r "${BUILD_DIR}/install$(python_get_sitedir)"/{easy-install.pth,*.egg,*.egg-link} || die
}
