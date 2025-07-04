# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )
inherit distutils-r1

DESCRIPTION="Python docutils-compatibility bridge to CommonMark"
HOMEPAGE="
	https://recommonmark.readthedocs.io/
	https://github.com/readthedocs/recommonmark/
	https://pypi.org/project/recommonmark/
"
SRC_URI="
	https://github.com/readthedocs/recommonmark/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux"

RDEPEND="
	>=dev-python/commonmark-0.8.1[${PYTHON_USEDEP}]
	>=dev-python/docutils-0.14[${PYTHON_USEDEP}]
	dev-python/sphinx[${PYTHON_USEDEP}]
"

PATCHES=(
	"${FILESDIR}/${PN}-0.6.0-sphinx3-1.patch"
	"${FILESDIR}/${PN}-0.6.0-sphinx3-2.patch"
)

# These tests are sensitive to Sphinx formatting changes and they will never
# get fixed because upstream has archived the project in favor of myst_parser.
# Bug #866009
EPYTEST_DESELECT=(
	"tests/test_sphinx.py::GenericTests::test_headings"
	"tests/test_sphinx.py::CustomExtensionTests::test_integration"
)

distutils_enable_tests pytest
