# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

MY_PN="Flask-Dashed"
MY_PV="${PV/_p/}"
MY_P="${MY_PN}-${MY_PV}"

DESCRIPTION="Admin app framework for flask"
HOMEPAGE="http://pythonhosted.org/${MY_PN}/ https://pypi.python.org/pypi/${MY_PN}"
SRC_URI="mirror://pypi/${MY_P:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="dev-python/flask[${PYTHON_USEDEP}]
	dev-python/flask-wtf[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	distutils-r1_src_prepare
	rm -rf "${S}/tests"
}
