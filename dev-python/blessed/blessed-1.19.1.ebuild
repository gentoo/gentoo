# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{8..11} )
inherit distutils-r1

DESCRIPTION="Library for making terminal apps using colors, keyboard input and positioning"
HOMEPAGE="https://github.com/jquast/blessed"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="MIT"
KEYWORDS="amd64 ~riscv x86"

RDEPEND="
	dev-python/six[${PYTHON_USEDEP}]
	dev-python/wcwidth[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/mock[${PYTHON_USEDEP}]
	)
"

distutils_enable_sphinx docs dev-python/sphinx_rtd_theme
distutils_enable_tests pytest

python_prepare_all() {
	# Skip those extensions as they don't have a Gentoo package
	# Remove calls to scripts that generate rst files because they
	# are not present in the tarball
	sed -e '/sphinxcontrib.manpage/d' -e '/sphinx_paramlinks/d' \
		-e '/^for script in/,/runpy.run_path/d' \
		-i docs/conf.py || die
	# Requires pytest-xdist and has no value for us
	sed -i '/^looponfailroots =/d' tox.ini || die
	distutils-r1_python_prepare_all
}

python_test() {
	# COLORTERM must not be truecolor
	# See https://github.com/jquast/blessed/issues/162
	# Ignore coverage options
	COLORTERM= epytest --override-ini="addopts="
}
