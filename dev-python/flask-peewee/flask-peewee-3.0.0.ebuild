# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 python3_{4,5} )

inherit distutils-r1

DESCRIPTION="Flask integration layer for the Peewee ORM"
HOMEPAGE="https://pypi.python.org/pypi/Flask-Admin"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples test"

RESTRICT="test" # broken

RDEPEND="
	dev-python/flask[${PYTHON_USEDEP}]
	dev-python/werkzeug[${PYTHON_USEDEP}]
	dev-python/jinja[${PYTHON_USEDEP}]
	>=dev-python/peewee-3[${PYTHON_USEDEP}]
	dev-python/wtforms[${PYTHON_USEDEP}]
	>=dev-python/wtf-peewee-3[${PYTHON_USEDEP}]"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-python/nose[${PYTHON_USEDEP}] )
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )"

python_compile_all() {
	use doc && emake -C docs html
}

python_test() {
	nosetests -v || die "Testing failed with ${EPYTHON}"
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/_build/html/. )
	if use examples ; then
		docinto examples
		dodoc -r example/.
		docompress -x /usr/share/doc/${PF}/examples
	fi
	distutils-r1_python_install_all
}
