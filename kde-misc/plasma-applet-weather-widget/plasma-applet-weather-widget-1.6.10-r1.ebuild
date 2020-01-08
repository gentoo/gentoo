# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

QT_MINIMAL=5.12.1
inherit kde5

DESCRIPTION="Plasma 5 applet for weather forecasts"
HOMEPAGE="https://store.kde.org/p/998917/
https://github.com/kotelnik/plasma-applet-weather-widget"
SRC_URI="https://github.com/kotelnik/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	$(add_frameworks_dep plasma)
	$(add_qt_dep qtxmlpatterns 'qml(+)' 5.12.1-r1)
"
RDEPEND="${DEPEND}"

DOCS=( README.md )
