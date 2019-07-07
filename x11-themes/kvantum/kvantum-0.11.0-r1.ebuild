# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

MY_PN="Kvantum"

DESCRIPTION="SVG-based theme engine for Qt4/Qt5, KDE and LXQt"
HOMEPAGE="https://github.com/tsujan/Kvantum"
SRC_URI="https://github.com/tsujan/${MY_PN}/archive/V${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	dev-qt/qtgui:5
	dev-qt/qtsvg:5
	dev-qt/qtx11extras:5
	kde-frameworks/kwindowsystem:5
	x11-libs/libXext
"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_PN}-${PV}/${MY_PN}"
