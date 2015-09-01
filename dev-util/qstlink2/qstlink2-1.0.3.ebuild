# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit qt4-r2

DESCRIPTION="GUI and CLI ST-Link V2(Debugger/Programmer) client"
HOMEPAGE="https://github.com/fpoussin/qstlink2"
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
