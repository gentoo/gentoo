# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python{2_7,3_3,3_4,3_5} )

inherit distutils-r1

DESCRIPTION="Python SNMP library"
HOMEPAGE="http://pysnmp.sf.net/ https://pypi.python.org/pypi/pysnmp"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ia64 ~ppc ~sparc ~x86"
IUSE="doc examples"

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
"
RDEPEND="
	>=dev-python/pyasn1-0.1.2[${PYTHON_USEDEP}]
	dev-python/pycrypto[${PYTHON_USEDEP}]
"

python_compile_all() {
	default

	if use doc; then
		touch docs/source/conf.py
		emake -C docs html
	fi
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/build/html/* )
	docinto examples
	use examples && dodoc -r examples/* docs/mibs

	distutils-r1_python_install_all
}

pkg_postinst() {
	elog "You may also be interested in the following packages: "
	elog "dev-python/pysnmp-apps - example programs using pysnmp"
	elog "dev-python/pysnmp-mibs - IETF and other mibs"
	elog "net-libs/libsmi - to dump MIBs in python format"
}
