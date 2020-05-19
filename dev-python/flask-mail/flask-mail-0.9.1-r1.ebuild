# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{6,7,8} )
inherit distutils-r1

MY_PN="Flask-Mail"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Flask extension for sending email"
HOMEPAGE="https://pythonhosted.org/Flask-Mail/ https://pypi.org/project/Flask-Mail/"
SRC_URI="mirror://pypi/${MY_P:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="doc test"
RESTRICT="!test? ( test )"

RDEPEND="dev-python/flask[${PYTHON_USEDEP}]
	dev-python/blinker[${PYTHON_USEDEP}]"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( ${RDEPEND}
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/nose[${PYTHON_USEDEP}]
		dev-python/speaklater[${PYTHON_USEDEP}] )"

S="${WORKDIR}/${MY_P}"

python_compile_all() {
	use doc && emake -C docs html
}

python_test() {
	nosetests -v || die "Testing failed with ${EPYTHON}"
}

python_install_all() {
	use doc && HTML_DOCS=( docs/_build/html/. )
	distutils-r1_python_install_all
}
