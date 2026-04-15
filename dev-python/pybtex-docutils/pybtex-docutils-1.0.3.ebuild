# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="A docutils backend for pybtex"
HOMEPAGE="
	https://github.com/mcmtroffaes/pybtex-docutils/
	https://pypi.org/project/pybtex-docutils/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

RDEPEND="
	>=dev-python/docutils-0.14[${PYTHON_USEDEP}]
	>=dev-python/pybtex-0.16[${PYTHON_USEDEP}]

"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest
distutils_enable_sphinx doc

EPYTEST_DESELECT=(
	# just an entry point check, requires pkg-resources
	test/test_find_plugin.py::test_pkg_resources_entry_point
)
