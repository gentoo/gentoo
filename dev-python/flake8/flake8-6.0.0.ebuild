# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{9..11} )

inherit distutils-r1

DESCRIPTION="A wrapper around PyFlakes, pep8 & mccabe"
HOMEPAGE="
	https://github.com/PyCQA/flake8/
	https://pypi.org/project/flake8/
"
SRC_URI="
	https://github.com/PyCQA/flake8/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~x64-macos"

RDEPEND="
	<dev-python/pyflakes-3.1.0[${PYTHON_USEDEP}]
	>=dev-python/pyflakes-3.0.0[${PYTHON_USEDEP}]
	<dev-python/pycodestyle-2.11.0[${PYTHON_USEDEP}]
	>=dev-python/pycodestyle-2.10.0[${PYTHON_USEDEP}]
"
PDEPEND="
	>=dev-python/mccabe-0.7.0[${PYTHON_USEDEP}]
	<dev-python/mccabe-0.8.0[${PYTHON_USEDEP}]
"
BDEPEND="
	${RDEPEND}
	test? (
		${PDEPEND}
	)
"

distutils_enable_sphinx docs/source dev-python/sphinx-prompt dev-python/sphinx-rtd-theme
distutils_enable_tests pytest

EPYTEST_DESELECT=(
	# fails if additional flake8 plugins are installed
	tests/integration/test_plugins.py::test_local_plugin_can_add_option
)
