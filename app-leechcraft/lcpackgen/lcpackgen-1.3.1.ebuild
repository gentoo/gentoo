# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="Package creator for app-leechcraft/lc-lackman package manager"

SRC_URI="https://github.com/0xd34df00d/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

HOMEPAGE="https://leechcraft.org/"
LICENSE="Boost-1.0"

CMAKE_USE_DIR="${S}"/src

COMMON_DEPEND="dev-libs/boost
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtxml:5
	dev-qt/qtxmlpatterns:5"
DEPEND="${COMMON_DEPEND}"
RDEPEND="${COMMON_DEPEND}
	dev-qt/qtsvg:5"
