# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="3"
PYTHON_DEPEND="2"

inherit distutils

DESCRIPTION="CodeSourcery's test harness system"
HOMEPAGE="http://www.codesourcery.com/qmtest/"
SRC_URI="http://www.codesourcery.com/public/${PN}/${PF}/${PF}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~mips x86"
IUSE=""

DEPEND=""
RDEPEND=""

PYTHON_MODNAME="qm"

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}

src_install() {
	distutils_src_install
	find "${D}" -name config.py -print0 | xargs -0 sed -i "s:${D}:/usr:"
	dodir /usr/share/doc/${PF}
	rm -r "${D}"/usr/share/doc/${PN}/{COPYING,LICENSE.OPL} || die
	mv "${D}"/usr/share/doc/${PN}/* "${D}"/usr/share/doc/${PF} || die
	rm -r "${D}"/usr/share/doc/${PN} || die
}
