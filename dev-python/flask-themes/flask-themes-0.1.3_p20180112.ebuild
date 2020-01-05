# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( pypy3 python3_{6,7} )

inherit distutils-r1

MY_COMMIT="9eac2dcc9b81c3af29c2386ce1afba9b446562bf"

DESCRIPTION="Infrastructure for theming support in Flask applications"
HOMEPAGE="https://pythonhosted.org/Flask-Themes/"
# https://github.com/maxcountryman/flask-themes/issues/8
SRC_URI="https://github.com/maxcountryman/${PN}/archive/${MY_COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-python/flask-0.6[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
"
# No need to depend on dev-python/flask-sphinx-themes,
# it is bundled in docs/_themes
BDEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
	test? (
		${RDEPEND}
		dev-python/nose[${PYTHON_USEDEP}]
	)
"

S="${WORKDIR}/${PN}-${MY_COMMIT}"

python_prepare_all() {
	sed -i "s/, 'sphinx.ext.intersphinx'//" docs/conf.py || die
	distutils-r1_python_prepare_all
}

python_compile_all() {
	if use doc; then
		sphinx-build docs docs/_build/html || die
		HTML_DOCS=( docs/_build/html/. )
	fi
}

python_test() {
	nosetests -v || die "Tests failed under ${EPYTHON}"
}
