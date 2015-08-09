# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=3

inherit eutils cmake-utils

DESCRIPTION="Powerful GUI manager for the Sqlite3 database"
HOMEPAGE="http://sqliteman.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="dev-qt/qtgui:4
	dev-qt/qtsql:4[sqlite]
	x11-libs/qscintilla"
DEPEND="${RDEPEND}"

DOCS="AUTHORS README"

src_prepare() {
	# remove bundled lib
	rm -rf "${S}"/${PN}/qscintilla2
}
