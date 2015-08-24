# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

MY_PN="Frozen-Flask"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Freezes a Flask application into a set of static files"
HOMEPAGE="https://github.com/SimonSapin/Frozen-Flask https://pypi.python.org/pypi/Frozen-Flask"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="doc test"

RDEPEND=">=dev-python/flask-0.7[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-python/nose[${PYTHON_USEDEP}] )"

S="${WORKDIR}/${MY_P}"

python_compile_all() {
	if use doc; then
		sed -e 's:^intersphinx_mapping:#intersphinx_mapping:' -i docs/conf.py || die
		mkdir docs/_build || die
		sphinx-build -c docs docs docs/_build  || die
	fi
}

python_test() {
	nosetests || die Tests failed under $"{EPYTHON}"
}

python_install_all() {
	use doc && HTML_DOCS=( "${S}"/docs/_build/. )
	distutils-r1_python_install_all
}
