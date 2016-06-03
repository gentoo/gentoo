# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit qmake-utils

DESCRIPTION="This program allows users to configure Qt5 settings"
HOMEPAGE="http://qt5ct.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
DEPEND=">=dev-qt/linguist-tools-5.4.0"

src_configure() {
	eqmake5 ${PN}.pro
}

src_install() {
	emake INSTALL_ROOT="${D}" install
	einstalldocs
}

pkg_postinst() {
	elog "Add line 'export QT_QPA_PLATFORMTHEME=qt5ct' to ~/.profile"
	elog "and re-login."
	elog "Alternatively, execute the following command (under root):"
	elog "export QT_QPA_PLATFORMTHEME=qt5ct > /etc/X11/Xsession.d/101-qt5ct"
	elog "and restart X11 server."
}
