# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="plasmoid-${PN}"
inherit ecm

DESCRIPTION="Plasma 5 widget showing your Gmail feed"
HOMEPAGE="https://www.pling.com/p/1248550/
https://github.com/Intika-KDE-Plasmoids/plasmoid-ultimate-gmail-feed"
SRC_URI="https://github.com/Intika-KDE-Plasmoids/${MY_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="5"
KEYWORDS="~amd64"
IUSE=""

S="${WORKDIR}/${MY_PN}-${PV}"

DEPEND="
	dev-qt/qtdeclarative:5
	dev-qt/qtnetwork:5
	kde-frameworks/knotifications:5
	kde-frameworks/plasma:5
"
RDEPEND="${DEPEND}
	dev-qt/qtquickcontrols:5
	dev-qt/qtxmlpatterns:5[qml]
"
