# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{10..12} )

inherit distutils-r1 pypi

DESCRIPTION="Automatically conversion of .ini/.cfg files to TOML equivalents"
HOMEPAGE="
	https://pypi.org/project/ini2toml/
	https://github.com/abravalheri/ini2toml/
"

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"

RDEPEND="
	>=dev-python/packaging-20.7[${PYTHON_USEDEP}]
	>=dev-python/setuptools-59.6[${PYTHON_USEDEP}]
	>=dev-python/tomli-w-0.4.0[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/setuptools-scm[${PYTHON_USEDEP}]
	test? (
		dev-python/configupdater[${PYTHON_USEDEP}]
		>=dev-python/pyproject-fmt-0.4.0[${PYTHON_USEDEP}]
		dev-python/tomli[${PYTHON_USEDEP}]
		dev-python/tomlkit[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

EPYTEST_IGNORE=(
	# validate_pyproject is not packaged
	tests/test_examples.py
)

src_prepare() {
	sed -i -e 's:--cov ini2toml --cov-report term-missing::' setup.cfg || die
	distutils-r1_src_prepare
}
