# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit qmake-utils

DESCRIPTION="GUI to access Czech eGov \"Datove schranky\""
HOMEPAGE="https://labs.nic.cz/cs/datovka.html"
SRC_URI="https://secure.nic.cz/files/datove_schranky/${PV}/${P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

# minimum Qt version required
QT_PV="5.3.2:5"

RDEPEND="
	>=dev-libs/openssl-1.0.1
	>=dev-qt/qtcore-${QT_PV}
	>=dev-qt/qtgui-${QT_PV}
	>=dev-qt/qtnetwork-${QT_PV}
	>=dev-qt/qtprintsupport-${QT_PV}
	>=dev-qt/qtsql-${QT_PV}[sqlite]
	>=dev-qt/qtwidgets-${QT_PV}
	>=net-libs/libisds-0.10.5
"
DEPEND="
	${RDEPEND}
	>=dev-qt/linguist-tools-${QT_PV}
"

src_configure() {
	lrelease datovka.pro
	eqmake5 PREFIX="/usr" DISABLE_VERSION_CHECK_BY_DEFAULT=1
}

src_install() {
	emake install INSTALL_ROOT="${D}"

	docompress -x \
	    /usr/share/doc/datovka/AUTHORS \
	    /usr/share/doc/datovka/COPYING
	dodoc ChangeLog
}
