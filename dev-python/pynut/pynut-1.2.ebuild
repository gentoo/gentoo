# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="3"

SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"

inherit python

DESCRIPTION="An abstraction class written in Python to access NUT (Network UPS Tools) server"
HOMEPAGE="http://www.lestat.st/informatique/projets/pynut-en/"
SRC_URI="http://www.lestat.st/_media/informatique/projets/pynut/python-${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

S="${WORKDIR}/python-${P}"

src_install() {
	installation() {
		insinto $(python_get_sitedir)
		doins PyNUT.py
	}
	python_execute_function -q installation

	dodoc README
}

pkg_postinst() {
	python_mod_optimize PyNUT.py
}

pkg_postrm() {
	python_mod_cleanup PyNUT.py
}
