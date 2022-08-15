# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="Type hints support for the Sphinx autodoc extension"
HOMEPAGE="
	https://github.com/tox-dev/sphinx-autodoc-typehints/
	https://pypi.org/project/sphinx-autodoc-typehints/
"
SRC_URI="
	https://github.com/tox-dev/sphinx-autodoc-typehints/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
SLOT="0"

RDEPEND="
	>=dev-python/sphinx-4.5[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/setuptools_scm[${PYTHON_USEDEP}]
	test? (
		>=dev-python/nptyping-2.1.1[${PYTHON_USEDEP}]
		dev-python/sphobjinv[${PYTHON_USEDEP}]
		>=dev-python/typing-extensions-4.1[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

EPYTEST_DESELECT=(
	# this package is addicted to Internet
	tests/test_sphinx_autodoc_typehints.py::test_format_annotation
)

export SETUPTOOLS_SCM_PRETEND_VERSION=${PV}
