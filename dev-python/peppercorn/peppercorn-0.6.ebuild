# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_5,3_6} pypy )

inherit distutils-r1

DESCRIPTION="Convert a token stream into a web form data structure"
HOMEPAGE="https://github.com/Pylons/peppercorn https://pypi.org/project/peppercorn/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="repoze"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )"

RDEPEND=""

# Include COPYRIGHT.txt because the license seems to require it
#DOCS=( CHANGES.txt README.txt COPYRIGHT.txt )

python_prepare_all() {
	# Fix Sphinx theme. courtesy of Arfrever
	sed -e "/# Add and use Pylons theme/,+36d" -i docs/conf.py || die "sed failed"

	distutils-r1_python_prepare_all
}

python_compile_all() {
	use doc && emake -C docs html
}

python_test() {
	esetup.py test
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/_build/html/. )

	distutils-r1_python_install_all
}
