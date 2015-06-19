# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-power/cpuspeedy/cpuspeedy-0.4.1.ebuild,v 1.6 2014/08/10 20:12:14 slyfox Exp $

EAPI=3
PYTHON_DEPEND="2"
inherit python

DESCRIPTION="A simple and easy to use program to control the speed and the voltage of CPUs on the fly"
HOMEPAGE="http://cpuspeedy.sourceforge.net/"
SRC_URI="mirror://sourceforge/cpuspeedy/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ppc x86"
IUSE=""

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}

src_prepare() {
	rm -f Makefile || die
	python_convert_shebangs -r $(python_get_version) .
}

src_install() {
	exeinto "$(python_get_sitedir)"/${PN}
	doexe src/*.py || die

	dodoc AUTHORS ChangeLog README || die
	doman doc/*.1 || die

	dosym "$(python_get_sitedir)"/${PN}/${PN}.py /usr/sbin/${PN} || die
}

pkg_postinst() {
	python_mod_optimize ${PN}
}

pkg_postrm() {
	python_mod_cleanup ${PN}
}
