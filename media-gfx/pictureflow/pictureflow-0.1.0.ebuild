# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"
inherit qt4-r2

DESCRIPTION="Qt widget to display images with animated transition effect"
HOMEPAGE="http://www.qt-apps.org/content/show.php/PictureFlow?content=75348"
SRC_URI="https://${PN}.googlecode.com/files/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~sparc x86"
IUSE="debug"

DEPEND="dev-qt/qtgui:4"
RDEPEND="${DEPEND}"
S="${WORKDIR}/${P}/${PN}-qt"

src_install() {
	dobin ${PN} || die "dobin failed"
	cd ..
	dodoc ChangeLog || die "dodoc failed"
}
