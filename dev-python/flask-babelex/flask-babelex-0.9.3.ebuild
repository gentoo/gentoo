# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{6,7} )

inherit distutils-r1

MY_PN="Flask-BabelEx"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Adds i18n/l10n support to Flask applications"
HOMEPAGE="https://github.com/mrjoes/flask-babelex https://pypi.org/project/Flask-BabelEx/"
SRC_URI="mirror://pypi/${MY_P:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="doc"

RDEPEND="dev-python/flask[${PYTHON_USEDEP}]
	>=dev-python/Babel-1[${PYTHON_USEDEP}]
	>=dev-python/speaklater-1.2[${PYTHON_USEDEP}]
	>=dev-python/jinja-2.5[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? (
		dev-python/sphinx[${PYTHON_USEDEP}]
		dev-python/flask-sphinx-themes[${PYTHON_USEDEP}]
	)"

PATCHES=( "${FILESDIR}/${P}-tests-fix.patch" )

S="${WORKDIR}/${MY_P}"

python_compile_all() {
	use doc && emake -C docs html
}

python_test() {
	cd tests || die
	"${PYTHON}" tests.py || die "Testing failed with ${EPYTHON}"
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/_build/html/. )
	distutils-r1_python_install_all
}
