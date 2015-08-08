# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="3"
PYTHON_DEPEND="*"
SUPPORT_PYTHON_ABIS="1"

inherit python

DESCRIPTION="A Python module that implements several well-known classical cipher algorithms"
HOMEPAGE="http://pycipher.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.py"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND=""
RDEPEND=""

src_install() {
	installation() {
		insinto $(python_get_sitedir)
		newins "${DISTDIR}/${P}.py" ${PN}.py
	}
	python_execute_function installation
}

pkg_postinst() {
	python_mod_optimize ${PN}.py
}

pkg_postrm() {
	python_mod_cleanup ${PN}.py
}
