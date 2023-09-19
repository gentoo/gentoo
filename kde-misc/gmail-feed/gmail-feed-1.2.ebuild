# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit ecm

DESCRIPTION="Plasma 5 applet providing a list of unread emails from your Gmail inbox"
HOMEPAGE="https://store.kde.org/p/998911/ https://github.com/anthon38/gmailfeed"
SRC_URI="https://github.com/anthon38/${PN/-/}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN/-/}-${PV}"

LICENSE="GPL-3+"
SLOT="5"
KEYWORDS="~amd64"

DEPEND="
	dev-qt/qtdeclarative:5
	dev-qt/qtnetwork:5
	kde-apps/kaccounts-integration:5
	kde-frameworks/kcoreaddons:5
	kde-frameworks/knotifications:5
	kde-frameworks/plasma:5
	net-libs/accounts-qt
"
RDEPEND="${DEPEND}
	dev-qt/qtquickcontrols:5
	dev-qt/qtxmlpatterns:5[qml]
"
# 	kde-apps/kaccounts-providers:5
