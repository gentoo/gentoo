# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{8..10} )

inherit distutils-r1

DESCRIPTION="Automatically conversion of .ini/.cfg files to TOML equivalents"
HOMEPAGE="
	https://pypi.org/project/ini2toml/
	https://github.com/abravalheri/ini2toml/
"
SRC_URI="
	https://github.com/abravalheri/ini2toml/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="~amd64 ~m68k ~riscv ~x86"

RDEPEND="
	>=dev-python/packaging-20.7[${PYTHON_USEDEP}]
	>=dev-python/tomli-w-0.4.0[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/setuptools_scm[${PYTHON_USEDEP}]
	test? (
		dev-python/tomli[${PYTHON_USEDEP}]
		dev-python/tomlkit[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

export SETUPTOOLS_SCM_PRETEND_VERSION=${PV}

PATCHES=(
	"${FILESDIR}"/${P}-test.patch
)

EPYTEST_DESELECT=(
	# pyproject_fmt is not packaged
	tests/test_cli.py::test_auto_formatting

	# fails on whitespace/comments/formatting
	tests/test_translator.py::test_simple_example
	tests/test_translator.py::test_parser_opts
	tests/plugins/test_setuptools_pep621.py::test_move_entry_points_and_apply_value_processing
	tests/plugins/test_setuptools_pep621.py::test_split_subtables
	tests/plugins/test_setuptools_pep621.py::test_entrypoints_and_split_subtables
	tests/plugins/test_setuptools_pep621.py::test_handle_dynamic
)

EPYTEST_IGNORE=(
	# configupdater is not packaged
	tests/test_examples.py
	tests/test_transformations.py
	tests/drivers/test_configupdater.py
)

src_prepare() {
	sed -i -e 's:--cov ini2toml --cov-report term-missing::' setup.cfg || die
	distutils-r1_src_prepare
}
