# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit flag-o-matic toolchain-funcs

DESCRIPTION="Quite Universal Circuit Simulator in Qt4"
HOMEPAGE="http://qucs.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-qt/qtcore:4[qt3support]
	dev-qt/qtgui:4[qt3support]
	dev-qt/qt3support:4
	x11-libs/libX11:0="
DEPEND="${RDEPEND}"

src_configure() {
	# automagic default on clang++
	tc-export CXX

	# the package doesn't use pkg-config on Linux, only on Darwin
	# very smart of upstream...
	append-ldflags $( $(tc-getPKG_CONFIG) --libs-only-L \
			QtCore QtGui QtXml Qt3Support )

	default
}
