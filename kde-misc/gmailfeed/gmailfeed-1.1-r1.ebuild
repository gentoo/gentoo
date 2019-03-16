# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

QT_MINIMAL=5.12.1
inherit kde5

DESCRIPTION="Plasma 5 applet providing a list of unread emails from your Gmail inbox"
HOMEPAGE="https://store.kde.org/p/998911/ https://github.com/anthon38/gmailfeed"
SRC_URI="https://github.com/anthon38/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	$(add_frameworks_dep knotifications)
	$(add_frameworks_dep plasma)
	$(add_qt_dep qtnetwork)
	$(add_qt_dep qtxmlpatterns 'qml(+)' 5.12.1-r1)
"
RDEPEND="${DEPEND}
	$(add_qt_dep qtquickcontrols)
"
