# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( pypy3 python3_{6,7,8} )

inherit distutils-r1

DESCRIPTION="API wrapper for Pushover"
HOMEPAGE="https://github.com/karanlyons/chump"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

DEPEND="
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
"

# The package has no test suite

python_prepare_all() {
	sed -i "/'sphinx.ext.intersphinx'/d" docs/conf.py || die
	distutils-r1_python_prepare_all
}

python_compile_all() {
	if use doc; then
		# Force sphinx to use the standard theme
		READTHEDOCS=True sphinx-build docs docs/_build/html || die
		HTML_DOCS=( docs/_build/html/. )
	fi
}
