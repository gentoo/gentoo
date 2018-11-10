# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="Package creator for app-leechcraft/lc-lackman package manager"
HOMEPAGE="https://leechcraft.org/"
SRC_URI="https://github.com/0xd34df00d/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Boost-1.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	dev-libs/boost
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtxml:5
	dev-qt/qtxmlpatterns:5"
RDEPEND="${DEPEND}
	dev-qt/qtsvg:5"

CMAKE_USE_DIR="${S}"/src
