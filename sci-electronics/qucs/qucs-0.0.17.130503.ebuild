# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-electronics/qucs/qucs-0.0.17.130503.ebuild,v 1.2 2013/07/23 14:32:41 kensington Exp $

EAPI=5

inherit autotools-utils flag-o-matic toolchain-funcs

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
	x11-libs/libX11"
DEPEND="${RDEPEND}"

AUTOTOOLS_IN_SOURCE_BUILD=1

src_configure() {
	# the package doesn't use pkg-config on Linux, only on Darwin
	# very smart of upstream...
	append-ldflags $( $(tc-getPKG_CONFIG) --libs-only-L \
			QtCore QtGui QtXml Qt3Support )

	autotools-utils_src_configure
}
