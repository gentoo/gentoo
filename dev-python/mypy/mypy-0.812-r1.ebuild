# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1

DESCRIPTION="Optional static typing for Python"
HOMEPAGE="http://www.mypy-lang.org/"
TYPESHED_COMMIT="add4d92f050fb11d3901c6f0ee579a122d4a7a98"
SRC_URI="
	https://github.com/python/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/python/typeshed/archive/${TYPESHED_COMMIT}.tar.gz
		-> typeshed-${TYPESHED_COMMIT}.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~ia64 ppc ppc64 sparc x86"

# stubgen collides with this package: https://bugs.gentoo.org/585594
RDEPEND="
	!dev-util/stubgen
	>=dev-python/psutil-4[${PYTHON_USEDEP}]
	>=dev-python/typed-ast-1.4.0[${PYTHON_USEDEP}]
	<dev-python/typed-ast-1.5.0[${PYTHON_USEDEP}]
	>=dev-python/typing-extensions-3.7.4[${PYTHON_USEDEP}]
	>=dev-python/mypy_extensions-0.4.3[${PYTHON_USEDEP}]
	<dev-python/mypy_extensions-0.5.0[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		>=dev-python/attrs-18.0[${PYTHON_USEDEP}]
		>=dev-python/lxml-4.4.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-6.1.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-xdist-1.18[${PYTHON_USEDEP}]
		>=dev-python/py-1.5.2[${PYTHON_USEDEP}]
		>=dev-python/virtualenv-16.0.0[${PYTHON_USEDEP}]
	)
"

distutils_enable_sphinx docs/source dev-python/sphinx_rtd_theme
distutils_enable_tests pytest

src_unpack() {
	default
	rmdir "${S}/mypy/typeshed" || die
	mv "${WORKDIR}/typeshed-${TYPESHED_COMMIT}" "${S}/mypy/typeshed" || die

	export MYPY_USE_MYPYC=0
}

python_test() {
	# Some mypy/test/testcmdline.py::PythonCmdlineSuite tests
	# fail with high COLUMNS values
	local -x COLUMNS=80
	epytest -n "$(makeopts_jobs "${MAKEOPTS}" "$(get_nproc)")"
}
