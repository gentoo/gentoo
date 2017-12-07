# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="Qt application for getting screenshots"
HOMEPAGE="https://github.com/QtDesktop/screengrab/"
SRC_URI="https://github.com/QtDesktop/screengrab/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qttranslations:5
	dev-qt/qtwidgets:5
	dev-qt/qtx11extras:5
	dev-qt/qtnetwork:5
	kde-frameworks/kwindowsystem:5
	dev-libs/libqtxdg
	x11-libs/libX11
"
RDEPEND="${DEPEND}"
