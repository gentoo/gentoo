# Copyright 2022-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..15} )

inherit distutils-r1 pypi

DESCRIPTION="Automatically conversion of .ini/.cfg files to TOML equivalents"
HOMEPAGE="
	https://pypi.org/project/ini2toml/
	https://github.com/abravalheri/ini2toml/
"

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"

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

EPYTEST_PLUGINS=()
distutils_enable_tests pytest

python_test() {
	local EPYTEST_IGNORE=(
		# validate_pyproject is not packaged
		tests/test_examples.py
	)
	local EPYTEST_DESELECT+=(
		# Incompatible with pyproject-fmt-2 API:
		# https://github.com/abravalheri/ini2toml/issues/103
		tests/test_cli.py::test_auto_formatting

		# Upstream regressions with setuptools.
		tests/plugins/test_setuptools_pep621.py::test_handle_license
		tests/plugins/test_setuptools_pep621.py::test_handle_license_and_files
	)

	epytest -o addopts=
}
