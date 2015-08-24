# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"
inherit qt4-r2

DESCRIPTION="GUI front-end for cclive and clive video extraction utilities"
HOMEPAGE="https://code.google.com/p/abby/"
SRC_URI="https://abby.googlecode.com/files/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~ppc ~ppc64 x86"
IUSE=""

RDEPEND="|| ( >=media-video/clive-2.2.5 >=media-video/cclive-0.5.0 )
	dev-qt/qtcore:4
	dev-qt/qtgui:4"
DEPEND="${RDEPEND}"

src_install() {
	dobin abby
	dodoc AUTHORS ChangeLog README TODO NEWS
}
