# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( pypy3_11 python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="Improved build system generator for Python C/C++/Fortran/Cython extensions"
HOMEPAGE="
	https://github.com/scikit-build/scikit-build/
	https://pypi.org/project/scikit-build/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~s390 sparc x86"

RDEPEND="
	dev-python/distro[${PYTHON_USEDEP}]
	dev-python/packaging[${PYTHON_USEDEP}]
	>=dev-python/setuptools-42.0.0[${PYTHON_USEDEP}]
	>=dev-python/wheel-0.32.0[${PYTHON_USEDEP}]
"

BDEPEND="
	dev-python/hatch-fancy-pypi-readme[${PYTHON_USEDEP}]
	dev-python/hatch-vcs[${PYTHON_USEDEP}]
	test? (
		>=dev-python/build-0.7[${PYTHON_USEDEP}]
		>=dev-python/cython-0.25.1[${PYTHON_USEDEP}]
		dev-python/pip[${PYTHON_USEDEP}]
		>=dev-python/pytest-mock-1.10.4[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
		dev-python/virtualenv[${PYTHON_USEDEP}]
	)
"

distutils_enable_sphinx docs \
	dev-python/sphinx-rtd-theme \
	dev-python/sphinx-issues
# note: tests are unstable with xdist
distutils_enable_tests pytest

src_prepare() {
	local PATCHES=(
		# https://github.com/scikit-build/scikit-build/pull/1120
		"${FILESDIR}/${P}-setuptools-75.patch"
	)

	# not packaged
	sed -i -e '/cmakedomain/d' docs/conf.py || die
	distutils-r1_src_prepare
}

python_test() {

	local EPYTEST_DESELECT=(
		# Internet (via new setuptools?)
		tests/test_hello_cpp.py::test_hello_develop
	)

	case ${EPYTHON} in
		pypy3)
			EPYTEST_DESELECT+=(
				# no "library" in (our install of) pypy3
				tests/test_cmaker.py::test_get_python_library
			)
			;;
	esac

	# create a separate test tree since skbuild tests install random stuff
	cp -r "${BUILD_DIR}"/{install,test} || die
	local -x PATH=${BUILD_DIR}/test${EPREFIX}/usr/bin:${PATH}

	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest -p pytest_mock \
		-m "not isolated and not nosetuptoolsscm" \
		-o tmp_path_retention_count=1
}
