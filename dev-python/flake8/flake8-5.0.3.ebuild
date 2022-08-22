# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{8..11} )

inherit distutils-r1

DESCRIPTION="A wrapper around PyFlakes, pep8 & mccabe"
HOMEPAGE="
	https://github.com/pycqa/flake8/
	https://pypi.org/project/flake8/
"
SRC_URI="
	https://github.com/PyCQA/flake8/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-macos"

# requires.txt inc. mccabe however that creates a circular dep
RDEPEND="
	>=dev-python/pyflakes-2.5.0[${PYTHON_USEDEP}]
	<dev-python/pyflakes-2.6.0[${PYTHON_USEDEP}]
	>=dev-python/pycodestyle-2.9.0[${PYTHON_USEDEP}]
	<dev-python/pycodestyle-2.10.0[${PYTHON_USEDEP}]
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

distutils_enable_sphinx docs/source dev-python/sphinx-prompt dev-python/sphinx_rtd_theme
distutils_enable_tests pytest

EPYTEST_DESELECT=(
	# fails if additional flake8 plugins are installed
	tests/integration/test_plugins.py::test_local_plugin_can_add_option
)
