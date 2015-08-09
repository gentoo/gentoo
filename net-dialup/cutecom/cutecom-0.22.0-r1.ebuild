# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit cmake-utils eutils

DESCRIPTION="CuteCom is a serial terminal, like minicom, written in qt"
HOMEPAGE="http://cutecom.sourceforge.net"
SRC_URI="http://cutecom.sourceforge.net/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

DEPEND="dev-qt/qtcore:4
	dev-qt/qtgui:4
	dev-qt/qt3support:4"
RDEPEND="${DEPEND}
	net-dialup/lrzsz"

src_prepare() {
	sed -i \
		-e '/Path/d' \
		-e '/TerminalOptions/d' \
		-e '/BinaryPattern/d' \
		-e '/Terminal/s/0/false/' \
		${PN}.desktop || die 'sed on desktop file failed'

	cmake-utils_src_prepare
}

src_install() {
	cmake-utils_src_install

	# desktop icon does not installed by cmake without KDE3
	domenu ${PN}.desktop
}
