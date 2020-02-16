# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_6 )

inherit distutils-r1

DESCRIPTION="doit tasks for python stuff"
HOMEPAGE="https://pythonhosted.org/doit-py/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc test"
RESTRICT="!test? ( test )"

DEPEND="test? (
		dev-python/pyflakes[${PYTHON_USEDEP}]
		dev-python/coverage[${PYTHON_USEDEP}]
		virtual/python-singledispatch[${PYTHON_USEDEP}]
		app-text/hunspell )
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )"
RDEPEND="
	virtual/python-pathlib[${PYTHON_USEDEP}]
	dev-python/doit[${PYTHON_USEDEP}]
	dev-python/configclass[${PYTHON_USEDEP}]"

distutils_enable_tests pytest

python_compile_all() {
	use doc && emake -C doc html
}

python_install_all() {
	use doc && local HTML_DOCS=( doc/_build/html/. )
	distutils-r1_python_install_all
}
