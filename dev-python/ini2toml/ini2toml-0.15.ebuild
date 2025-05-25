# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3_11 python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="Automatically conversion of .ini/.cfg files to TOML equivalents"
HOMEPAGE="
	https://pypi.org/project/ini2toml/
	https://github.com/abravalheri/ini2toml/
"

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"

RDEPEND="
	>=dev-python/packaging-20.7[${PYTHON_USEDEP}]
	>=dev-python/setuptools-59.6[${PYTHON_USEDEP}]
	>=dev-python/tomli-w-0.4.0[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/setuptools-scm[${PYTHON_USEDEP}]
	test? (
		dev-python/configupdater[${PYTHON_USEDEP}]
		dev-python/tomli[${PYTHON_USEDEP}]
		dev-python/tomlkit[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

src_prepare() {
	sed -i -e 's:--cov ini2toml --cov-report term-missing::' setup.cfg || die
	distutils-r1_src_prepare
}

python_test() {
	local EPYTEST_IGNORE=(
		# validate_pyproject is not packaged
		tests/test_examples.py
	)
	local EPYTEST_DESELECT=()

	# Incompatible with pyproject-fmt-2 API:
	# https://github.com/abravalheri/ini2toml/issues/103
	if ! has_version "<dev-python/pyproject-fmt-2[${PYTHON_USEDEP}]"; then
		EPYTEST_DESELECT+=(
			tests/test_cli.py::test_auto_formatting
		)
	fi

	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest
}
