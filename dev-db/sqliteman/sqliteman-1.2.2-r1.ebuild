# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-db/sqliteman/sqliteman-1.2.2-r1.ebuild,v 1.1 2015/04/04 16:43:39 kensington Exp $

EAPI=5

inherit cmake-utils

DESCRIPTION="Powerful GUI manager for the Sqlite3 database"
HOMEPAGE="http://sqliteman.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-qt/qtcore:4
	dev-qt/qtgui:4
	dev-qt/qtsql:4[sqlite]
	x11-libs/qscintilla"
DEPEND="${RDEPEND}"

DOCS=( AUTHORS README )

src_prepare() {
	# remove bundled lib
	rm -rf "${S}"/${PN}/qscintilla2

	cmake-utils_src_prepare
}
