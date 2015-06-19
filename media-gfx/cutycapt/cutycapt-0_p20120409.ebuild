# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/cutycapt/cutycapt-0_p20120409.ebuild,v 1.3 2013/03/02 21:34:27 hwoarang Exp $

EAPI=4
inherit qt4-r2

DESCRIPTION="Qt WebKit Web Page Rendering Capture Utility"
HOMEPAGE="http://cutycapt.sourceforge.net/"
SRC_URI="http://dev.gentoo.org/~mattm/${P}.tar.gz"
LICENSE="LGPL-2.1"
SLOT="0"

KEYWORDS="~amd64 ~x86"
IUSE=""
DEPEND="dev-qt/qtgui:4 dev-qt/qtwebkit:4 dev-qt/qtcore:4 dev-qt/qtsvg:4"
RDEPEND="${DEPEND}"

src_configure() {
	eqmake4 CutyCapt.pro
}

src_install() {
	dobin CutyCapt
}

pkg_postinst() {
	einfo "Upstream is no longer actively developing package."
	einfo "Recommends switching to PhantomJS instead."
	einfo ""
	einfo "You cannot use CutyCapt without an X server, but you"
	einfo "can use e.g. Xvfb as light-weight server."
	einfo "See ${HOMEPAGE} for usage."
}
