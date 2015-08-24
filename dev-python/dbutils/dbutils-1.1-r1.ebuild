# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

MY_PN="DBUtils"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Database connections for multi-threaded environments"
HOMEPAGE="http://www.webwareforpython.org/DBUtils https://pypi.python.org/pypi/DBUtils"
SRC_URI="http://www.webwareforpython.org/downloads/DBUtils/${MY_P}.tar.gz"

LICENSE="OSL-2.0"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="doc examples"

DEPEND=""
RDEPEND=""

S="${WORKDIR}/${MY_P}"

python_prepare_all() {
	sed -i -e "s/, 'DBUtils.Tests'//" \
		-e "s/, 'DBUtils.Examples'//" \
		-e "/package_data=/d" \
		setup.py || die "sed failed"
	distutils-r1_python_prepare_all
}

python_test() {
	nosetests -s ${MY_PN}/Tests
}

python_install_all() {
	use doc && local HTML_DOCS=( "${S}/${MY_PN}"/Docs/. )
	use examples && local EXAMPLES=( "${MY_PN}"/Examples/. )
	distutils-r1_python_install_all
}
