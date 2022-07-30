# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )

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
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ppc ppc64 ~riscv ~s390 sparc x86"

RDEPEND="
	dev-python/docutils[${PYTHON_USEDEP}]
	dev-python/pygments[${PYTHON_USEDEP}]
	dev-python/sphinx[${PYTHON_USEDEP}]
"

BDEPEND="
	test? (
		dev-python/beautifulsoup4[${PYTHON_USEDEP}]
		dev-python/pytest-regressions[${PYTHON_USEDEP}]
		dev-python/pygments[${PYTHON_USEDEP}]
		dev-python/sphinx-testing[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest
distutils_enable_sphinx docs dev-python/sphinx_rtd_theme

EPYTEST_DESELECT=(
	# Unpackaged rinohtype
	tests/test_build.py::test_rinohtype_pdf
)

src_prepare() {
	# annoying, incorrect version limitations
	sed -i -e '/install_requires/d' setup.py || die

	# fix tests for >=sphinx-5
	sed -e 's/\(Permalink to this\) heading/\1 headline/g' \
		-i tests/test_build/test_*.html || die

	distutils-r1_src_prepare
}
