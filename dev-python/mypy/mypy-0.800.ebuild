# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1

DESCRIPTION="Optional static typing for Python"
HOMEPAGE="http://www.mypy-lang.org/"
# One module is missing from the PyPI tarball
# https://github.com/python/mypy/pull/9587
# conftest.py is missing at the moment
# https://github.com/python/mypy/pull/9543
TYPESHED_COMMIT="8cad322a8ccf4b104cafbac2c798413edaa4f327"
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
}

python_test() {
	# Some mypy/test/testcmdline.py::PythonCmdlineSuite tests
	# fail with high COLUMNS values
	local -x COLUMNS=80
	pytest -vv -n "$(makeopts_jobs "${MAKEOPTS}" "$(get_nproc)")" ||
		die "Tests failed with ${EPYTHON}"
}
