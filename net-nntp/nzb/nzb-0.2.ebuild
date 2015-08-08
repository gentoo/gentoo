# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
inherit eutils qt4-r2

DESCRIPTION="A binary news grabber"
HOMEPAGE="http://www.nzb.fi/"
SRC_URI="mirror://sourceforge/nzb/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-qt/qtcore:4
	dev-qt/qtgui:4"
RDEPEND="${DEPEND}"

DOCS="ChangeLog"

src_install() {
	qt4-r2_src_install
	doicon images/nzb.png
	make_desktop_entry nzb
}
