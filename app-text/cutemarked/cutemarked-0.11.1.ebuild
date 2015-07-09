# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/cutemarked/cutemarked-0.11.1.ebuild,v 1.1 2015/07/09 13:04:12 zx2c4 Exp $

EAPI=5

inherit qmake-utils

DESCRIPTION="Qt5 markdown editor"
HOMEPAGE="https://github.com/cloose/CuteMarkEd"
SRC_URI="https://github.com/cloose/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	app-text/discount
	app-text/hunspell
"
RDEPEND="${DEPEND}"

S="${WORKDIR}/CuteMarkEd-${PV}"

src_prepare() {
	epatch "${FILESDIR}/${P}"-respect-destdir.patch
}

src_configure() {
	eqmake5 ROOT="${D}" CuteMarkEd.pro
}
