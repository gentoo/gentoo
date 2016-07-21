# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit cmake-utils

DESCRIPTION="Command line tool allowing user scripting of the running window manager"
HOMEPAGE="http://kde-apps.org/content/show.php/WMIface?content=40425"
SRC_URI="https://home.kde.org/~seli/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

RDEPEND="
	dev-qt/qtcore:4
	x11-libs/libX11
"
DEPEND="${DEPEND}
	dev-qt/qtgui:4
"
