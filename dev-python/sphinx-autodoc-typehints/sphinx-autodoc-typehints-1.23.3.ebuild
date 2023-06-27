# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{10..11} )

inherit distutils-r1 pypi

DESCRIPTION="Type hints support for the Sphinx autodoc extension"
HOMEPAGE="
	https://github.com/tox-dev/sphinx-autodoc-typehints/
	https://pypi.org/project/sphinx-autodoc-typehints/
"

LICENSE="MIT"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ia64 ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
SLOT="0"

RDEPEND="
	>=dev-python/sphinx-5.3[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/hatch-vcs[${PYTHON_USEDEP}]
	test? (
		>=dev-python/nptyping-2.5[${PYTHON_USEDEP}]
		>=dev-python/sphobjinv-2.3.1[${PYTHON_USEDEP}]
		>=dev-python/typing-extensions-4.5[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

EPYTEST_DESELECT=(
	# this package is addicted to Internet
	tests/test_sphinx_autodoc_typehints.py::test_format_annotation
)
