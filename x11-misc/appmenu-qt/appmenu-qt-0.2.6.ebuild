# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit cmake-utils

DESCRIPTION="Application menu module for Qt"
HOMEPAGE="https://launchpad.net/appmenu-qt"
SRC_URI="https://launchpad.net/${PN}/trunk/${PV}/+download/${PN}-${PV}.tar.bz2"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=dev-qt/qtcore-4.8:4
	>=dev-qt/qtdbus-4.8:4
	>=dev-qt/qtgui-4.8:4
	>=dev-libs/libdbusmenu-qt-0.9.0[qt4(+)]"
RDEPEND="${DEPEND}"

DOCS=( NEWS README )
