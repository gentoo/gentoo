# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="a system tray dockapp with the ability to display more than just four tray icons"
HOMEPAGE="http://sourceforge.net/projects/wmsystemtray/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXmu
	x11-libs/libXpm"
RDEPEND="${DEPEND}"
