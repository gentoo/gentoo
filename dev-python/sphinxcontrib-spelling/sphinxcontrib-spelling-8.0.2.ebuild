# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{12..14} )

inherit distutils-r1 pypi

DESCRIPTION="Sphinx spelling extension"
HOMEPAGE="
	https://github.com/sphinx-contrib/spelling/
	https://pypi.org/project/sphinxcontrib-spelling/
"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"

RDEPEND="
	>=dev-python/pyenchant-3.1.1[${PYTHON_USEDEP}]
	>=dev-python/requests-2.32.3[${PYTHON_USEDEP}]
	>=dev-python/sphinx-3.0.0[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/hatch-vcs[${PYTHON_USEDEP}]
	test? (
		app-dicts/myspell-en
	)
"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest

EPYTEST_DESELECT=(
	# Internet
	tests/test_filter.py::test_pypi_filter_factory
)
