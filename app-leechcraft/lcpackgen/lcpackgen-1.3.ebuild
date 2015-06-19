# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-leechcraft/lcpackgen/lcpackgen-1.3.ebuild,v 1.2 2014/06/28 13:18:16 maksbotan Exp $

EAPI="5"

inherit cmake-utils

DESCRIPTION="Package creator for app-leechcraft/lc-lackman package manager"

SRC_URI="https://github.com/0xd34df00d/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

HOMEPAGE="http://leechcraft.org/"
LICENSE="Boost-1.0"

CMAKE_USE_DIR="${S}"/src

COMMON_DEPEND=">=dev-libs/boost-1.46
	dev-qt/qtcore:4
	dev-qt/qtgui:4
	dev-qt/qtxmlpatterns:4"
DEPEND="${COMMON_DEPEND}"
RDEPEND="${COMMON_DEPEND}
	dev-qt/qtsvg:4"
