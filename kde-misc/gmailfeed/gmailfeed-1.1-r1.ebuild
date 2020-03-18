# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KFMIN=5.60.0
QTMIN=5.12.1
inherit ecm

DESCRIPTION="Plasma 5 applet providing a list of unread emails from your Gmail inbox"
HOMEPAGE="https://store.kde.org/p/998911/ https://github.com/anthon38/gmailfeed"
SRC_URI="https://github.com/anthon38/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="5"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	>=dev-qt/qtnetwork-${QTMIN}:5
	>=dev-qt/qtxmlpatterns-5.12.1-r1:5[qml(+)]
	>=kde-frameworks/knotifications-${KFMIN}:5
	>=kde-frameworks/plasma-${KFMIN}:5
"
RDEPEND="${DEPEND}
	>=dev-qt/qtquickcontrols-${QTMIN}:5
"
