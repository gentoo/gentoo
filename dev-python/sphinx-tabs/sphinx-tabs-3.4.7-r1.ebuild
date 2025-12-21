# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..14} )

inherit distutils-r1

DESCRIPTION="Tabbed views for Sphinx"
HOMEPAGE="
	https://github.com/executablebooks/sphinx-tabs/
	https://pypi.org/project/sphinx-tabs/
"
SRC_URI="
	https://github.com/executablebooks/sphinx-tabs/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~m68k ppc ppc64 ~riscv ~s390 ~sparc x86"

RDEPEND="
	<dev-python/docutils-0.22[${PYTHON_USEDEP}]
	dev-python/pygments[${PYTHON_USEDEP}]
	>=dev-python/sphinx-1.8[${PYTHON_USEDEP}]
"

BDEPEND="
	test? (
		dev-python/beautifulsoup4[${PYTHON_USEDEP}]
		dev-python/pygments[${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGINS=( pytest-{datadir,regressions} )
distutils_enable_tests pytest
distutils_enable_sphinx docs dev-python/sphinx-rtd-theme

PATCHES=(
	# https://github.com/executablebooks/sphinx-tabs/pull/200
	"${FILESDIR}/${P}-sphinx-8.1.patch"
)

EPYTEST_DESELECT=(
	# Unpackaged rinohtype
	tests/test_build.py::test_rinohtype_pdf
)
