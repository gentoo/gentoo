# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/qstlink2/qstlink2-1.0.3.ebuild,v 1.3 2015/05/13 09:39:43 ago Exp $

EAPI=5

inherit qt4-r2

DESCRIPTION="GUI and CLI ST-Link V2(Debugger/Programmer) client"
HOMEPAGE="https://code.google.com/p/qstlink2/"
SRC_URI="https://github.com/mobyfab/QStlink2/archive/v1.0.3.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="virtual/libusb:0
		dev-qt/qtcore:4
		dev-qt/qtgui:4"
RDEPEND="${DEPEND}"

S="${WORKDIR}/QStlink2-${PV}"
