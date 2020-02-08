# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( pypy3 python3_{6,7,8} )
inherit distutils-r1

DESCRIPTION="Login session support for Flask"
HOMEPAGE="https://pypi.org/project/Flask-Login/"
# Should be replaced with the PyPi URI for the next release, if possible
# See https://github.com/maxcountryman/flask-login/pull/393
SRC_URI="https://github.com/maxcountryman/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="doc test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-python/flask-0.10[${PYTHON_USEDEP}]
	dev-python/werkzeug[${PYTHON_USEDEP}]
"
DEPEND="
	doc? (
		dev-python/sphinx[${PYTHON_USEDEP}]
	)
	test? (
		${RDEPEND}
		dev-python/blinker[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/nose[${PYTHON_USEDEP}]
		dev-python/semantic_version[${PYTHON_USEDEP}]
	)"

python_prepare_all() {
	sed -i "s/'sphinx.ext.intersphinx', //" docs/conf.py || die
	distutils-r1_python_prepare_all
}

python_compile_all() {
	if use doc; then
		emake -C docs html
		HTML_DOCS=( docs/_build/html/. )
	fi
}

python_test() {
	# test is broken upstream with >=dev-python/werkzeug-0.15, bug 701546
	nosetests -v -e test_unauthorized_uses_host_from_x_forwarded_for_header \
		|| die "Tests fail with ${EPYTHON}"
}
