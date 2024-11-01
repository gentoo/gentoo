# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=standalone
PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( python3_{10..13} pypy3 )

inherit distutils-r1 pypi

MY_P=${P/_/}
DESCRIPTION="Bootstrap-based Sphinx theme from the PyData community"
HOMEPAGE="
	https://github.com/pydata/pydata-sphinx-theme/
	https://pypi.org/project/pydata-sphinx-theme/
"
SRC_URI="
	https://github.com/pydata/pydata-sphinx-theme/archive/v${PV/_/}.tar.gz
		-> ${P}.gh.tar.gz
	$(pypi_wheel_url)
"
S=${WORKDIR}/${MY_P}

LICENSE="BSD-with-disclosure"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

RDEPEND="
	dev-python/accessible-pygments[${PYTHON_USEDEP}]
	dev-python/Babel[${PYTHON_USEDEP}]
	dev-python/beautifulsoup4[${PYTHON_USEDEP}]
	dev-python/docutils[${PYTHON_USEDEP}]
	>=dev-python/pygments-2.7[${PYTHON_USEDEP}]
	>=dev-python/sphinx-6.1[${PYTHON_USEDEP}]
	dev-python/typing-extensions[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/pytest-regressions[${PYTHON_USEDEP}]
	)
"

EPYTEST_XDIST=1
distutils_enable_tests pytest

EPYTEST_DESELECT=(
	# pygments version mismatch?
	'tests/test_build.py::test_pygments_fallbacks[real]'
	# Requires sphinx-intl
	'tests/test_build.py::test_translations'
)

python_compile() {
	distutils_wheel_install "${BUILD_DIR}/install" \
		"${DISTDIR}/$(pypi_wheel_name)"
}
