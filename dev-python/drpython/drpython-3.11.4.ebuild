# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

MY_PN="DrPython"
MY_P="${MY_PN}_${PV}"

DESCRIPTION="A powerful cross-platform IDE for Python"
HOMEPAGE="http://drpython.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ia64 ppc x86"
IUSE=""

RDEPEND=">=dev-python/wxpython-2.6"
DEPEND="${RDEPEND}
	app-arch/unzip"

S="${WORKDIR}/${PN}"

PAYTCHES=( "${FILESDIR}/${PN}-165-wxversion.patch" )

python_prepare_all() {
	sed \
		-e "/'drpython.pyw', 'drpython.lin'/d" \
		-e "/scripts=\['postinst.py'\],/d" \
		-i setup.py || die "sed failed"
	sed -e "s/arguments)c/arguments)/" -i examples/DrScript/SetTerminalArgs.py || die "sed failed"
	distutils-r1_python_prepare_all
}

python_install() {
	make_wrapper drpython "${PYTHON}" $(python_get_sitedir)/${PN}/drpython.py
	distutils-r1_python_install
}

pkg_postinst() {
	elog "DrPython plugins are available on DrPython homepage:"
	elog "https://sourceforge.net/projects/drpython/files/DrPython%20Plugins/"
}
