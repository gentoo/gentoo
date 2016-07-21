# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="3"
PYTHON_DEPEND="2:2.6"

inherit python

DESCRIPTION="a GUI frontend to cdlabelgen which is a program that can generate a variety of CD tray covers"
HOMEPAGE="http://gtkcdlabel.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc sparc x86"
IUSE=""

DEPEND=">=app-cdr/cdlabelgen-3
	dev-python/pygtk"
RDEPEND="${DEPEND}"

src_prepare() {
	python_convert_shebangs -r 2 .
}

src_install() {
	dobin usr/bin/${PN}.py || die "dobin failed"
	insinto /usr/share
	doins -r usr/share/{applications,${PN},pixmaps} || die "doins failed"
	dodoc usr/share/doc/${PN}/{AUTHORS,README}
}
