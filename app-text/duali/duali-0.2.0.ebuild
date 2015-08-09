# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="3"
PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"

inherit python

DESCRIPTION="Arabic dictionary based on the DICT protocol"
HOMEPAGE="http://www.arabeyes.org/project.php?proj=Duali"
SRC_URI="mirror://sourceforge/arabeyes/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 ~hppa ia64 ~mips ppc ~sparc x86"
IUSE=""

DEPEND=""
PDEPEND="app-dicts/duali-data"
RESTRICT_PYTHON_ABIS="3.*"

src_install() {
	dobin duali dict2db trans2arabic arabic2trans
	python_convert_shebangs -r 2 "${ED}usr/bin"

	insinto /etc
	doins duali.conf

	doman doc/man/*

	installation() {
		insinto $(python_get_sitedir)/pyduali
		doins pyduali/*.py
	}
	python_execute_function installation

	dodoc README ChangeLog INSTALL MANIFEST
}

pkg_postinst() {
	python_mod_optimize pyduali
}

pkg_postrm() {
	python_mod_cleanup pyduali
}
