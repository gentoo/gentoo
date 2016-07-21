# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="3"
PYTHON_DEPEND="*"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="*-jython"

inherit distutils

DESCRIPTION="Graphical Python debugger"
HOMEPAGE="http://winpdb.org/ https://code.google.com/p/winpdb/ https://pypi.python.org/pypi/winpdb"
SRC_URI="https://${PN}.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ia64 x86"
IUSE="+wxwidgets"

DEPEND=">=dev-python/pycrypto-2.0.1
	wxwidgets? ( dev-python/wxpython:2.8 )"
RDEPEND="${DEPEND}"

src_install() {
	distutils_src_install

	if use wxwidgets; then
		PYTHON_MODNAME="rpdb2.py winpdb.py"
	else
		PYTHON_MODNAME="rpdb2.py"

		rm -f "${ED}usr/bin/winpdb"*

		delete_winpdb() {
			rm -f "${ED}$(python_get_sitedir)/winpdb.py"
		}
		python_execute_function -q delete_winpdb
	fi
}
