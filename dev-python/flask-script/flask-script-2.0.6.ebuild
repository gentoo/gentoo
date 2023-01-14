# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{9..10} )
inherit distutils-r1

MY_PN="Flask-Script"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Flask support for writing external scripts"
HOMEPAGE="https://flask-script.readthedocs.io/en/latest/
	https://flask-script.readthedocs.io/en/latest/
	https://pypi.org/project/Flask-Script/"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND=">=dev-python/flask-0.10.1-r1[${PYTHON_USEDEP}]"

PATCHES=( "${FILESDIR}/${P}-flask_script-everywhere.patch" )

distutils_enable_tests pytest
distutils_enable_sphinx docs

python_test() {
	epytest tests.py
}
