# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit eutils qmake-utils

DESCRIPTION="Qt version of the classic boardgame checkers"
HOMEPAGE="http://qcheckers.sourceforge.net/"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~x86"
IUSE=""

DEPEND="dev-qt/qtgui:4"
RDEPEND=${DEPEND}

src_prepare() {
	default

	sed -i \
		-e "s:/usr/local:/usr:" \
		common.h || die
}

src_configure() {
	eqmake4
}

src_install() {
	dobin kcheckers

	insinto /usr/share/${PN}
	doins -r i18n/* themes

	newicon icons/biglogo.png ${PN}.png
	make_desktop_entry ${PN} KCheckers

	dodoc AUTHORS ChangeLog FAQ README TODO
}
