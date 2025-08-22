# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{11..13} )

inherit distutils-r1 pypi virtualx

DESCRIPTION="An ultra fast cross-platform multiple screenshots module in python using ctypes"
HOMEPAGE="
	https://github.com/BoboTiG/python-mss/
	https://pypi.org/project/mss/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~riscv ~x86"

BDEPEND="
	test? (
		dev-python/pyvirtualdisplay[${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGINS=( pytest-rerunfailures )
distutils_enable_tests pytest

EPYTEST_IGNORE=(
	# upstream tests for self-build, apparently broken by setuptools
	# issuing deprecation warnings
	src/tests/test_setup.py
)

EPYTEST_DESELECT=(
	# unreliable `lsof -U | grep ...` tests
	src/tests/test_leaks.py
)

src_prepare() {
	distutils-r1_src_prepare
	sed -i -e '/--cov/d' pyproject.toml || die
}

src_test() {
	virtx distutils-r1_src_test
}
