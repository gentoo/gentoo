# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1

DESCRIPTION="Code audit tool for python"
HOMEPAGE="
	https://github.com/klen/pylama/
	https://pypi.org/project/pylama/
"
SRC_URI="
	https://github.com/klen/pylama/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv ~s390 sparc x86"

RDEPEND="
	>=dev-python/mccabe-0.7.0[${PYTHON_USEDEP}]
	>=dev-python/pycodestyle-2.9.1[${PYTHON_USEDEP}]
	>=dev-python/pydocstyle-6.1.1[${PYTHON_USEDEP}]
	>=dev-python/pyflakes-2.5.0[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/eradicate[${PYTHON_USEDEP}]
		dev-python/mypy[${PYTHON_USEDEP}]
		dev-python/pylint[${PYTHON_USEDEP}]
		dev-python/radon[${PYTHON_USEDEP}]
		dev-vcs/git
		$(python_gen_cond_dep '
			dev-python/tomli[${PYTHON_USEDEP}]
		' 3.{8..10})
	)
"

distutils_enable_tests pytest

PATCHES=(
	"${FILESDIR}"/${P}-tomli.patch
)

EPYTEST_DESELECT=(
	# not packaged
	tests/test_linters.py::test_quotes
	tests/test_linters.py::test_vulture
)
